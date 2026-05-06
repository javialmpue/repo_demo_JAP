{{ config(
    materialized='incremental',
    unique_key = '_row',
    incremental_strategy='merge'
) }}


with source as (

    select * 
    from {{ source('google', 'budget') }}
    {% if is_incremental() %}
        WHERE _row > (SELECT MAX(_row) FROM {{ this }})
    {% endif %}
),

renamed as (

    select
        _row,
        quantity,
        cast(month as date) as budget_month,
        product_id,
        _fivetran_synced
    from source

)

select * from renamed