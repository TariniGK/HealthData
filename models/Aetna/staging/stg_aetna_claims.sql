-- Describes the aetna claims
with source_data as (
    select * from {{ source('raw','TMP_AETNA_CLAIMS')}}
),

renamed as (
select 
cast(trim(claim_id) as varchar) as claim_id,
cast(trim(member_id) as varchar) as member_id,
cast(trim(provider_id) as varchar) as provider_id,
coalesce(upper(trim(claim_type)),'UNKNOWN') as claim_type,
coalesce(try_cast(trim(service_date) as date),'1900-01-01') as service_date,
try_to_decimal(trim(claim_amount), 18, 2) as claim_amount,
coalesce(upper(trim(cast(claim_status as varchar))), 'UNKNOWN') as claim_status,
upper(trim(diagnosis_code)) as diagnosis_code,
cast(load_sk as varchar) as _load_sk,
cast(run_pipeline_id as varchar) as _run_pipeline_id,
cast(dw_inserted_at as timestamp_ntz) as _dw_inserted_at
from source_data
),

dedup as (
    select *
    from renamed
    qualify row_number() over(partition by claim_id order by service_date desc ) = 1
)

select * from dedup




