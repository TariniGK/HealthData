with eligibility as (
    select * from {{ ref('stg_aetna_eligibility')}}
),

claims as (
    select * from {{ ref('stg_aetna_claims')}}
)

select 
{{ dbt_utils.generate_surrogate_key(['c.member_id']) }} as member_pk,
c.claim_id,
c.member_id,
date_trunc('month',c.service_date) as month_processed,
sum(c.paid_amount) as total_spent_amount,
count(c.claim_id) as total_claim_processed,
from claims c
left join eligibility e on 
c.member_id = e.member_id
group by c.claim_id,c.member_id,date_trunc('month',c.service_date)

