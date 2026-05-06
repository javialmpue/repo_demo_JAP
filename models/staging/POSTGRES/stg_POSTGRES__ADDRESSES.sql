{{ config(
    materialized='incremental',
    unique_key = 'address_id',
    incremental_strategy='append'
) }}


with source as (

    select * 
    from {{ source('POSTGRES', 'ADDRESSES') }}
{% if is_incremental() %}
    WHERE _fivetran_synced > (SELECT MAX(_fivetran_synced) FROM {{ this }})
{% endif %}
),

renamed as (

    select
        address_id,
        zipcode,
        country,
        address,
        state,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed