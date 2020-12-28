
[cmdletbinding()] 
Param (

    [string]$keyvault = "mrikeyvault15",

    [string]$resourceGroup= "mri15",

    [string]$keyName =  "CMKKey",

    [string]$location =  "westeurope",

    [string]$workspaceName ="mlworkspace15"





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


New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup  -TemplateFile $templateFile -TemplateParameterFile $templateParameterFile -Verbose -keyVaultName $keyvault -cmk_keyvault $keyVaultUri -resource_cmk_uri  $keyid -location $location -workspaceName  $workspaceName 




