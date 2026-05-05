{{ config(
    materialized='incremental',
    unique_key='product_id'
) }}

WITH src AS (

    SELECT *
    FROM {{ source('postgre_db', 'products') }}

),

final AS (

    SELECT
        PRODUCT_ID,
        NAME,
        PRICE,
        INVENTORY,
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