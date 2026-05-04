{{ config(materialized='table') }}

WITH orders AS (

    SELECT *
    FROM {{ ref('stg_postgre_db__orders') }}

),

addresses AS (

    SELECT *
    FROM {{ ref('stg_postgre_db__addresses') }}

),

users AS (

    SELECT *
    FROM {{ ref('stg_postgre_db__users') }}

),

final AS (

    SELECT
        o.ORDER_ID AS order_id,
        o.USER_ID AS user_id,
        o.ADDRESS_ID AS address_id,
        a.COUNTRY AS address_country,
        TRY_CAST(REPLACE(o.ORDER_COST::STRING, ',', '.') AS NUMBER(18, 2)) AS order_total,
        o.CREATED_AT AS order_date,
        o.STATUS AS status

    FROM orders o
    INNER JOIN addresses a
        ON o.ADDRESS_ID = a.ADDRESS_ID
    INNER JOIN users u
        ON o.USER_ID = u.USER_ID

)

SELECT * FROM final