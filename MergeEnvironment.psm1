function Write-MergeEnvironment
{
<#
.SYNOPSIS
Display the current setup of the merge environment.

.DESCRIPTION
This Cmdlet simply displays the current setup of the merge environment.
For this it will print the values of the following user environment variables:
  MergeEnv_Base
  MergeEnv_Source
  MergeEnv_Target

"Base" usually contains the current customer source code.
"Source" usually contains the source code which has to be merged into the customer version.
"Target" will contain the merge output.
#>

  Write-Host "Current merge environment setup:"
  Write-Host "Base  : " $([Environment]::GetEnvironmentVariable("MergeEnv_Base", "User"))
  Write-Host "Source: " $([Environment]::GetEnvironmentVariable("MergeEnv_Source", "User"))
  Write-Host "Target: " $([Environment]::GetEnvironmentVariable("MergeEnv_Target", "User"))
}

function Set-MergeEnvironment ($Base, $Source, $Target)
{
  # The user may only specify folders.
  $null = Test-Path $Base -PathType Container -ErrorAction Stop
  $null = Test-Path $Source -PathType Container -ErrorAction Stop
  $null = Test-Path $Target -PathType Container -ErrorAction Stop

  $Base = Get-Item $Base
  $Source = Get-Item $Source
  $Target = Get-Item $Target

  [Environment]::SetEnvironmentVariable("MergeEnv_Base", $Base, "User")
  [Environment]::SetEnvironmentVariable("MergeEnv_Source", $Source, "User")
  [Environment]::SetEnvironmentVariable("MergeEnv_Target", $Target, "User")
  
  Write-MergeEnvironment
}

function Clear-MergeEnvironment
{
  [Environment]::SetEnvironmentVariable("MergeEnv_Base", $null, "User")
  [Environment]::SetEnvironmentVariable("MergeEnv_Source", $null, "User")
  [Environment]::SetEnvironmentVariable("MergeEnv_Target", $null, "User")
  Write-MergeEnvironment
}

function Set-MergeTool ($Executable)
{
  # The user may only specify a file.
  $null = Test-Path $Executable -PathType Leaf -ErrorAction Stop
  $Executable = Get-Item $Executable
  [Environment]::SetEnvironmentVariable("MergeEnv_MergeTool", $Executable, "User")
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

# Run stuff on Import-Module
Write-MergeEnvironment


New-Alias -Name startms -Value Start-MergeSession
New-Alias -Name stopms -Value Stop-MergeSession

Export-ModuleMember `
  -Function * -Alias * -Cmdlet *