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
    [ValidateScript({Test-Path -Path $_ -PathType 'Container'})]
    [string]
    $BasePath,
    
    [Parameter(Mandatory=$false,
               ValueFromPipeline=$false,
               Position=1)]
    [ValidateScript({Test-Path -Path $_ -PathType 'Container'})]
    [string]
    $SourcePath,
    
    [Parameter(Mandatory=$false,
               ValueFromPipeline=$false,
               Position=2)]
    [ValidateScript({Test-Path -Path $_ -PathType 'Container'})]
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
