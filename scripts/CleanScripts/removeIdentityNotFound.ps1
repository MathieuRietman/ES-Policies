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

$Scope = "/subscriptions/$SubscriptionId"
$OBJTYPE = "Unknown"
$unknown = Get-AzRoleAssignment | Where-Object { $_.ObjectType.Equals($OBJTYPE) } 

foreach ($unRole in $unknown) {
    $object = $unRole.ObjectId
    $roledef = $unRole.RoleDefinitionName
    $rolescope = $unRole.Scope
    $status = Remove-AzRoleAssignment -ObjectId $object -RoleDefinitionName $roledef -Scope $rolescope
    write-host "deleted role $roledef for $rolescope"
}


