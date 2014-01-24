<#
.SYNOPSIS
Creates a directory structure for a merge project.

.DESCRIPTION
This script creates the follwing directory structure in the current working directory:
  .\Merge< - Topic>
      0_Setup
      1_CurrentVersion
      2_MergeSource
      3_Merged
      4_Packaging

#>
function New-MergeFolder
{
  param(
    [string]$Topic
  )
  
  $rootFolder = "Merge"
  if ($Topic)
  {
    $rootFolder = $rootFolder + " - $Topic"
  }
 
  New-Item -ItemType directory -Path ".\$rootFolder\0_Setup"
  New-Item -ItemType directory -Path ".\$rootFolder\1_CurrentVersion"
  New-Item -ItemType directory -Path ".\$rootFolder\2_MergeSource"
  New-Item -ItemType directory -Path ".\$rootFolder\3_Merged"
  New-Item -ItemType directory -Path ".\$rootFolder\4_Packaging"
}
