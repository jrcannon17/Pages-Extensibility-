create or replace FUNCTION          fz_reg_elig (in_pidm     IN spriden.spriden_pidm%TYPE,
                                                 in_reason   IN VARCHAR2 DEFAULT NULL)
    -- June 2023
    -- Registration Eligibility Function
    -- lives in ../ISU/general/dbprocs/create_reg_elig.sql
    -- Code adapted from HWZKHELP. Function created so that values can easily be obtained in PageBuilder
    -- Returns [reg allowed] by default. To return [reason] pass in 'R'
    -- Test examples:
    -- select fz_reg_elig(1309029) from dual;
    -- select fz_reg_elig(1309029,'R') from dual;
    RETURN VARCHAR2
IS
    lv_sobterm_readm_req   sobterm.sobterm_readm_req%TYPE DEFAULT NULL;
    lv_admit_term          sorlcur.sorlcur_term_code_admit%TYPE DEFAULT NULL;
    lv_msg                 VARCHAR2 (250) DEFAULT NULL;
    lv_term_code_eff       sgbstdn.sgbstdn_term_code_eff%TYPE DEFAULT NULL;
    lv_exp_grad_date       sgbstdn.sgbstdn_exp_grad_date%TYPE DEFAULT NULL;
    out_reg_allowed        VARCHAR2 (3) DEFAULT NULL;
    out_reason             VARCHAR2 (250) DEFAULT NULL;

    CURSOR getsobtermrowc IS
        SELECT sobterm_readm_req
        FROM   sobterm
        WHERE  sobterm_term_code = f_get_current_term (SYSDATE);

    CURSOR getgenstudinfoc IS
        SELECT stvstst_reg_ind, sgbstdn_term_code_eff, sgbstdn_exp_grad_date
        FROM   sgbstdn a, stvstst
        WHERE  sgbstdn_pidm = in_pidm
               AND sgbstdn_stst_code = stvstst_code
               AND sgbstdn_term_code_eff = (SELECT MAX (b.sgbstdn_term_code_eff)
                                            FROM   sgbstdn b
                                            WHERE  a.sgbstdn_pidm = b.sgbstdn_pidm);
BEGIN
    OPEN getgenstudinfoc;

    FETCH getgenstudinfoc
        INTO out_reg_allowed, lv_term_code_eff, lv_exp_grad_date;

    IF getgenstudinfoc%NOTFOUND
    THEN
        out_reason := 'Registration status not found';
    END IF;

    CLOSE getgenstudinfoc;

    OPEN getsobtermrowc;

    FETCH getsobtermrowc
        INTO lv_sobterm_readm_req;

    CLOSE getsobtermrowc;

    lv_admit_term :=
        sokccur.f_curriculum_value (p_pidm        => in_pidm,
                                    p_lmod_code   => sb_curriculum_str.f_learner,
                                    p_term_code   => f_get_current_term (SYSDATE),
                                    p_key_seqno   => 99,
                                    p_eff_term    => f_get_current_term (SYSDATE),
                                    p_order       => 1,
                                    p_field       => 'TADMIT');

    IF bwckregs.f_readmit_required (f_get_current_term (SYSDATE),
                                    in_pidm,
                                    lv_admit_term,
                                    lv_sobterm_readm_req)
    THEN
        -- added the check for the ISU Registration eligibility also
        -- bwzkregs.F_CheckRegStatus ultimately uses term <= sgbstdn_term_code_eff
        -- so someone admitted for a future term isn't seen using f_get_current_term as term
        lv_msg := bwzkregs.f_checkregstatus (in_pidm, f_get_current_term (SYSDATE));

        IF lv_msg IS NOT NULL
        THEN
            out_reg_allowed := 'N';

            IF lv_msg = 'TERM_GRAD'
            THEN
                out_reason :=
                       'Registration is not allowed past the expected graduation date of '
                    || TO_CHAR (lv_exp_grad_date, 'MM/DD/YYYY')
                    || '.  Student must reapply for graduation.';
            ELSIF lv_msg = 'TERM_EFF'
            THEN
                out_reason := 'Non-degree students must be readmitted each term';
            END IF;
        ELSE
            out_reg_allowed := 'N';
            out_reason := 'Student must be readmitted';
        END IF;
    ELSE
        -- Checking for ISU Registration eligibility
        -- Using term_code_eff catches students who have been readmitted for future terms
        lv_msg := bwzkregs.f_checkregstatus (in_pidm, lv_term_code_eff);

        IF lv_msg IS NOT NULL
        THEN
            out_reg_allowed := 'N';

            IF lv_msg = 'TERM_GRAD'
            THEN
                out_reason :=
                       'Registration is not allowed past the expected graduation date of '
                    || TO_CHAR (lv_exp_grad_date, 'MM/DD/YYYY')
                    || '.  Student must reapply for graduation.';
            ELSIF lv_msg = 'TERM_EFF'
            THEN
                out_reason := 'Non-degree students must be readmitted each term';
            END IF;
        ELSE
            IF out_reg_allowed = 'Y'
            THEN
                out_reg_allowed := 'Y';
                out_reason := 'Cleared for Registration';
            END IF;
        END IF;
    END IF;

    -- stvstst_reg_ind returns 'N' or 'Y'. Convert to Yes or No
    IF out_reg_allowed = 'Y'
    THEN
        out_reg_allowed := 'Yes';
    ELSIF out_reg_allowed = 'N'
    THEN
        out_reg_allowed := 'No';
    END IF;

    IF UPPER (in_reason) = 'R'
    THEN
        RETURN out_reason;
    END IF;

    RETURN out_reg_allowed;
END fz_reg_elig;