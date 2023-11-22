SELECT * 
FROM stvrsts;

SELECT *
FROM sfrstcr
WHERE sfrstcr_term_code = '202301' AND sfrstcr_rsts_code =  'RW';
--SFRSTCR_LEVL_CODE 
--G for GRAD
--U for Undergrad

--Student
select a.*

      from szvdist b, ssbsect a, sfrstcr, stvrsts, stvschd, spriden, gobtpacv 

     where szvdist_crn(+) = sfrstcr_crn 

       and szvdist_term_code(+) = sfrstcr_term_code 

       and ssbsect_crn = sfrstcr_crn 

       and ssbsect_term_code = sfrstcr_term_code 

       and stvrsts_code = sfrstcr_rsts_code 

       and stvrsts_incl_assess = 'Y' 

       and stvrsts_withdraw_ind = 'N' 

       and stvschd_code = ssbsect_schd_code 

       and sfrstcr_term_code >= '202301' 

       and sfrstcr_pidm = spriden_pidm
       and pidm = spriden_pidm
       and ((:id_param like '99%' and spriden_id = :id_param) or (external_user =  LOWER(:id_param)))
       and spriden_change_ind is null
     order by ssbsect_term_code asc; 
     
     
                                        select DISTINCT szvgrd1_apdc_desc admissions_status, 
       szvgrd1_term_code_entry_key admit_term,
       TO_CHAR(szvgrd1_apdc_date, 'MM/dd/yyyy') app_decision_date,
       stvstyp_desc student_type,

       GOKODSF.F_GET_DESC((select f_astd_end_of_term(szvgrd1_pidm_key, SZVTERM_PREVIOUS) from szvterm),'STVASTD') as class_standing,  
        ( select decode(calc_classification('G', shrlgpa_hours_earned), 
               'GRD','Graduate','FR1','Freshman 1','FR2','Freshman 2','SO1','Sophomore 1','SO2','Sophomore 2',
               'JR1','Junior 1','JR2','Junior 2','SR1','Senior 1','SR2','Senior2','Freshman 1') 
            from shrlgpa
            where shrlgpa_pidm = szvgrd1_pidm_key
            and shrlgpa_levl_code = 'G'--saradap_levl_code 
            and shrlgpa_gpa_type_ind = 'O') as classification,  
        NVL((select 'Yes'
          from sprhold, stvhldd
         where sprhold_pidm = szvgrd1_pidm_key
           and sprhold_hldd_code = stvhldd_code
           and (sprhold_to_date > sysdate or sprhold_to_date is null)
           and stvhldd_reg_hold_ind = 'Y'),'No') registration_holds,
         NVL((select 'Yes'
            from sprhold, stvhldd
           where sprhold_pidm = szvgrd1_pidm_key
             and sprhold_hldd_code = stvhldd_code
               and (sprhold_to_date > sysdate or sprhold_to_date is null)
             and stvhldd_grade_hold_ind = 'Y'),'No') grade_holds
  from szvgrd1_mv a, stvstyp, spriden 
  inner join gobtpacv
    on pidm = spriden_pidm
 where ((:id_param like '99%' and spriden_id = :id_param)
   or (external_user = LOWER(:id_param)))
   and spriden_change_ind is null
   and szvgrd1_pidm_key = spriden_pidm
   and szvgrd1_styp_code = stvstyp_code
   and szvgrd1_admit_ind = 'Y'
   and szvgrd1_term_code_entry_key = (select max(b.szvgrd1_term_code_entry_key)
                                    from szvgrd1 b
                                   where a.szvgrd1_pidm_key = b.szvgrd1_pidm_key);
                                   
                                   
                              ----UGRAD_ADM     
select szvadm1_apdc_desc  admissions_status,
       szvadm1_term_code_entry admit_term,
       TO_CHAR(szvadm1_apdc_date,'HH/mm/yyyy') app_decision_date,
       stvstyp_desc student_type,
       GOKODSF.F_GET_DESC((select f_astd_end_of_term(szvadm1_pidm,SZVTERM_PREVIOUS) from szvterm),'STVASTD') as class_standing, --need previous term code
        ( select decode(calc_classification('U', shrlgpa_hours_earned),   -- need student's level code
               'GRD','Graduate','FR1','Freshman 1','FR2','Freshman 2','SO1','Sophomore 1','SO2','Sophomore 2',
               'JR1','Junior 1','JR2','Junior 2','SR1','Senior 1','SR2','Senior2','Freshman 1') 
            from shrlgpa
            where shrlgpa_pidm = szvadm1_pidm
            and shrlgpa_levl_code = 'G'  -- need student's level code
            and shrlgpa_gpa_type_ind = 'O') as classification,
        NVL((select 'Yes'
          from sprhold, stvhldd
         where sprhold_pidm = szvadm1_pidm
           and sprhold_hldd_code = stvhldd_code
           and (sprhold_to_date > sysdate or sprhold_to_date is null)
           and stvhldd_reg_hold_ind = 'Y'),'No') registration_holds,
         NVL((select 'Yes'
            from sprhold, stvhldd
           where sprhold_pidm = szvadm1_pidm
             and sprhold_hldd_code = stvhldd_code
               and (sprhold_to_date > sysdate or sprhold_to_date is null)
             and stvhldd_grade_hold_ind = 'Y'),'No') grade_holds
  from szvadm1_mv a, stvstyp, spriden
  inner join gobtpacv
    on pidm = spriden_pidm
 where ((:id_param like '99%' and spriden_id = :id_param)
   or (external_user = LOWER(:id_param)))
   and
  szvadm1_pidm = spriden_pidm
   and szvadm1_styp_code = stvstyp_code
   and szvadm1_admit_ind = 'Y'
   and szvadm1_term_code_entry = (select max(b.szvadm1_term_code_entry)
                                    from szvadm1 b
                                   where a.szvadm1_pidm = b.szvadm1_pidm);