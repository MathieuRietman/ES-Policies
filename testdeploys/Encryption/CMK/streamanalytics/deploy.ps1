
[cmdletbinding()] 
Param (

    [string]$keyvault = "mrikeyvault16",

    [string]$resourceGroup= "mri16",

    [string]$keyName =  "CMKKey",

    [string]$location =  "westeurope"




)

& az group create --name $resourceGroup --location $location

& az keyvault create --name $keyvault  --resource-group $resourceGroup  --enable-purge-protection

& az keyvault key create --name $keyName  --vault-name $keyvault 
$keyVaultUri =  (Get-AzKeyVault -VaultName $keyvault).ResourceId
$keyobject =  Get-AzKeyVaultKey -VaultName $keyvault -Name $keyName
$keyid = $keyobject.id.TrimEnd("/"+ $keyobject.version)
$keyid = $keyobject.id
$root = $PSScriptRoot + "/"
$templateFile = "$($root)./azuredeploy.json"
$templateParameterFile  = "$($root)./azuredeploy.parameters.json"



New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup  -TemplateFile $templateFile -TemplateParameterFile $templateParameterFile -Verbose 




