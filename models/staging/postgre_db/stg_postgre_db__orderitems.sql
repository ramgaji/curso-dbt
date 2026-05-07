{{ config(
    materialized='incremental',
    unique_key=['ORDER_ID', 'PRODUCT_ID']
) }}

WITH src AS (

    SELECT *
    FROM {{ source('postgre_db', 'orderitems') }}

),

final AS (

    SELECT
        ORDER_ID,
        PRODUCT_ID,
        QUANTITY,
        _FIVETRAN_DELETED,
        _FIVETRAN_SYNCED
    FROM src

    {% if is_incremental() %}
    WHERE _FIVETRAN_SYNCED > (
        SELECT MAX(_FIVETRAN_SYNCED) FROM {{ this }}
    )
    {% endif %}

)

SELECT * FROM final