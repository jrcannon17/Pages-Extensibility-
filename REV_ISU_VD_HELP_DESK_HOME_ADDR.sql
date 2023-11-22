SELECT DISTINCT rowidtochar(spriden.ROWID) as "id",
(':'||
(select trim(spraddr_street_line1)||', '||trim(spraddr_city)||', '||spraddr_stat_code||' '||spraddr_zip
from spraddr
where spraddr.rowid = baninst1.FZ_RPT_CRNT_ADDR(spriden_pidm,'MA')) ||' ~ '||
(select sprtele_phone_area||'-'||substr(sprtele_phone_number, 1, 3) || '-' ||
case
    when instr(sprtele_phone_number,'-') > 0 then substr(sprtele_phone_number, 5)
    else substr(sprtele_phone_number, 4)
end
from sprtele A
where A.sprtele_seqno = (select max(sprtele_seqno) 
                          from sprtele B 
                          where B.sprtele_tele_code = 'MA' 
                            and B.sprtele_status_ind is null 
                            and B.sprtele_pidm = A.sprtele_pidm) 
   and A.sprtele_pidm = spriden_pidm) ||' ~ '||
(select goremal_email_address from goremal where goremal.rowid = fz_get_email_type_rowid(spriden_pidm,'PER','A',1)))HOME_OLD,
case 
    when pebempl_empl_status is null 
        then (':'||
            (select trim(spraddr_street_line1)||', '||trim(spraddr_city)||', '||spraddr_stat_code||' '||spraddr_zip 
               from spraddr 
              where spraddr.rowid = baninst1.FZ_RPT_CRNT_ADDR(spriden_pidm,'MA')) ||' ~ '||
            (select sprtele_phone_area||'-'||substr(sprtele_phone_number, 1, 3) || '-' ||
            case 
                when instr(sprtele_phone_number,'-') > 0 then substr(sprtele_phone_number, 5)
                else substr(sprtele_phone_number, 4)
            end
              from sprtele A
             where A.sprtele_seqno = (select max(sprtele_seqno) 
                                      from sprtele B 
                                      where B.sprtele_tele_code = 'MA'
                                        and B.sprtele_status_ind is null
                                        and B.sprtele_pidm = A.sprtele_pidm)
               and A.sprtele_pidm = spriden_pidm) ||' ~ '||
            (select goremal_email_address from goremal where goremal.rowid = fz_get_email_type_rowid(spriden_pidm,'PER','A',1)))
        else (select goremal_email_address from goremal where goremal.rowid = fz_get_email_type_rowid(spriden_pidm,'PER','A',1))
end HOME_NEW
from spriden
inner join gobtpacv
on pidm = spriden_pidm
left outer join pebempl  -- if found, indicates staff/faculty
    on pebempl_pidm = spriden_pidm
        and pebempl_ecls_code not in ('GS','ST','SW','SX')
WHERE ((:id_param like '99%' and spriden_id = :id_param) or (external_user =  LOWER(:id_param)))
AND spriden_change_ind IS NULL;
