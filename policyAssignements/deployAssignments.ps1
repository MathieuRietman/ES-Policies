[cmdletbinding()] 
Param (
    [Parameter(Mandatory = $true)]
    [argumentcompleter({(get-childitem "$PSScriptRoot/config/*.json").basename})]
    [string]$configJson
)
 
class LogStatus {
    [string]$PolicyName;
    [string]$PolicyStatus;
    [string]$scope 
} 

    
$WorkingDirectory = $PSScriptRoot

$LogObject = @()

$configFile = "$($WorkingDirectory)/config/$($configJson).json"
If (Test-Path -Path $configFile ) {
    $BodyString = Get-Content $configFile
    $ChangeFile = $BodyString

 

    #Now replace within the config file .
    #Patern to search for ${*} 
    $regex = '\${.*?}'
    $link = [regex]::match( $ChangeFile, $regex).sampleConfig

    while ($link -ne "" ) {
        $ChangeFiletemp = ""
        $General = $ChangeFile | ConvertFrom-Json 
        foreach ($line in $ChangeFile) {
            if ($line -match $regex) {
            
         
                $link = [regex]::match( $line, $regex).value
                $replace = $link
                $value = $general
                $link2 = $link.Substring(2, $link.Length - 3)
                $items = $link2.split(".")
                foreach ($item in $items) {
                    $value = $value.$item
                }
                $line = $line.Replace($replace, $value) 
          
                
        
            }
       
            $ChangeFiletemp += $line + "`n"
        }
        $ChangeFile = $ChangeFiletemp
        $link = [regex]::match( $ChangeFile, $regex).value
    }

    $environmentConfig =  $ChangeFile | ConvertFrom-Json 
    $Location = $environmentConfig.general.location
    $topLevelManagementGroupPrefix = $environmentConfig.general.topLevelManagementGroupPrefix
    $tenantId = $environmentConfig.general.tenantId 
    $context = Get-AzContext 
    if ($environmentConfig.general."managementSubscriptionId") { 
        if ($context.Subscription.id -ne $environmentConfig.general."managementSubscriptionId") {
            Try { 
                Set-AzContext -SubscriptionId $environmentConfig.general."managementSubscriptionId"  -Tenant $tenantId -ErrorAction Stop
            } 
            catch {
                throw $_
            }
        }
    }
    $context = Get-AzContext 
    #Getting the role from the config if not found this role can be only in one subscription defined so need to also provide the scope. This is done also in configfile
    ##Apply the policies

    Write-Host "--- Start Policy Assignment ---" -ForegroundColor Green
    $policies = $environmentConfig.general.policies
    foreach ($policy in $policies) { 
        $policyStatus = "Succeeded"
        $policyTemplateFile = "$($WorkingDirectory)/policyAssignmentTemplates/$($policy.Name)"
        If (Test-Path -Path $policyTemplateFile  ) {
            [hashtable]$parameters = @{ }
            $scope ="$($topLevelManagementGroupPrefix)" 
            foreach ( $parameter in $policy.Parameters) { 
                $parameters[$parameter.Name] = $parameter.Value
                if ($parameter.Name -eq "scope") {
                    $scope = $parameter.Value
                    $scope = ($scope -split "/")[-1]
                }
              
            }
            Write-Host "--- Policy Assignement Assignment $($policy.name) ---" -ForegroundColor Green
            #This policy enables you to restrict the locations your organization can create resource groups in. Use to enforce your geo-compliance requirements.
            $AssignmentName = "AssignPolicy_$($policy.Name)"
            $status =New-AzManagementGroupDeployment -TemplateFile $policyTemplateFile  -TemplateParameterObject $parameters -ManagementGroupId $scope  -Verbose  -Location $Location

            if ($status.ProvisioningState -ne "Succeeded") { $policyStatus = $status.ProvisioningState }
        }
        else {
            $policyStatus ="Missing policyAssignment JSON    "
            Write-Host " not found the policyfile $($policyTemplateFile)  please check config or file" -ForegroundColor Red
        }
        $Logobject +=@([LogStatus]@{PolicyName=$policy.Name;PolicyStatus=$PolicyStatus;scope=$scope })
                       
    
    }

}
else {
    Write-Host "Could not find policy config file config file $($configFile).json" -ForegroundColor Red
}

$Logobject |   Sort-Object -Property PolicyName | Format-Table -AutoSize 

$Logobject |   Sort-Object -Property PolicyName  | Where-Object {$_.PolicyStatus -eq "Failed"} | Format-Table -AutoSize 

