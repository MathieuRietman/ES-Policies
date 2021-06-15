# June 2021

Added 


|Type|Description|Effect|Template file|Deploy|
|------------|-------------------|----------------|-----------------|-----------------|
|custom|Compliant KeyVault. | Deny, DeployIfNotExists, Disabled.|[KeyVaultCompliantBaseline.json](../esPoliciesInitiatives/KeyVaultCompliantBaseline.json) |[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2FES-Policies%2FCompliantWorkload%2FChanges%2FDeploymenPolicySets%2FKeyVaultCompliantBaseline.json) | 
[StorageCompliantBaseline.json](../esPoliciesInitiatives/StorageCompliantBaseline.json) |[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2FES-Policies%2FCompliantWorkload%2FChanges%2FDeploymenPolicySets%2FStorageCompliantBaseline.json) | 


# May 2021

Deleted Deploy-HUB, "Deploy-vNet, Deploy-vWAN, Deploy-vHUB

Added 

Deploy-Default-Udr


|Type|Description|Effect|Template file|Deploy|
|------------|-------------------|----------------|-----------------|-----------------|
|custom|Deploy a user-defined route to a VNET with specific routes. | DeployIfNotExists, Disabled.|[Network_UDR_Deploy.json](../esPoliciesDefinitionsCustom/Network_UDR_Deploy.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FNetwork_UDR_Deploy.json)|

Updated Type casing to Pascal. "string" "String"

Fixed issue https://github.com/Azure/Enterprise-Scale/issues/478


# April 2021

## Changed to build in policies


- NetworkPublicIPNic_DeployDiagnosticLog_Deploy_LogAnalytics.json-> 752154a7-1e0f-45c6-a880-ac75a7e4f648

Impact on PublicEndpointsInitiative_Deny.json added also 3 additional services


- Cosmos_PublicEndpoint_Deny.json	Cosmos	-> 	797b37f7-06b8-444c-b1ad-fc62867f335a	
- AKS_PublicEndpoint_Deny.json	-> 040732e8-d947-40b8-95d6-854c95024bf8	
- KeyVault_PublicEndpoint_Deny.json	-> 	5f0bc445-3935-4915-9981-011aa2b46147 
- SqlServer_PublicEndpoint_Deny.json -> 	1b8ca024-1d5c-4dec-8995-b1a932b41780
- Storage_PublicEndpoint_Deny.json	-> 	2a1a9cdf-e04d-429a-8416-3bfb72a1b26f	

Impact on PublicEndpointsInitiative_Deny.json added also 3 additional services

<br>
<br>

## Changed Security Center config

- ASC_StandardOrFree_Deploy.json -> Replaced by separate deployment per Defender and grouped in initiative  ASC_Config_Deploy.json

<br>

|Description|Template file|
|------------|-------------------|
|Deploy Azure Security Center configuration |[ASC_Config_Deploy.json](../esPoliciesInitiatives/ASC_Config_Deploy.json) |

<br>

Please note deploying with below button deploys not with the right names use the deploy button in [readme](../README.md) to deloy the latest policies to the top management group.

<br>

