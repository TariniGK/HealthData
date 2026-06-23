with mart as (
    select * from {{ ref('int_members_claims')}}
)

select * from mart