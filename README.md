# Pages Extensibility 
 Various pages developed while employed at the university of Indiana
Help Desk Manager

The Help Desk Manager page was developed to give Help Desk personnel the ability to look up any constituent affiliated with the University.  The page was intended to provide any information needed by Help Desk personnel in serving the constituents’ needs for access to University systems. This includes both staff and student information. This page was originally design to assist with ticket creation in the Parature system, which is no longer utilized. The page was also designed to give Help Desk personnel the ability to create provisioning transactions when needed (DIRXML Event).
Initial entry to the main page is an ID search page. The basic information is displayed in several sections.  There are also links to additional pages of information. Following are descriptions of each section of information.
This page will only display a limited amount of information if the logged in user looks up their own account. The ISU Account Information and Roles sections will not display.
Top of Page:
This section contains directions for updating Parature (no longer used) and the last login timestamp for Banner self-service. It also contains links to TDX and DIRXML Event submission. A search box to look up another ID is available as well as a link to Admissions and Registration Information.
 
A database query is used in this section for retrieving the last login to Banner self-service:
select TO_CHAR(twgbwses_last_access,'DD-MON-YYYY HH:MM:SS'),
            f_format_name(stupidm,'FML')
   from twgbwses
 where twgbwses_pidm = stupidm; 


DIRXML EVENT button executes an insert statement:
       INSERT INTO dirxml.eventlog
        VALUES (dirxml.seq_recid.NEXTVAL, 'pk_gobtpac_pidm=' || in_pidm,
                'N', '6', SYSDATE, USER, 'VIEW_EMP', 'INTERNET_GOREMAL_EMAIL_ADDRESS',
                 in_email_address, in_email_address);


Lookup User Info queries to get the user pidm for additional queries:
	nvl(twbkslib.f_fetchpidm(in_variable),0);

Admissions and Registration Information:
	This link calls the procedure hwzkhelp.P_DispAdmRegInfo, which opens a new page of information. More for this included later in this document.

ID Card Section:
 

This section displays information from the Public Safety ID card. It will additionally show sponsor and end date for University affiliates. It also displays work start and end dates for staff when applicable. Birthdate, SSN, and last term register are displayed.

select *
            from nzvids1
           where nzvids1_pidm = PIDM_IN;

select szbisud_guest_sponsor_pidm, szbisud_guest_end_date
        from szbisud
        where szbisud_pidm = pidm_in;

select * from dirxml.view_emp
       where pk_gobtpac_pidm = in_pidm;  -- work dates

select * from spbpers where spbpers_pidm = PIDM_IN;   -- birthdate, SSN

  select sgbstdn_stst_code,  -- is degree awarded
         stvstst_desc, -- student status
         stvstst_reg_ind,  -- reg allowed
         sgbstdn_term_code_eff,  -- Last Registered Term
         sgbstdn_term_code_grad,  -- graduation term
         to_char(sgbstdn_exp_grad_date, 'MM/DD/YYYY')  -- expected grad date
    from sgbstdn a, stvstst
   where sgbstdn_pidm = in_pidm
     and sgbstdn_stst_code = stvstst_code
     and sgbstdn_term_code_eff = (select max(b.sgbstdn_term_code_eff)
                                    from sgbstdn b
                                   where a.sgbstdn_pidm = b.sgbstdn_pidm);

User Privacy Section:
 

This section reveals information as to whether the constituent has signed the University FERPA acknowledgement.  It will also show if a student has authorized a parent/guardian for proxy access to student self-service.

   bwzkfrpa.P_DisplayFerpaTable(in_pidm,'FRP');
   bwzkfrpa.P_DisplayFerpaTable(in_pidm,'FRW');

-- Students listed for Parent
select distinct 'Student' prole,
           f_format_name(GZBWEB4PARENT_STUDENT_PIDM,'FMIL') pname,
           web4parent.F_FERPA_IND(GZBWEB4PARENT_STUDENT_PIDM) pferpa,
           gzbweb4parent_student_pidm ppidm
      FROM GZBWEB4PARENT
     WHERE GZBWEB4PARENT_PARENT_PIDM = in_pidm
    union
-- Parents listed for Student
    SELECT distinct 'Parent' prole,
           f_format_name(GZBWEB4PARENT_PARENT_PIDM,'FMIL') pname,
           web4parent.F_FERPA_IND(GZBWEB4PARENT_PARENT_PIDM) pferpa,
           gzbweb4parent_parent_pidm ppidm
      FROM GZBWEB4PARENT
     WHERE GZBWEB4PARENT_STUDENT_PIDM = in_pidm;











ISU Account Information:
 

