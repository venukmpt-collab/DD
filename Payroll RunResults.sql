SELECT
        Target.THIRD_PARTY_PAYEE_ID     ,
        Target.payroll_term_id          ,
        Target.Base_Classification      ,
        Target.result_value             ,
        Target.payroll_rel_action_id    ,
        Target.calc_breakdown_id        ,
        Target.effective_date           ,
        Target.action_type              ,
        Target.base_element_name        ,
        Target.payroll_relationship_id  ,
        Target.run_result_id            ,
        Target.input_value_id           ,
        Target.payroll_assignment_id    ,
        Target.element_type_id          ,
        Target.base_name                ,
        Target.run_type_id              ,
        Target.Secondary_Classification ,
        Target.base_element_entry_id    ,
        Target.parent_run_result_id     ,
        Target.source_type              ,
        Target.tax_unit_id              ,
        Target.action_sequence
FROM
        (
                select
                        prr.run_result_id        ,
                        prr.element_type_id      ,
                        prr.payroll_rel_action_id,
                        prr.tax_unit_id          ,
                        prr.payroll_term_id      ,
                        prr.payroll_assignment_id,
                        prr.third_party_payee_id ,
                        prr.calc_breakdown_id    ,
                        prrv.input_value_id      ,
                        prrv.result_value        ,
                        pivf.base_name           ,
                        pitl.name                ,
                        decode(prr.source_type,
                               'E'            , prr.element_entry_id,
                               'I'            , prr.source_id ) base_element_entry_id,
                        prr.source_type                                              ,
                        prr.source_result_id parent_run_result_id                    ,
                        pet.base_element_name                                        ,
                        pcl.BASE_CLASSIFICATION_NAME  Base_Classification            ,
                        pcl2.BASE_CLASSIFICATION_NAME Secondary_Classification       ,
                        ppa.effective_date                                           ,
                        pra.payroll_relationship_id                                  ,
                        pra.run_type_id                                              ,
                        pra.action_sequence                                          ,
                        ppa.action_type
                from
                        pay_run_result_values   prrv,
                        pay_input_values_f      pivf,
                        pay_run_results         prr ,
                        pay_input_values_tl     pitl,
                        pay_payroll_rel_actions pra ,
                        pay_payroll_actions     ppa ,
                        pay_element_types_f     pet ,
                        pay_ele_classifications pcl ,
                        pay_ele_classifications pcl2
                where
                        ppa.payroll_action_id     = pra.payroll_action_id
                and     pra.payroll_rel_action_id =
                        &B1
                and     prr.payroll_rel_action_id       = pra.payroll_rel_action_id
                and     prrv.run_result_id              = prr.run_result_id
                and     prrv.input_value_id             = pivf.input_value_id
                and     pivf.input_value_id             = pitl.input_value_id
                and     prr.element_type_id             = pet.element_type_id
                and     pet.classification_id           = pcl.classification_id
                and     pet.secondary_classification_id = pcl2.classification_id (+)
                and     USERENV('LANG')                 = pitl.language
                and     ppa.effective_date between pivf.effective_start_date and pivf.effective_end_date
                and     ppa.effective_date between pet.effective_start_date and pet.effective_end_date
                ORDER BY
                        prr.source_id    ,
                        prr.run_result_id,
                        pivf.display_sequence) 
						
						
						
						
						Target target.base_element_name IN ('US_SOCIAL_SECURITY_EMPLOYEE_TAX')
        and target.base_name like 'Reduced Subject Withholdable'
        and Target.action_type IN ('R',
                                   'Q',
                                   'V',
                                   'B',
                                   'I',
                                   'CTG')
        and Target.tax_unit_id not in
        (
                select
                        ptru.organization_id
                from
                        per_tax_reporting_units ptru
                where
                        ptru.organization_id = Target.tax_unit_id
                and     ptru.estab_name      like 'IC %') PAY_EXTRACT_RUN_RESULT_VALUES_UE