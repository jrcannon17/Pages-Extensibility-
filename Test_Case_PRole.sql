--Test case for faculty 
select *
from szvprov
--where szvprov_roles like '%CFAC%CSTU%';
where szvprov_roles = 'CFAC';

--where szvprov_roles like '%CFAC%CSTU%';

select spriden_id 
from spriden 
where spriden_pidm = 2002405;



select DISTINCT s1.saradap_levl_code
  from saradap s1
inner join spriden
on spriden_pidm = s1.saradap_pidm
inner join gobtpacv
    on pidm = spriden_pidm
where ((:id_param like '99%' and spriden_id = :id_param)
   or (external_user = LOWER(:id_param)))
  and spriden_change_ind is null and s1.saradap_pidm = spriden_pidm
   and s1.saradap_term_code_entry = (select max(s2.saradap_term_code_entry)
                                 from saradap s2
                                 where s2.saradap_pidm = s1.saradap_pidm);
                                 
gurassl_audit_time

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
                                    from szvgrd1_mv b
                                   where a.szvgrd1_pidm_key = b.szvgrd1_pidm_key);
                                   
                                   
select * 
from wtailor.twgrrole
where twgrrole_role = 'HELP'
FETCH FIRST 10 ROWS ONLY;


-- select *

--   from virtual_domain

-- where virtual_domain_owner = 'JCANNON20';