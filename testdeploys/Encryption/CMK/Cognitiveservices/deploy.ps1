
[cmdletbinding()] 
Param (

    [string]$keyvault = "mrikeyvault18",

    [string]$resourceGroup= "mri18",

    [string]$keyName =  "CMKKey",

    [string]$location =  "westeurope",

    [string]$identityName  = "mri18mi"





)

& az group create --name $resourceGroup --location $location

& az keyvault create --name $keyvault  --resource-group $resourceGroup  --enable-purge-protection

& az keyvault key create --name $keyName  --vault-name $keyvault 
$keyVaultUri =  (Get-AzKeyVault -VaultName $keyvault).VaultUri
$keyobject =  Get-AzKeyVaultKey -VaultName $keyvault -Name $keyName

$root = $PSScriptRoot + "/"
$templateFile = "$($root)./azuredeploy.json"
$templateParameterFile  = "$($root)./azuredeploy.parameters.json"


New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup  -TemplateFile $templateFile -TemplateParameterFile $templateParameterFile -Verbose -vaultName $keyvault -vaultUri $keyVaultUri -identityName $identityName  -keyName $keyName