This section includes all ICS supported applications the constituent has access to.

  select s.system_desc uid_server, a.account_name uid_user_id, a.account_type uid_user_type,
         decode(cpa.owner_flag,'Y','Owner','Not Owner') uid_owner, a.account_status uid_status
    from utr_curr_acct_pers_assoc cpa,
         utb_account a,
         utb_system s
   where cpa.pidm = in_pidm
     and cpa.account_id = a.account_id
     and a.system_code = s.system_code
   order by s.system_desc, a.account_name;

Account Roles:
 
This section will display any Banner institutional roles and University provisioning roles held by the constituent. 

select * from dirxml.view_emp
       where pk_gobtpac_pidm = in_pidm;   -- institutional and provisioning roles

select *
            from nzvids1
           where nzvids1_pidm = PIDM_IN;  -- ID card attributes

select gzbswpd_title		-- products for download
   from gzbswpd a
  where gzbswpd_status = 'A'
    and a.gzbswpd_prod_id = gzbswpd_prod_id
/** Only show those that need a security code **/
    and exists (select 'x'
                  from gzrswsc
                 where gzrswsc_prod_id = a.gzbswpd_prod_id)
    and hwzkswsc.f_check_auth(gzbswpd_prod_id,in_pidm) <> 'N'
 order by gzbswpd_title;



Addresses and Phone:
 

This section will display the staff(campus) or student address, phone, and email address when available. It will also display the current personal email address.

   select * from spraddr
    where spraddr.rowid(+) = f_get_address_rowid(pidm_in,
                                decode(nzvids1_row.nzvids1_type,'STUDENT','HDSTUD','HDSTAFF'),
                                'A', sysdate,1,decode(nzvids1_row.nzvids1_type,'STUDENT','S','P'),null);

   select * from stvbldg
    where stvbldg_code(+) = decode(spraddr_row.spraddr_atyp_code,'LO',rtrim(substr(spraddr_row.spraddr_street_line1,1,3)),
                                                                  'CA',rtrim(substr(spraddr_row.spraddr_street_line1,1,3)),'XX');

   select * from sprtele
    where sprtele.rowid(+) = fz_rpt_crnt_phone (pidm_in, decode (nzvids1_row.nzvids1_type,'STUDENT','LO','CA') );

    if nzvids1_row.nzvids1_type in ('EDUCATION AFFILIATE','BUSINESS AFFILIATE','FACULTY','STAFF','TEMPORARY') then
       email_group := 'EMPICP';
    elsif nzvids1_row.nzvids1_type = 'STUDENT' then
       email_group := 'STUDICP';
    elsif nzvids1_row.nzvids1_type = 'GUEST' then
    ( select *
       from goremal
      where goremal.rowid(+) = fz_get_email_hierarchy_rowid(nvl(nzvids1_row.nzvids1_pidm,stupidm),email_group,1,'A');)

Course Information:
 

This section will list any courses a student is currently enrolled in, or a faculty is currently teaching. It also has a link to a page that will display the student’s advisor(s) if the constituent is a student.
Student   
 select ssbsect_term_code, ssbsect_subj_code, ssbsect_crse_numb, ssbsect_seq_numb, stvschd_desc,
           decode(szvdist_crn,null,'ON-Site','OFF-Campus') site
      from szvdist b, ssbsect a, sfrstcr, stvrsts, stvschd
     where szvdist_crn(+) = sfrstcr_crn
       and szvdist_term_code(+) = sfrstcr_term_code
       and ssbsect_crn = sfrstcr_crn
       and ssbsect_term_code = sfrstcr_term_code
       and stvrsts_code = sfrstcr_rsts_code
       and stvrsts_incl_assess = 'Y'
       and stvrsts_withdraw_ind = 'N'
       and stvschd_code = ssbsect_schd_code
       and sfrstcr_term_code >= f_get_current_term
       and sfrstcr_pidm = in_pidm
     order by ssbsect_term_code asc;

Faculty
    select ssbsect_term_code, ssbsect_subj_code, ssbsect_crse_numb, ssbsect_seq_numb, stvschd_desc,
           decode(szvdist_crn,null,'ON-Site','OFF-Campus') site
      from szvdist b, ssbsect a, sirasgn, stvschd
     where szvdist_crn(+) = sirasgn_crn
       and szvdist_term_code(+) = sirasgn_term_code
       and ssbsect_crn = sirasgn_crn
       and ssbsect_term_code = sirasgn_term_code
       and stvschd_code = ssbsect_schd_code
       and sirasgn_term_code >= f_get_current_term
       and sirasgn_pidm = in_pidm
     order by ssbsect_term_code asc;








Advisor Information:
 

This page is a call to an obsoleted student self-service page (bwzksadv) and lists the advisor information. If the student has multiple advisors assigned, all will display on the page.


Admissions and Registration Information:
 

This page displays various admissions and registration information for the student.






Considerations for new page:

