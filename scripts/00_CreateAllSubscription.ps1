
$PsRoot = "$PSScriptRoot/"
Invoke-Expression "$PsRoot./0_modifyEsPolicies.ps1 -policyfolderSource esPoliciesFixed -policyfolderTarget esPoliciesAll2"   
Invoke-Expression "$PsRoot./0a_createPolicyDefinitionSetDenyPaas.ps1 -policyfolderSource esPoliciesFixed -policyfolderTarget esPoliciesAll2 -targettype 'subscription' -SubscriptionId  '4d035de6-4cb3-4d00-9796-cdbea308da99'"   
Invoke-Expression "$PsRoot./0a_createPolicyDefinitionSetDiag.ps1 -policyfolderSource esPoliciesFixed -policyfolderTarget esPoliciesAll2 -targettype 'subscription' -SubscriptionId '4d035de6-4cb3-4d00-9796-cdbea308da99'"
Invoke-Expression "$PsRoot./0a_createPolicyDefinitionsetSQL.ps1 -policyfolderSource esPoliciesFixed -policyfolderTarget esPoliciesAll2 -targettype 'subscription' -SubscriptionId '4d035de6-4cb3-4d00-9796-cdbea308da99'"   
Invoke-Expression "$PsRoot./1_deployPolicies.ps1 -policyfolder esPoliciesAll2 -SubscriptionId '4d035de6-4cb3-4d00-9796-cdbea308da99'"   
Invoke-Expression "$PsRoot./2a_createDiagPolicySetAssignementsToSubscription.ps1  -policyfolder esPoliciesAll2 -SubscriptionId '4d035de6-4cb3-4d00-9796-cdbea308da99' -ConfigJson 'TestDiagnoticset'"
