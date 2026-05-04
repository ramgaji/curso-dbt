{{ config(
    materialized='incremental',
    unique_key='USER_ID'
) }}

WITH src AS (

    SELECT *
    FROM {{ source('postgre_db', 'users') }}

),

final AS (

    SELECT
        USER_ID,
        FIRST_NAME,
        LAST_NAME,
        EMAIL,
        PHONE_NUMBER,
        ADDRESS_ID,
        CREATED_AT,
        UPDATED_AT,
        TOTAL_ORDERS,
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