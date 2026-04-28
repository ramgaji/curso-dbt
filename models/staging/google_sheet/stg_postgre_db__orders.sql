{{ config(materialized='view') }}

WITH src_orders AS (

    SELECT *
    FROM {{ source('postgre_db', 'ORDERS') }}

),

renamed_casted AS (

    SELECT
        *
    FROM src_orders

)

SELECT * FROM renamed_casted