Items to keep:
TDX Button - research to see if we can call to person record in TDX from search
DIRXML Event - remains the same
ID section - keep  same information
ISU Account information - keep same information
Roles - keep same information
Keep email and mailing address(students), and date account was created.
Keep course section - Add CRN, remove site and type
Admission and Reg page - keep same information, TBD if this needs to be a separate page
 
Items to remove:
Remove the text between the header title and "Last Self Service login"
Remove Parent FERPA and Proxy auth
Remove Downloads and card attributes
Remove Advisor information page - only need Advisor name
 
Items to add:
Add ability to search by username and ID
Add department, office, and phone for staff (if taking classes do not display student)
Add Cell phone and home phone for students
Add Advisor name - review if accurate (Yihua updated this for Canvas)



SQL

Main Driver Table should be NZVIDS1
	Inner join SPBPERS for birthdate and SSN
Outer join SZBISUD for affiliate info
	Outer join PEBEMPL for employee work dates
	Outer join TWGBWSES for last self-service login
	

Student Addresses:
        (select trim(spraddr_street_line1)||', '||trim(spraddr_city)||', '||spraddr_stat_code||' '||spraddr_zip
           from spraddr
          where spraddr.rowid = baninst1.fz_get_rh_lo_address_rowid(pidm)),
        (select trim(spraddr_street_line1)||', '||trim(spraddr_city)||', '||spraddr_stat_code||' '||spraddr_zip
            from spraddr
           where spraddr.rowid = baninst1.FZ_RPT_CRNT_ADDR(pidm,'MA'))

Student Home Phone:
select sprtele_phone_area||'-'||substr(sprtele_phone_number, 1, 3) || '-' || substr(sprtele_phone_number, 4)
  from sprtele A
 where A.sprtele_tele_code = 'MA'
   and A.sprtele_status_ind is null
   and A.sprtele_seqno = (select max(sprtele_seqno)
                          from sprtele B
                          where B.sprtele_tele_code = 'MA'
                            and B.sprtele_status_ind is null
                            and B.sprtele_pidm = A.sprtele_pidm)
   and A.sprtele_pidm = pidm;

Student Cell Phone:
select sprtele_phone_area||'-'||substr(sprtele_phone_number, 1, 3) || '-' || substr(sprtele_phone_number, 4)
  from sprtele A
 where A.sprtele_tele_code = 'CP'
   and A.sprtele_status_ind is null
   and A.sprtele_seqno = (select max(sprtele_seqno)
                          from sprtele B
                          where B.sprtele_tele_code = 'CP'
                            and B.sprtele_status_ind is null
                            and B.sprtele_pidm = A.sprtele_pidm)
   and A.sprtele_pidm = pidm;

Student Email
select * from goremal where goremal.rowid = fz_get_email_type_rowid(pidm,'ISU','A',1);
select * from goremal where goremal.rowid = fz_get_email_type_rowid(pidm,'PER','A',1);


Staff Address:
        (select trim(spraddr_street_line1)||', '||trim(spraddr_city)||', '||spraddr_stat_code||' '||spraddr_zip
            from spraddr
           where spraddr.rowid = baninst1.FZ_RPT_CRNT_ADDR(pidm,'CA'))

Staff Phone:
select sprtele_phone_area||'-'||substr(sprtele_phone_number, 1, 3) || '-' || substr(sprtele_phone_number, 4)
  from sprtele A
 where A.sprtele_tele_code = 'CA'
   and A.sprtele_status_ind is null
   and A.sprtele_seqno = (select max(sprtele_seqno)
                          from sprtele B
                          where B.sprtele_tele_code = 'CA'
                            and B.sprtele_status_ind is null
                            and B.sprtele_pidm = A.sprtele_pidm)
   and A.sprtele_pidm = pidm;

Staff email:
select * from goremal where goremal.rowid = fz_get_email_type_rowid(pidm,'CA','A',1);
select * from goremal where goremal.rowid = fz_get_email_type_rowid(pidm,'PER','A',1);



DIRXML EVENT button executes an insert statement:
	We want to add indicator that this transaction came from a Help Desk user     
  INSERT INTO dirxml.eventlog
        VALUES (dirxml.seq_recid.NEXTVAL, 'pk_gobtpac_pidm=' || in_pidm,
                'N', '6', SYSDATE, ‘HD-‘||logged in username, 'VIEW_EMP', 'INTERNET_GOREMAL_EMAIL_ADDRESS',
                 in_email_address, in_email_address);


Work Dates:
TO_CHAR (pebempl_current_hire_date, 'MM/DD/YYYY'),
TO_CHAR (pebempl_last_work_date, 'MM/DD/YYYY'),

Roles:
FZ_INSTITUTION_ROLES (PIDM)
FZ_PROVISION_ROLES (PIDM)

Student and Faculty Course SQL
	Add SSBSECT_CRN, remove STVSCHD_DESC & SZVDIST_CRN
