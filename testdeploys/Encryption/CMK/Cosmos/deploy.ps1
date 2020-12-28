
[cmdletbinding()] 
Param (

    [string]$keyvault = "mrikeyvault11",

    [string]$resourceGroup= "mri11",

    [string]$keyName =  "CMKKey",

    [string]$location =  "westeurope",

    [string]$accountName = "cosmosmri11"





)

& az group create --name $resourceGroup --location $location

& az keyvault create --name $keyvault  --resource-group $resourceGroup  --enable-purge-protection

& az keyvault key create --name $keyName  --vault-name $keyvault 

$keyobject =  Get-AzKeyVaultKey -VaultName $keyvault -Name $keyName
$keyid = $keyobject.id.TrimEnd("/"+ $keyobject.version)
$root = $PSScriptRoot + "/"
$templateFile = "$($root)./azuredeploy.json"

$objectId = $(Get-AzADServicePrincipal -ApplicationId 'a232010e-820c-4083-83bb-3ace5fc29d0b').Id

New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup  -TemplateFile $templateFile -Verbose -vault_name $keyvault -accountName $accountName -keyVaultKeyUri  $keyid -location $location -objectid $objectId