|Type|Description|Effect|Template file|Deploy|
|------------|-------------------|----------------|-----------------|-----------------|
|custom|Deploy the Azure Defender settings for AKS. | DeployIfNotExists, Disabled.|[ASC_DefenderAKS_Deploy.json](../esPoliciesDefinitionsCustom/ASC_DefenderAKS_Deploy.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FASC_DefenderAKS_Deploy.json)|
|custom|Deploy the Azure Defender settings in Azure Security Center for Azure App Services. | DeployIfNotExists, Disabled.|[ASC_DefenderAppServices_Deploy.json](../esPoliciesDefinitionsCustom/ASC_DefenderAppServices_Deploy.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FASC_DefenderAppServices_Deploy.json)|
|custom|Deploy the Azure Defender settings for Azure Resource Manager. | DeployIfNotExists, Disabled.|[ASC_DefenderARM_Deploy.json](../esPoliciesDefinitionsCustom/ASC_DefenderAppServices_Deploy.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FASC_DefenderARM_Deploy.json)|
|custom|Deploy the Azure Defender settings in Azure Security Center for Azure Sql Databases | DeployIfNotExists, Disabled.|[ASC_DefenderAzureSQL_Deploy.json](../esPoliciesDefinitionsCustom/ASC_DefenderAzureSQL_Deploy.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FASC_DefenderAzureSQL_Deploy.json)|
|custom|Deploy the Azure Defender settings for Azure Container Registry | DeployIfNotExists, Disabled.|[ASC_DefenderContainerRegistry_Deploy.json](../esPoliciesDefinitionsCustom/ASC_DefenderContainerRegistry_Deploy.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FASC_DefenderContainerRegistry_Deploy.json)|
|custom|Deploy the Azure Defender settings for DNS| DeployIfNotExists, Disabled.|[ASC_DefenderDNS_Deploy.json](../esPoliciesDefinitionsCustom/ASC_DefenderDNS_Deploy.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FASC_DefenderDNS_Deploy.json)|
|custom|Deploy the Azure Defender settings for Azure Key Vault| DeployIfNotExists, Disabled.|[ASC_DefenderKeyVault_Deploy.json](../esPoliciesDefinitionsCustom/ASC_DefenderKeyVault_Deploy.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FASC_DefenderKeyVault_Deploy.json)|
|custom|Deploy the Azure Defender settings in Sql Server on Virtual Machines| DeployIfNotExists, Disabled.|[ASC_DefenderSqlVms.json](../esPoliciesDefinitionsCustom/ASC_DefenderSqlVms.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FASC_DefenderSqlVms.json)|
|custom|Deploy the Azure Defender settings in Azure Security Center for Storage Accounts| DeployIfNotExists, Disabled.|[ASC_DefenderStorageAccounts_Deploy.json](../esPoliciesDefinitionsCustom/ASC_DefenderStorageAccounts_Deploy.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FASC_DefenderStorageAccounts_Deploy.json)|
|custom|Deploy the Azure Defender settings in Azure Security Center for Virtual Machines| DeployIfNotExists, Disabled.|[ASC_DefenderVirtualMachines_Deploy.json](../esPoliciesDefinitionsCustom/ASC_DefenderVirtualMachines_Deploy.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FASC_DefenderVirtualMachines_Deploy.json)|
|custom|Deploy Azure Security Center Security Contacts| DeployIfNotExists, Disabled.|[ASC_SecurityContacts_Deploy.json](../esPoliciesDefinitionsCustom/ASC_SecurityContacts_Deploy.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FASC_SecurityContacts_Deploy.json)|



<br>
<br>



# Feb 2021


## Custom Policies for Encryption in transit.

Custom policies that are used in the EncryptionTransitInitiative_Deploy.JSO initiative. Have policies either deny or appand and deploy if not exist.

## Policy definitions

