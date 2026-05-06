{{ config(
    materialized='incremental',
    unique_key = 'order_id',
    incremental_strategy='delete+insert'
) }}


with source as (

    select * 
    from {{ source('POSTGRES', 'ORDERITEMS') }}
    {% if is_incremental() %}
    WHERE _fivetran_synced > (SELECT MAX(_fivetran_synced) FROM {{ this }})
    {% endif %}
),

renamed as (

    select
        order_id,
        product_id,
        quantity,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed