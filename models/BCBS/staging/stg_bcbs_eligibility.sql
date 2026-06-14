with source as (
    select * from {{ source('raw','TMP_AETNA_ELIGIBILITY')}}
),

renamed as (
select 
trim(member_id) as member_id,
trim(plan_id) as plan_id,
coalesce(try_cast(trim(coverage_start) as date),'1900-01-01') as coverage_start,
upper(trim(eligibility_status)) as eligibility_status,
iff(upper(trim(eligibility_status)) = 'ACTIVE', true, false) as is_eligible,
cast(load_sk as varchar) as load_sk,
run_pipeline_id as _run_pipeline_id,
dw_inserted_at as _dw_inserted_at 
from source),

dedup as (
    select * 
    from renamed
    qualify row_number() over(partition by member_id order by coverage_start desc) = 1
)

select * from dedup