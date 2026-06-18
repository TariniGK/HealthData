with members as (
    select * from {{ ref('stg_aetna_members')}}
),

eligibility as (
    select * from {{ ref('stg_aetna_eligibility') }}
)

select 
{{ dbt_utils.generate_surrogate_key(['M.member_id']) }} as member_pk,
M.member_id,
E.plan_id,
M.member_name,
M.state,
M.email,
M.phone_number,
E.eligibility_status,
E.is_eligible,
from members M
left join eligibility E
ON M.member_id = E.member_id
group by M.member_id,M.member_name,E.plan_id,M.state,M.email,
E.eligibility_status,E.is_eligible,M.phone_number

