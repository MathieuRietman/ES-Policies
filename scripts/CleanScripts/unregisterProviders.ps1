[cmdletbinding()] 
Param (



    [string]$SubscriptionId = "4d035de6-4cb3-4d00-9796-cdbea308da99"

)

$context = Get-AzContext 


if ($context.Subscription.id -ne $SubscriptionId) {
    Try { 
        Set-AzContext -SubscriptionId $SubscriptionId  -ErrorAction Stop
    } 
    catch {
        throw $_
    }
}


$registredProviders = Get-AzResourceProvider 

foreach ($Provider in $registredProviders) {
    write-host "Unregister namespace $($Provider.ProviderNamespace)"
    $status = Unregister-AzResourceProvider -ProviderNamespace $Provider.ProviderNamespace

}
write-host "CurrentNamespaces Are registred on $SubscriptionId"
$registredProviders = Get-AzResourceProvider 
foreach ($Provider in $registredProviders){
    write-host "$($Provider.ProviderNamespace)"
}
