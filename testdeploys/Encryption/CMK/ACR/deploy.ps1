
[cmdletbinding()] 
Param (

    [string]$keyvault = "mrikeyvault3",

    [string]$resourceGroup= "mri3",

    [string]$keyName =  "CMKKey",

    [string]$location =  "westeurope",

    [string]$regName = "mriacr3",

    [string]$identityName = "cmkmriacr3"



)

& az group create --name $resourceGroup --location $location

& az keyvault create --name $keyvault  --resource-group $resourceGroup  --enable-purge-protection

& az keyvault key create --name $keyName  --vault-name $keyvault 

$keyobject =  Get-AzKeyVaultKey -VaultName $keyvault -Name $keyName
$keyid = $keyobject.id.TrimEnd("/"+ $keyobject.version)
$root = $PSScriptRoot + "/"
$templateFile = "$($root)./azuredeploy.json"

New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup  -TemplateFile $templateFile -Verbose -vault_name $keyvault -registry_name $regName -identity_name $identityName  -kek_id  $keyid 




