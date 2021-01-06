# ES Policies is used to create the policies for Enterprise Scales

1. Custom policies in policies.json
2. Custom initiatives in Policies.json
3. Custom policies not part of policies.json
4. Custom initiatives not part of Policies.json
4. Scripts are used to support development
5. Old deprecated policies

### Custom Policy Deployment

This will deploy only the custom policies to a Management group, this is a Management Group deployment instead of a tenant deployment. 
You need to select in Basic and the Management Group screen both the correct Management Group where the custom policies definitions and initiatives will be created. This can also be used to update existing custom Enterprise-Scale policies deployed via this reference architecture, this only works when there is no mismatch in parameters only new parameters are then allowed.

| Type | Description | ARM Templates | 
|:-------------------------|:-------------|:-------------|
| Deploy the custom Policies from main branche| Deploys or update custom policies to a selected management group |[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2FES-Policies%2Fmain%2FarmTemplates%2Fes-customPolicies.json/createUIDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2FES-Policies%2Fmain%2FarmTemplates%2Fportal-es-customPolicies.json) | 