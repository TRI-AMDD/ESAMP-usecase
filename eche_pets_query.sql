set
    search_path = 'public_release';

with printed as (
    select 
        s.id as sample_id,
        s.label as sample_label
    from
        sample_process sp 
        join process p on p.id = sp.process_id
        join process_detail pd on pd.id = p.process_detail_id
        join sample s on s.id = sp.sample_id
    where
        true 
        and pd.type = 'print'
        and pd.technique = 'INKJET'
),
measured as (
select
    printed.sample_id,
    printed.sample_label,
    sp.id as sample_process_id,
    p.machine_name,
    p.timestamp,
    pd.type,
    pd.technique,
    pd.parameters->'solution_ph' as solution_ph,
    pd.parameters->'current_abs' as current_abs,
    pd.parameters->'reference_e0' as reference_e0,
    pd.parameters->'acquisition_time' as acquisition_time
from
    printed
    join sample_process sp on sp.sample_id = printed.sample_id
    join process p on p.id = sp.process_id
    join process_detail pd on pd.id = p.process_detail_id
where
    true 
    and pd.type in ('eche', 'pets')
)
select
    *
from
    measured
where
    true