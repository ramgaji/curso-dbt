{% snapshot budget_snapshot_hard_deletes_ignore %}

{{
    config(
        target_database='DE56_DEV_SILVER_DB',
        target_schema='SNAPSHOTS',
        unique_key='_ROW',
        strategy='timestamp',
        updated_at='_FIVETRAN_SYNCED',
        hard_deletes='ignore'
    )
}}

SELECT *
FROM {{ source('google_sheet', 'BUDGET') }}

{% endsnapshot %}