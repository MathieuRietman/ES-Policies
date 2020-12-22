<#
	.SYNOPSIS
        1. DoTestDeployments



	.DESCRIPTION

         


	.EXAMPLE
	   .\doTestDeployments
	   
	.LINK

	.Notes
		NAME:      DeployPolicies
		AUTHOR(s): Mathieu Rietman <marietma@microsoft.com>
		LASTEDIT:  12-10-2020
		KEYWORDS:  policy management Management
#>

[cmdletbinding()] 
Param (

    [string]$deployFolder = "testdeploys/Success",

    [string]$SubscriptionId = "4d035de6-4cb3-4d00-9796-cdbea308da99",

    [string]$location = "westeurope",

    [string]$Resourcegroup = "testpolicies3"
    


)
 
class LogStatus {
    [string]$Folder;
    [string]$Id;  
    [string]$Status;
    [string]$error;
} 

$Logobject = @()

$psRoot = "$PSScriptRoot/"
$polFiles = get-childitem -Directory "$PSScriptRoot/$deployFolder" 
$jobIDs = New-Object System.Collections.Generic.List[System.Object]


Get-AzResourceGroup -Name $resourceGroup -ev notPresent -ea 0 
if ($notPresent) { 

    New-AzResourceGroup -Name $resourceGroup -Location $location -Tags $Tags 
}
else { write-Host "Resource Group already exists" } 

foreach ($folder in $polFiles) {
 
    $folder.NAME

    If ((Test-Path -Path "$($folder.FullName)\azuredeploy.json") -and (Test-Path -Path "$($folder.FullName)\azuredeploy.parameters.json")) {
        $newJob = New-AzResourceGroupDeployment -Name $folder.NAME -TemplateFile "$($folder.FullName)\azuredeploy.json" -TemplateParameterFile "$($folder.FullName)\azuredeploy.parameters.json" -ResourceGroupName $Resourcegroup -AsJob 
        $jobIDs.Add($newJob.Id)
        $Logobject += @([LogStatus]@{
                Folder = $folder.name;
                status = "running";
                Id     = $newJob.Id
            }) 
    }
    elseif (Test-Path -Path "$($folder.FullName)\deploy.ps1") {
        $Env:rg = $Resourcegroup
        $Env:subscription = $SubscriptionId
        & "$($folder.FullName)\deploy.ps1"

        $Logobject += @([LogStatus]@{
                Folder = $folder.name;
                status = $status;
            })   
            
    }
 
}
 

$jobsList = $jobIDs.ToArray()
if ($jobsList) {
    Write-Output "Waiting for deployments to finish ..."
    Wait-Job -Id $jobsList
}
        
foreach ($id in $jobsList) {
    $job = Get-Job -Id $id
    $object = $Logobject | Where-Object { $_.id -eq $id}
    $object.status = $job.state 
    if ($job.Error) {
        $object.error =  $job.Error
        
        
    }
}
        

$Logobject |   Sort-Object -Property PolicyName | Format-Table -AutoS