{{ config(
    materialized='incremental',
    unique_key='order_id'
) }}

WITH src AS (

    SELECT *
    FROM {{ source('postgre_db', 'orders') }}

),

final AS (

    SELECT
        ORDER_ID,
        USER_ID,
        PROMO_ID,
        ADDRESS_ID,
        CREATED_AT,
        SHIPPING_SERVICE,
        SHIPPING_COST,
        ESTIMATED_DELIVERY_AT,
        ORDER_COST,
        STATUS,
        _FIVETRAN_DELETED,
        _FIVETRAN_SYNCED

    FROM src

    {% if is_incremental() %}
    WHERE _FIVETRAN_SYNCED > (
        SELECT MAX(_FIVETRAN_SYNCED)
        FROM {{ this }}
    )
    {% endif %}

)

SELECT * FROM final