|Type|Description|Effect|Template file|Deploy|
|------------|-------------------|----------------|-----------------|-----------------|
|custom|App Service append enable https only setting to enforce https setting. |Append, disabled.|[AppService_HttpsOnly_Append.json](../esPoliciesDefinitionsCustom/AppService_HttpsOnly_Append.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FAppService_HttpsOnly_Append.json)|
|custom|AppService append sites with minimum TLS version to enforce. Append policy.| Append, disabled. |[AppService_minTls_Append.json](../esPoliciesDefinitionsCustom/AppService_minTls_Append.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FAppService_minTls_Append.json)|
|custom|API App should only be accessible over HTTPS. The existing policy has no deny.  |Deny,Audit,Disabled.|[AppServiceApiApp_HTTP_Deny.json](../esPoliciesDefinitionsCustom/AppServiceApiApp_HTTP_Deny.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FAppServiceApiApp_HTTP_Deny.json)|
|custom|Function App should only be accessible over HTTPS. The existing policy has no deny. |Deny,Audit,Disabled. |[AppServiceFunctionApp_HTTP_Deny.json](../esPoliciesDefinitionsCustom/AppServiceFunctionApp_HTTP_Deny.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FAppServiceFunctionApp_HTTP_Deny.json)|
|custom|Web App should only be accessible over HTTPS. The existing policy has no deny. |Deny,Audit,Disabled. |[AppServiceWebApp_HTTP_Deny.json](../esPoliciesDefinitionsCustom/AppServiceWebApp_HTTP_Deny.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FAppServiceWebApp_HTTP_Deny.json)|
|custom|MySQL database servers enforce SSL connections. Validate both minimum TLS version and ssl enforcement is enabled. |Deny,Audit,Disabled.|[MySQL_EnableSSL_Deny.json](../esPoliciesDefinitionsCustom/MySQL_EnableSSL_Deny.json)| [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FMySQL_EnableSSL_Deny.json)|
|custom|Azure Database for MySQL server deploy a specific min TLS version and enforce SSL. Use in combination with above policy set to audit. |DeployIfNotExists, disabled.|[MySQL_TlsVersion_Deploy.json](../esPoliciesDefinitionsCustom/MySQL_TlsVersion_Deploy.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FMySQL_TlsVersion_Deploy.json)|
|custom|PostgreSQL database servers enforce SSL connection. Validate both minimum TLS version and ssl enforcement is enabled. |Deny,Audit,Disabled.|[PostgreSQL_EnableSSL_Deny.json](../esPoliciesDefinitionsCustom/PostgreSQL_EnableSSL_Deny.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FPostgreSQL_EnableSSL_Deny.json)|
|custom|PostgreSQL TLS version and enforce SSL connection. Use in combination with above policy set to audit. |DeployIfNotExists, Disabled.|[PostgreSQL_TlsVersion_Deploy.json](../esPoliciesDefinitionsCustom/PostgreSQL_TlsVersion_Deploy.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FPostgreSQL_TlsVersion_Deploy.json)|
|custom|Azure Cache for Redis only secure connections should be enabled.  |Deny,Audit,Disabled.|[RedisCache_AuditSSLPort_Deny.json](../esPoliciesDefinitionsCustom/RedisCache_AuditSSLPort_Deny.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FRedisCache_AuditSSLPort_Deny.json)|
|custom|Azure Cache for Redis Append and the enforcement that enableNonSslPort is disabled. Deploy if not exists has timing issue and fail.|Append, disabled.|[RedisCache_disableNonSslPort_Append.json](../esPoliciesDefinitionsCustom/RedisCache_disableNonSslPort_Append.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FRedisCache_disableNonSslPort_Append.json)|
|custom|Azure Cache for Redis Append a specific min TLS version requirement and enforce TLS. Deploy if not exists has timing issue and fail.|Append, disabled.|[RedisCache_TlsVersion_Append.json](../esPoliciesDefinitionsCustom/RedisCache_RedisCache_TlsVersion_Append.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FRedisCache_TlsVersion_Append.json)|
|custom|SQL Managed Instance should have the minimal TLS version set to the highest version. |Deny,Audit,Disabled.|[SqlManagedInstance_MiniumTLSVersion_Deny.json](../esPoliciesDefinitionsCustom/SqlManagedInstance_MiniumTLSVersion_Deny.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FSqlManagedInstance_MiniumTLSVersion_Deny.json)|
|custom|SQL Managed Instance deploy a specific min TLS version requirement. Use in combination with above policy set to audit. |DeployIfNotExists, disabled.|[SqlManagedInstance_TlsVersion_Deploy.json](../esPoliciesDefinitionsCustom/SqlManagedInstance_TlsVersion_Deploy.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FSqlManagedInstance_TlsVersion_Deploy.json)|
|custom|SQL Server should have the minimal TLS version set to the highest version. |Deny,Audit,Disabled.|[SqlServer_MiniumTLSVersion_Deny.json](../esPoliciesDefinitionsCustom/SqlServer_MiniumTLSVersion_Deny.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FSqlServer_MiniumTLSVersion_Deny.json)|
|custom|SQL servers deploys a specific min TLS version requirement. Use in combination with above policy set to audit. |DeployIfNotExists, disabled.|[SqlServer_TlsVersion_Deploy.json](../esPoliciesDefinitionsCustom/SqlServer_TlsVersion_Deploy.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FSqlServer_TlsVersion_Deploy.json)|
|custom|Storage Account set to minumum TLS and Secure transfer should be enabled. Validate both Https traffic only as the minimum TLS version |Deny,Audit,Disabled.|[Storage_HTTP_Deny.json](../esPoliciesDefinitionsCustom/Storage_HTTP_Deny.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FStorage_HTTP_Deny.json)|
|custom|Azure Storage deploy a specific min TLS version requirement and enforce SSL/HTTPS. Use in combination with above policy set to audit. |DeployIfNotExists, disabled.|[Storage_TlsVersion_Deploy.json](../esPoliciesDefinitionsCustom/Storage_TlsVersion_Deploy.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FStorage_TlsVersion_Deploy.json)|
<br>

<br>

##  Policy Initiative EncryptionTransitInitiative_Deploy.json Enforce TLS and minimum TLS version.


<br>

**Please** use the deploy all as this creates the policies definitions with the right name to be used in this initiative. [See link](../README.md)

