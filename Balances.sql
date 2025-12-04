select SUM(prb.balance_value), prgd.payroll_relationship_number, ppa.payroll_id , hou.name, prb.area1
        from
             pay_run_balances           prb
            ,pay_pay_relationships_dn   prgd
            ,pay_payroll_rel_actions    ppra
            ,pay_payroll_actions        ppa
            ,pay_defined_balances       pdb
            ,pay_balance_dimensions     pbd
            ,pay_balance_types_vl       pbt
            ,per_tax_reporting_units    ptru
            ,pay_rel_groups_dn          prgn
			, HR_ALL_ORGANIZATION_UNITS HOu
        where prb.balance_value > 0
        --  and ltrim(trim(decode(pac.area1, 0, null, pac.area1))) = prb.area1
          and ppa.action_type in ('R','B','V','Q','I')
          AND PPRA.PAYROLL_ACTION_ID       = PPA.PAYROLL_ACTION_ID
          AND prgd.payroll_relationship_id = PPRA.payroll_relationship_id
          and prgn.payroll_relationship_id = prgd.payroll_relationship_id
        --  and prgn.assignment_id = paam.assignment_id
        --  and prgn.parent_rel_group_id = p_asg.payroll_term_id
          and prgn.group_type = 'A'
          and ptru.organization_id = prb.tax_unit_id
          AND PRB.PAYROLL_REL_ACTION_ID    = PPRA.PAYROLL_REL_ACTION_ID
          AND prb.payroll_relationship_id = prgd.payroll_relationship_id 
          AND ppra.retro_component_id IS NULL
          and pdb.defined_balance_id = prb.defined_balance_id
          AND pbd.balance_dimension_id = pdb.balance_dimension_id
          AND pbt.balance_type_id = pdb.balance_type_id
          and pbd.base_dimension_name in ('Core Relationship No Calculation Breakdown, Tax Unit, Area1 Run')
          and pbt.balance_name in ('SUI Employer Reduced Subject Withholdable')
          AND prb.effective_date between :P_PROCESS_START_DATE AND :P_PROCESS_END_DATE
          and prgd.person_id = 100000010544064
        --  and ptru.organization_id = tru.organization_id
        --  and ppa.payroll_id = p_asg.payroll_id 
		
		and ptru.organization_id  = hou.organization_id

GROUP BY prgd.payroll_relationship_number, ppa.payroll_id , hou.name, prb.area1