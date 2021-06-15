
[cmdletbinding()] 
Param (


    [Parameter(Mandatory = $true)]
    [argumentcompleter({(get-childitem "$PSScriptRoot/*.json").basename})]
    [string]$policyJson,

    [Parameter(Mandatory = $true)]
    [string]$topLevelManagementGroupPrefix ,

    [string]$Location = "WestEurope"


)

New-AzManagementGroupDeployment -TemplateFile "$($PSScriptRoot)/$($policyJson).json" -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix -ManagementGroupId "$($topLevelManagementGroupPrefix)" -Verbose -Location $Location 
