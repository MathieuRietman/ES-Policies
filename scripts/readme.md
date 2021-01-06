Folder containing scripts for creating policy object and assignments

createCustomPolicyFileAndDeploy.ps1  create the policy.json and deploy it to the specified management group
sample 
```
createCustomPolicyFileAndDeploy.ps1 -topLevelManagementGroupPrefix MRIT
```
createPolicySetAssignementsToMng.ps1  makes policy assignement of every initiative in folder esPolicyInitiatives using the parameters specified in the config file  

sample
``` 
createPolicySetAssignementsToMng.ps1 -topLevelManagementGroupPrefix MRIT -configJson Test
```

TriggerPolicyEvaluation.ps1 triggers a policy evaluation on provided scope

sample
``` 
.\createPolicySetAssignementsToMng.ps1 -topLevelManagementGroupPrefix MRIT -configJson Test
``` 