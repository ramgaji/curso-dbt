{{ config(
    materialized='incremental',
    incremental_strategy='delete+insert',
    unique_key='address_id'
) }}

WITH src AS (

    SELECT *
    FROM {{ source('postgre_db', 'addresses') }}

),

final AS (

    SELECT
        ADDRESS_ID,
        ZIPCODE,
        COUNTRY,
        ADDRESS,
        STATE,
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