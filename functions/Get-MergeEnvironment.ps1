function Get-MergeEnvironment
{
<#
.SYNOPSIS
Gets the current merge environment.

.DESCRIPTION
"Base" usually contains the current customer source code.
"Source" usually contains the source code which has to be merged into the customer version.
"Target" will contain the merge output.
"Merge Tool" shows the path to the executable of the merge tool you are currently using.
#>

  $prop = @{
    PathType = "Base"
    Path = getUserEnvVar $script:ME_BASE
    UserEnvironmentVariable = $script:ME_BASE
  }
  
  New-Object psobject -Property $prop

  $prop = @{
    PathType = "Source"
    Path = getUserEnvVar $script:ME_SOURCE
    UserEnvironmentVariable = $script:ME_SOURCE
  }
  
  New-Object psobject -Property $prop
  
  $prop = @{
    PathType = "Target"
    Path = getUserEnvVar $script:ME_TARGET
    UserEnvironmentVariable = $script:ME_TARGET
  }
  
  New-Object psobject -Property $prop

  $prop = @{
    PathType = "Merge Tool"
    Path = getUserEnvVar $script:ME_TOOL
    UserEnvironmentVariable = $script:ME_TOOL
  }
  
  New-Object psobject -Property $prop

}