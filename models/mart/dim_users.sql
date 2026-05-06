{{ config(
    materialized='table',
    tags=['mart']
) }}

with stg_users as (
    select * from {{ ref('stg_POSTGRES__USER') }}
),

dim_users_transformacion as (
    select
        user_id,
        first_name,
        last_name,
        first_name || ' ' || last_name as full_name,
        email,
        phone_number,
        address_id,
        cast(created_at as timestamp_ntz) as created_at_utc,
        cast(updated_at as timestamp_ntz) as updated_at_utc,
        total_orders
    from stg_users
)

select * from dim_users_transformacion
