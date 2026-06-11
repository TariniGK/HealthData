with source as (
    select * from {{ source('raw','TMP_AETNA_CLAIMS')}}
)

select * from source
