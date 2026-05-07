WITH src_budget AS (

    SELECT *
    FROM {{ source('google_sheet', 'BUDGET') }}

),

renamed_casted AS (

    SELECT
        *
    FROM src_budget

)

SELECT * FROM renamed_casted