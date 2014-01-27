function Set-MergeEnvironment
{
<#
.SYNOPSIS
Define three folders for the current merge project.
#>
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true,
               ValueFromPipeline=$false,
               Position=0)]
    [ValidateScript({Test-Path -Path $_ -PathType 'Container'})]
    [string]
    $BasePath,
    
    [Parameter(Mandatory=$true,
               ValueFromPipeline=$false,
               Position=1)]
    [ValidateScript({Test-Path -Path $_ -PathType 'Container'})]
    [string]
    $SourcePath,
    
    [Parameter(Mandatory=$true,
               ValueFromPipeline=$false,
               Position=2)]
    [ValidateScript({Test-Path -Path $_ -PathType 'Container'})]
    [string]
    $TargetPath
  )
  
  $BasePath = Get-Item $BasePath -ErrorAction Stop
  $SourcePath = Get-Item $SourcePath -ErrorAction Stop
  $TargetPath = Get-Item $TargetPath -ErrorAction Stop
  
  $errText = "You must specify three distinct paths!"
  if ($BasePath -eq $SourcePath)
  {
    throw "$errText -BasePath is the same as -SourcePath."
  }
  if ($BasePath -eq $TargetPath)
  {
    throw "$errText -BasePath is the same as -TargetPath."
  }
  if ($SourcePath -eq $TargetPath)
  {
    throw "$errText -SourcePath is the same as -TargetPath."
  }

  
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
