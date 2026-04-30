{% snapshot budget_snapshot_timestamp %}

{{
    config(
        target_database='DE56_DEV_SILVER_DB',
        target_schema='SNAPSHOTS',
        unique_key='_ROW',
        strategy='timestamp',
        updated_at='_FIVETRAN_SYNCED'
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