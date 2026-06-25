
with claim_plans as (
    select * from {{ ref('int_provider_claims')}}
)

select * from claim_plans

