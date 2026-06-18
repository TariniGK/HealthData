with members as (
    select * from {{ ref('stg_aetna_members')}}
),

eligibility as (
    select * from {{ ref('stg_aetna_eligibility') }}
)

select * from members m
left join eligibility e
on m.member_id = e.member_id