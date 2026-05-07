select *
from {{ ref('stg_postgre_db__orders') }}
where estimated_delivery_at < created_at