select DISTINCT szvgrd1_apdc_desc admissions_status, 
       szvgrd1_term_code_entry_key admit_term,
       szvgrd1_apdc_date app_decision_date,
       stvstyp_desc student_type,

       -- INVALID INDTIFIER IN PB: 'GOKODSF.'
       F_GET_DESC((select f_astd_end_of_term(szvgrd1_pidm_key, SZVTERM_PREVIOUS) from szvterm),'STVASTD') as class_standing,  
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