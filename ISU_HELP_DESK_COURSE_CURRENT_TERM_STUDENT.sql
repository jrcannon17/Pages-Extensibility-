select 


CASE 
    WHEN ssbsect_subj_code IS NULL THEN 1
    ELSE ROW_NUMBER()  OVER (
ORDER BY ssbsect_subj_code) 
    END AS counter,

ssbsect_term_code, ssbsect_crn, ssbsect_subj_code, ssbsect_crse_numb, ssbsect_seq_numb 

      from ssbsect a, sfrstcr, stvrsts, stvschd, spriden, gobtpacv 

     where  
      

    ssbsect_crn = sfrstcr_crn 

    and ssbsect_term_code = sfrstcr_term_code 

    and stvrsts_code = sfrstcr_rsts_code 

    and stvrsts_incl_assess = 'Y' 

    and stvrsts_withdraw_ind = 'N' 

    and stvschd_code = ssbsect_schd_code 

    and sfrstcr_term_code >= f_get_current_term
    and sfrstcr_pidm = spriden_pidm
    and pidm = spriden_pidm and ((:id_param like '99%' and spriden_id = :id_param) or (external_user =  LOWER(:id_param)))
    and spriden_change_ind is null
    order by ssbsect_term_code asc;