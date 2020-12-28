
[cmdletbinding()] 
Param (

    [string]$keyvault = "mrikeyvault5",

    [string]$resourceGroup= "mri5",

    [string]$keyName =  "CMKKey",

    [string]$location =  "westeurope"




)

$storageInfraEncryption = Get-AzProviderFeature -ProviderNamespace Microsoft.Storage -FeatureName AllowRequireInfraStructureEncryption

if ($storageInfraEncryption.RegistrationState -ne "Registered" ){
    Register-AzProviderFeature -ProviderNamespace Microsoft.Storage   -FeatureName AllowRequireInfraStructureEncryption
    $count =0
    DO {
        Write-Host "waiting until AllowRequireInfraStructureEncryption it is registred "                  
        start-sleep 15
        
        $storageInfraEncryption = Get-AzProviderFeature -ProviderNamespace Microsoft.Storage -FeatureName AllowRequireInfraStructureEncryption

        $count++

    }

    Until (($storageInfraEncryption -eq "Registered")-or ($count -le 15) ) 
}

& az group create --name $resourceGroup --location $location

& az keyvault create --name $keyvault  --resource-group $resourceGroup  --enable-purge-protection

& az keyvault key create --name $keyName  --vault-name $keyvault 

$root = $PSScriptRoot + "/"
$templateFile = "$($root)./azuredeploy.json"

New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup  -TemplateFile $templateFile -Verbose -keyVaultName $keyvault -keyName  $keyName -configureEncryptionKey $true




