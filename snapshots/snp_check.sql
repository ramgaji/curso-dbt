{% snapshot budget_snapshot_check %}

{{
    config(
        target_database='DE56_DEV_SILVER_DB',
        target_schema='SNAPSHOTS',
        unique_key='_ROW',
        strategy='check',
        check_cols=['QUANTITY']
    )
}}

SELECT
    _ROW,
    PRODUCT_ID,
    QUANTITY,
    MONTH,
    _FIVETRAN_SYNCED
FROM {{ source('google_sheet', 'BUDGET') }}

{% endsnapshot %}