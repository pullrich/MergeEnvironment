function Show-MergeEnvironment
{
<#
.SYNOPSIS
Display the current setup of the merge environment.

.DESCRIPTION
This Cmdlet simply displays the current setup of the merge environment.

"Base" usually contains the current customer source code.
"Source" usually contains the source code which has to be merged into the customer version.
"Target" will contain the merge output.
"Merge Tool" shows the path to the executable of the merge tool you are currently using.
#>

  Write-Host "Current merge environment:"
  Write-Host
  
  Write-Host "Base"
  Write-Host ("-Path: " + (getUserEnvVar $script:ME_BASE))
  Write-Host ("-UserEnvironmentVariable: " + $script:ME_BASE)
  Write-Host
  
  Write-Host "Source" 
  Write-Host ("-Path: " + (getUserEnvVar $script:ME_SOURCE))
  Write-Host ("-UserEnvironmentVariable: " + $script:ME_SOURCE)
  Write-Host

  Write-Host "Target" 
  Write-Host ("-Path: " + (getUserEnvVar $script:ME_TARGET))
  Write-Host ("-UserEnvironmentVariable: " + $script:ME_TARGET)
  Write-Host
  
  Write-Host "Merge Tool" 
  Write-Host ("-Path: " + (getUserEnvVar $script:ME_TOOL))
  Write-Host ("-UserEnvironmentVariable: " + $script:ME_TOOL)
  Write-Host
}
