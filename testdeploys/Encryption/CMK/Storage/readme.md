There is no way to enforce with deny Policy. CMK policy should be on AUdit only Storage account need first a MSI and KeyVault access need to be aranged. Reason is that STorage Account does not support usermanaged Identities.

https://www.codeisahighway.com/how-to-use-customer-managed-keys-with-azure-key-vault-and-azure-storage-encryption-using-arm-template/

Policy should be on Audit to create

Infrastructure encryption should be enabled via powershell or cli before be able to use it!

Register-AzProviderFeature -ProviderNamespace Microsoft.Storage   -FeatureName AllowRequireInfraStructureEncryption




Register-AzResourceProvider -ProviderNamespace 'Microsoft.Storage'

 https://docs.microsoft.com/en-us/azure/storage/common/infrastructure-encryption-enable?tabs=powershell
