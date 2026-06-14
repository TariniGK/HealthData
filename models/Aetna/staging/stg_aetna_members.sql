with source as (
    select * from {{ source('raw','TMP_AETNA_MEMBERS')}}
),
renamed as (
    select
    trim(cast(member_id as varchar)) as member_id,
    trim(cast(member_name as varchar)) as member_name,
    coalesce(cast(dob as date),NULL) as birth_date,
    case when upper(trim(gender)) = 'M' then 'MALE'
    when upper(trim(gender)) = 'F' then 'FEMALE'
    else 'UNKNOWN' end as gender,
    upper(trim(cast(state as varchar))) as state,
    lower(cast(email as varchar)) as email,
    coalesce(cast(cast(phone as bigint)as varchar),'UNKNOWN') as phone_number,
    load_sk,
    run_pipeline_id,
    current_timestamp() as dw_inserted_at
    from source
    where member_id is not null

),

dedup as (
    select *
    from renamed
    qualify row_number() over(partition by member_id order by load_sk) = 1
)


select * from dedup



