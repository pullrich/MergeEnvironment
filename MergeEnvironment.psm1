$script:ME_BASE = "MergeEnv_Base"
$script:ME_SOURCE = "MergeEnv_Source"
$script:ME_TARGET = "MergeEnv_Target"



#region Helper functions.

function setUserEnvVar ([string]$Name, [string]$Value)
{
  [Environment]::SetEnvironmentVariable($Name, $Value, "User")
}

function getUserEnvVar ([string]$Name)
{
  [Environment]::GetEnvironmentVariable($Name, "User")
}

function msgUserEnvVarSetTo([string]$varName)
{
  "Set user environment variable `"{0}`" to: {1}" -f $varName, $(getUserEnvVar($varName))
}

#endregion



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
#>

  Write-Host "Current merge environment:"
  
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
}

function Set-MergeEnvironment
{
<#
.SYNOPSIS
Define three folders for the current merge project.
#>
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$false,
               ValueFromPipeline=$false,
               Position=0)]
    [ValidateScript({Test-Path $_ -PathType 'Container'})]
    [string]
    $BasePath,
    
    [Parameter(Mandatory=$false,
               ValueFromPipeline=$false,
               Position=1)]
    [ValidateScript({Test-Path $_ -PathType 'Container'})]
    [string]
    $SourcePath,
    
    [Parameter(Mandatory=$false,
               ValueFromPipeline=$false,
               Position=2)]
    [ValidateScript({Test-Path $_ -PathType 'Container'})]
    [string]
    $TargetPath
  )
  
  if ($BasePath -ne '')
  {
    $BasePath = (Get-Item $BasePath).FullName
    setUserEnvVar $script:ME_BASE $BasePath
    Write-Verbose (msgUserEnvVarSetTo $script:ME_BASE)
  }
  if ($SourcePath -ne '')
  {
    $SourcePath = (Get-Item $SourcePath).FullName
    setUserEnvVar $script:ME_SOURCE $SourcePath
    Write-Verbose (msgUserEnvVarSetTo $script:ME_SOURCE)
  }
  if ($TargetPath -ne '')
  {
    $TargetPath = (Get-Item $TargetPath).FullName
    setUserEnvVar $script:ME_TARGET $TargetPath
    Write-Verbose (msgUserEnvVarSetTo $script:ME_TARGET)
  }
}

function Clear-MergeEnvironment
{
  setUserEnvVar $script:ME_BASE $null  
  setUserEnvVar $script:ME_SOURCE $null  
  setUserEnvVar $script:ME_TARGET $null  
}

function Set-MergeTool ($Executable)
{
  # The user may only specify a file.
  $null = Test-Path $Executable -PathType Leaf -ErrorAction Stop
  $Executable = Get-Item $Executable
  setUserEnvVar "MergeEnv_MergeTool" $Executable
}

function Start-MergeSession ($File)
{
  # Do not continue if it seems like a merge is currently in process.
  $currentlyMerging = [Environment]::GetEnvironmentVariable("MergeEnv_CurrentlyMerging", "User")
  
  if ($currentlyMerging -ne $null)
  {
    if (Test-Path $currentlyMerging)
    {
      Write-Error "You seem to be merging `"$currentlyMerging`" currently. Call Stop-MergeSession before you start a new one."
      return
    }
    else
    {
      [Environment]::SetEnvironmentVariable("MergeEnv_CurrentlyMerging", $null, "User")
    }
  }
  
  
  # TODO: Check that $File exists in Base and Source folder.
  
  $File = Get-Item $File -ErrorAction Stop
  $outputDir = [Environment]::GetEnvironmentVariable("MergeEnv_Target", "User")
  
  # Only continue if output directory does exist.
  $null = Test-Path $outputDir -PathType Container -ErrorAction Stop
  
  # Copy base file to output directory and prepend a "!".
  $fileToReceiveMerge = Join-Path $outputDir "!$($File.Name)"
  Copy-Item $File $fileToReceiveMerge
  [Environment]::SetEnvironmentVariable("MergeEnv_CurrentlyMerging", $fileToReceiveMerge, "User")

  $mergeSourceDir = [Environment]::GetEnvironmentVariable("MergeEnv_Source", "User")
  $mergeTool = [Environment]::GetEnvironmentVariable("MergeEnv_MergeTool", "User")

  # Open merge tool with files.
  & "$mergeTool" $fileToReceiveMerge "$mergeSourceDir\$($File.Name)"
}

function Stop-MergeSession
{
  [CmdletBinding()]
  param ()
  
  $currentlyMerging = [Environment]::GetEnvironmentVariable("MergeEnv_CurrentlyMerging", "User")
  if ($currentlyMerging -ne $null)
  {
    if (Test-Path -Path $currentlyMerging -PathType Leaf -ErrorAction Stop)
    {
      $currentlyMerging = Get-Item $currentlyMerging
      
      # Clear merge marker from file name.
      if ($currentlyMerging.Name -like "!*")
      {
        Write-Verbose "Clearing merge marker from file name."
        Rename-Item -Path $currentlyMerging -NewName $currentlyMerging.Name.TrimStart("!")
        [Environment]::SetEnvironmentVariable("MergeEnv_CurrentlyMerging", $null, "User")
      }
    }
  }
}



New-Alias -Name startms -Value Start-MergeSession
New-Alias -Name sms -Value Start-MergeSession -Description "Start-MergeSession"
New-Alias -Name stopms -Value Stop-MergeSession
New-Alias -Name ems -Value Stop-MergeSession -Description "End-MergeSession; Alternative zu Stop-MergeSession"

Export-ModuleMember `
  -Function *Merge* -Alias * -Cmdlet *


# Run stuff on Import-Module
Show-MergeEnvironment
  