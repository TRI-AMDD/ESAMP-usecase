set
    search_path = 'public_release';

with printed as (
    select 
        s.id as sample_id,
        s.label as sample_label,
        sp.id as print_spid,
        s.inkjet_composition as inkjet_composition,
        p.machine_name as printer_name
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
annealed as (
    select
        printed.sample_id,
        printed.sample_label,
        printed.print_spid,
        printed.inkjet_composition,
        printed.printer_name,
        anneal_p.machine_name as furnace_name,
        anneal_pd.parameters->'max_temperature' as max_temperature,
        anneal_pd.parameters->'elements' as anneal_elements
    from
        printed
        join sample_process anneal_sp on anneal_sp.sample_id = printed.sample_id
        join process anneal_p on anneal_p.id = anneal_sp.process_id
        join process_detail anneal_pd on anneal_pd.id = anneal_p.process_detail_id 
    where
        true 
        and anneal_pd.type = 'anneal'
),
measured as (
    select
        annealed.sample_id,
        annealed.sample_label,
        annealed.print_spid,
        annealed.inkjet_composition,
        annealed.printer_name,
        annealed.furnace_name,
        annealed.max_temperature,
        annealed.anneal_elements,
        meas_sp.id as sample_process_id,
        meas_p.machine_name,
        meas_p.timestamp,
        meas_pd.type,
        meas_pd.technique,
        meas_pd.parameters->'solution_ph' as solution_ph,
        meas_pd.parameters->'current_abs' as current_abs,
        meas_pd.parameters->'reference_e0' as reference_e0,
        meas_pd.parameters->'acquisition_time' as acquisition_time,
        meas_ad.name as analysis_name,
        meas_a.output->'Eta.V_ave' as EtaV_ave,
        meas_a.output->'Eta.V_Ithresh' as EtaV_Ithresh
    from
        annealed
        join sample_process meas_sp on meas_sp.sample_id = annealed.sample_id
        join process meas_p on meas_p.id = meas_sp.process_id
        join process_detail meas_pd on meas_pd.id = meas_p.process_detail_id
        join sample_process_process_data meas_sppd on meas_sppd.sample_process_id = meas_sp.id
        join process_data meas_pdat on meas_pdat.id = meas_sppd.process_data_id
        join process_data_analysis meas_pda on meas_pda.process_data_id = meas_pdat.id
        join analysis meas_a on meas_pda.analysis_id = meas_a.id
        join analysis_details meas_ad on meas_a.analysis_detail_id = meas_ad.id
    where
        true 
        and meas_pd.type = 'eche'
        and (meas_pd.technique like 'CP%' or meas_pd.technique like 'CV%')
        and meas_ad.name in ('CP_FOMS_standard', 'cv_foms_specifictoggle_ithresh3e-5', 'cv_foms_specifictoggle_ithresh1e-4')
)
select
    *
from
    measured
where
    true