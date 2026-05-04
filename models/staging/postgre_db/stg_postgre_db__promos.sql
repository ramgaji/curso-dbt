{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='PROMO_ID'
) }}

WITH src AS (

    SELECT *
    FROM {{ source('postgre_db', 'promos') }}

),

final AS (

    SELECT
        PROMO_ID,
        DISCOUNT,
        STATUS,
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