<br>

|Description|Template file|
|------------|-------------------|
| Deny or Audit resources without Encryption with a customer-managed key (CMK) |[EncryptionTransitInitiative_Deploy.json](../esPoliciesInitiatives/EncryptionTransitInitiative_Deploy.json) |

<br>
Purpose is to enforce TLS and minimum version.

<br>

Have policies either deny or append and deploy if not exist. Please note that deny will result in a failed deployment by the Portal. Consider the append and deploy if not exist policies in combination with the audit policy as the deploy if not exist will not result in a compliance result, append will but append works also as a deny if wrong setting is in ARM deployment request.
The deploy if not exist will require time to become compliant as these are on the resource provider itself. These policies may report noncompliant for a period of time, but eventually become not applicable because of the policy rule make them not applicable.
The default is deployifnotexist and audit.
<br>
<br>

|Description|Effect|Default|Template file or DefinitionId|
|------------|-------------------|----------------|-----------------|
|App Service. Appends the AppService sites config|Append, Disabled| Append| [AppService_HttpsOnly_Append.json](../esPoliciesDefinitionsCustom/AppService_HttpsOnly_Append.json) |
|AppService append sites with minimum TLS version to enforce. Append policy.| Append, disabled. |Append|[AppService_RequireLatestTls_Append.json](../esPoliciesDefinitionsCustom/AppService_RequireLatestTls_Append.json) |
|API App should only be accessible over HTTPS.  |Deny,Audit,Disabled.|Audit|[AppServiceApiApp_HTTP_Deny.json](../esPoliciesDefinitionsCustom/AppServiceApiApp_HTTP_Deny.json) | 
|Function App should only be accessible over HTTPS.  |Deny,Audit,Disabled. |Audit|[AppServiceFunctionApp_HTTP_Deny.json](../esPoliciesDefinitionsCustom/AppServiceFunctionApp_HTTP_Deny.json) | 
|Web App should only be accessible over HTTPS. The existing policy has no deny. |Deny,Audit,Disabled. |Audit|[AppServiceWebApp_HTTP_Deny.json](../esPoliciesDefinitionsCustom/AppServiceWebApp_HTTP_Deny.json) | [![Deploy to Azure](https://docs.microsoft.com/en-us/azure/governance/policy/media/deploy/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-Policies%2Fmain%2FesPoliciesDefinitionsCustom%2FAppServiceWebApp_HTTP_Deny.json)|
|MySQL database servers enforce SSL connections.  |Deny,Audit,Disabled.|Audit|[MySQL_EnableSSL_Deny.json](../esPoliciesDefinitionsCustom/MySQL_EnableSSL_Deny.json) |
|Azure Database for MySQL server deploy a specific min TLS version and enforce SSL.  |DeployIfNotExists, disabled.|DeployIfNotExists |[MySQL_TlsVersion_Deploy.json](../esPoliciesDefinitionsCustom/MySQL_minTlsVersion.json) | 
|PostgreSQL database servers enforce SSL connection. Validate both minimum TLS version and ssl enforcement is enabled. |Deny,Audit,Disabled.|Audit|[PostgreSQL_EnableSSL_Deny.json](../esPoliciesDefinitionsCustom/PostgreSQL_EnableSSL_Deny.json) | 
|PostgreSQL TLS version and enforce SSL connection. Use in combination with above policy set to audit. |DeployIfNotExists, Disabled.|DeployIfNotExists|[PostgreSQL_TlsVersion_Deploy.json](../esPoliciesDefinitionsCustom/PostgreSQL_minTlsVersion.json) |
|Azure Cache for Redis only secure connections should be enabled.  |Deny,Audit,Disabled.|Audit|[RedisCache_AuditSSLPort_Deny.json](../esPoliciesDefinitionsCustom/RedisCache_AuditSSLPort_Deny.json) | 
|Azure Cache for Redis Append a the enforcement that enableNonSslPort is disabled. Deploy if not exists has timing issue and fail.|Append, disabled.|Append| [RedisCache_disableNonSslPort_Append.json](../esPoliciesDefinitionsCustom/RedisCache_disableNonSslPort_Append.json) | 
|Azure Cache for Redis Append a specific min TLS version requirement and enforce TLS. Deploy if not exists has timing issue and fail.|Append, disabled.|Append| [RedisCache_TlsVersion_Append.json](../esPoliciesDefinitionsCustom/RedisCache_RedisCache_TlsVersion_Append.json) | 
|SQL Managed Instance should have the minimal TLS version set to the highest version. |Deny,Audit,Disabled.|Audit|[SqlManagedInstance_MiniumTLSVersion_Deny.json](../esPoliciesDefinitionsCustom/SqlManagedInstance_MiniumTLSVersion_Deny.json) |
|SQL Managed Instance deploy a specific min TLS version requirement. Use in combination with above policy set to audit. |DeployIfNotExists, disabled.|DeployIfNotExists|[SqlManagedInstance_TlsVersion_Deploy.json](../esPoliciesDefinitionsCustom/SqlManagedInstance_TlsVersion_Deploy.json) |
|SQL Server should have the minimal TLS version set to the highest version. |Deny,Audit,Disabled.|Audit|[SqlServer_MiniumTLSVersion_Deny.json](../esPoliciesDefinitionsCustom/SqlServer_MiniumTLSVersion_Deny.json) | 
|SQL servers deploy a specific min TLS version requirement. Use in combination with above policy set to audit. |DeployIfNotExists, disabled.|DeployIfNotExists|[SqlServer_TlsVersion_Deploy.json](../esPoliciesDefinitionsCustom/SqlServer_TlsVersion_Deploy.json) |
|Storage Account set to minumum TLS and Secure transfer should be enabled. Validate both Https traffic only as the minimum TLS version |Deny,Audit,Disabled.|Audit|[Storage_HTTP_Deny.json](../esPoliciesDefinitionsCustom/Storage_HTTP_Deny.json) |
|Azure Storage deploy a specific min TLS version requirement and enforce SSL/HTTPS. Use in combination with above policy set to audit. |DeployIfNotExists, disabled.|DeployIfNotExists|[Storage_TlsVersion_Deploy.json](../esPoliciesDefinitionsCustom/Storage_TlsVersion_Deploy.json]) | 

<br>

## Policy EncryptionCMKInitiative_Deny.json  Deny or Audit resources without Encryption with a customer-managed key (CMK).
<br>

**Please** use the deploy all as this creates the policies definitions with the right name to be used in this initiative. [See link](../README.md)

|Description|Template file|
|------------|-------------------|
| Deny or Audit resources without Encryption with a customer-managed key (CMK) |[EncryptionCMKInitiative_Deny.json](../esPoliciesInitiatives/EncryptionCMKInitiative_Deny.json) |

<br>
Please always check the latest information available in docs.
<br>
<br>

Microsoft is working towards encrypting all customer data at rest by default, Azure Services have encrypion at rest implemented with Microsoft managed keys.
Beside this serveral servics have server-side encryption using service-managed keys in customer-controlled hardware is used.

Common setup is creating first the Azure Keyvault to store your Customer Managed Keys (CMK) in keys. Create either the service (storage database etc) with a managed service identity (MSI) or a user managed identity provide the MSI or user managed identity just enough rights on the keyvault. COnfigure the service with the keyvault (uri) config. SOme service support just the key and support auto rotate but some need a specific version. When MSI is used in it is impossible to enforce with deny as the service need to be created first to have a MSI to set the access policy on the keyvault.  

|Description|Effect|Default|Template file or DefinitionId|Remark|
|------------|-------------------|----------------|-----------------|----------------|
|Container registries should be encrypted with a customer-managed key (CMK)|Deny,Audit,Disabled.|Audit| 5b9159ae-1701-4a6f-9a7a-aa9c8ddd0580 | Container Registry support user-assigned managed identity that can be used to enable access to KeyVault, support automatic key rotation [see link](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-customer-managed-keys)]
|Azure Kubernetes Service clusters Both operating systems and data disks should be encrypted by customer-managed keys| Deny,Audit,Disabled.|Audit|7d7be79c-23ba-4033-84dd-45e2a5ccdd67 | Need diskencryptionset see [see link](https://docs.microsoft.com/en-us/azure/aks/azure-disk-customer-managed-keys)
|Azure Machine Learning workspaces should be encrypted with a customer-managed key (CMK)| Deny,Audit,Disabled.|Audit|ba769a63-b8cc-4b2d-abf6-ac33c7204be8 | Machine Learning uses config MSI that creates the other resources in separate MSI [see link](https://docs.microsoft.com/en-us/azure/machine-learning/concept-data-encryption)
|Cognitive Services accounts should enable data encryption with a customer-managed key (CMK)| Deny,Audit,Disabled.|Audit|67121cc7-ff39-4ab8-b7e3-95b84dab487d | Customer-managed keys are only available on the E0 pricing tier. And need request form [see link](https://docs.microsoft.com/en-us/azure/cognitive-services/face/face-encryption-of-data-at-rest)|
|Azure Cosmos DB accounts should use customer-managed keys to encrypt data at rest| Deny,Audit,Disabled.|Audit|1f905d99-2ab7-462c-a6b0-f709acca6c8f |Cosmos use an Application ID that need access to keyvault. support key rotation [see link](https://docs.microsoft.com/en-us/azure/cosmos-db/how-to-setup-cmk)|
|Azure Data Box jobs should use a customer-managed key to encrypt the device unlock password| Deny,Audit,Disabled.|Audit|86efb160-8de7-451d-bc08-5d475b0aadae|Azure Data Box support UserAssigned identies. No key rotation [see link](https://docs.microsoft.com/en-us/azure/databox/data-box-customer-managed-encryption-key-portal)| 
|Azure Stream Analytics jobs should use customer-managed keys to encrypt data| Deny,Audit,Disabled.|Audit|87ba29ef-1ab3-4d82-b763-87fcd4f531f7 | Ensure that storage account is using CMK [see link](https://docs.microsoft.com/en-us/azure/stream-analytics/data-protection)|
|Azure Synapse workspaces should use customer-managed keys to encrypt data at rest.|Deny,Audit,Disabled.|Audit|f7d52b2d-e161-4dfa-a82b-55e564167385 | Configure during create then need activation after MSI has keyvault access [see link](https://docs.microsoft.com/en-us/azure/synapse-analytics/security/workspaces-encryption)|
|Storage accounts should use customer-managed key (CMK) for encryption.|AuditIfNotExists, Disabled |AuditIfNotExists|6fac406b-40ca-413b-bf8e-0bf964659c25 | No deny possible. Storage MSI need access on KeyVault, support automatic key rotation [see link](https://docs.microsoft.com/en-us/azure/storage/common/customer-managed-keys-configure-key-vault)|
|Azure database for MySQL servers bring your own key data protection should be enabled.|AuditIfNotExists, Disabled |AuditIfNotExists|83cef61d-dbd1-4b20-a4fc-5fbc7da10833 | Azure database for MySQL support MSI, no deny possible. Need to select version key. [see link](https://docs.microsoft.com/en-us/azure/mysql/concepts-data-encryption-mysql)|
|Azure database for PostgreSQL servers bring your own key data protection should be enabled|AuditIfNotExists, Disabled |AuditIfNotExists|18adea5e-f416-4d0f-8aa8-d24321e3e274 |Azure database for PostgreSQL support MSI, no deny possible. Need to select version key. [see link](https://docs.microsoft.com/en-us/azure/postgresql/concepts-data-encryption-postgresql)|
|SQL servers should use customer-managed keys to encrypt data at rest|AuditIfNotExists, Disabled |AuditIfNotExists|0d134df8-db83-46fb-ad72-fe0c9428c8dd | Azure SQL Server support MSI, no deny possible. Need to select version key. [see link](https://docs.microsoft.com/en-us/azure/azure-sql/database/transparent-data-encryption-byok-overview)|
|Azure API for FHIR should use a customer-managed key (CMK) to encrypt data at rest|audit, disabled |audit|051cba44-2429-45b9-9649-46cec11c7119| Azure FHIR uses Cosmos underneath see based on Application ID but handled via portal [see link](https://docs.microsoft.com/en-us/azure/healthcare-apis/customer-managed-key)|
|Azure Batch account should use customer-managed keys to encrypt data|Deny,Audit,Disabled.|Audit|051cba44-2429-45b9-9649-46cec11c7119 | public preview only batch account customer data no comute disk. Support user-assigned managed identity. [see link](https://docs.microsoft.com/en-us/azure/batch/batch-customer-managed-key)|

The current initiative based on build in and not complete [see link for complete list](https://docs.microsoft.com/en-us/azure/security/fundamentals/encryption-models#supporting-services).
To do:
- Backup Vault [see link](https://docs.microsoft.com/en-us/azure/backup/encryption-at-rest-with-cmk)
- Log Analytics Dedicated cluster [see link](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/customer-managed-keys)
- Azure vm disk 
- Power BI
- Event Hub
- Application Insight
- Azure data factory
- Azure databricks
- Azure NetApp Files