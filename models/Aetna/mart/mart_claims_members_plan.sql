
with claim_plans as (
    select * from {{ ref('int_provider_claims')}}
),

members_plans as (
    select * from {{ ref('int_member_eligibilty')}}
)

select * from 
claim_plans c
join member_plans m
on c.member_pk = m.member_pk