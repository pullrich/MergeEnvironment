<#
.SYNOPSIS
Erzeugt Unterordner für ein Merge-Projekt.

.DESCRIPTION
Dieses Script erzeugt im aktuellen Ordner folgende Unterordnerstruktur:
  .\Merge
      1_KundeAktuell
        EinzelneObjekte
      2_MergeQuelle
        EinzelneObjekte
      3_Merged
        EinzelneObjekte
#>
function New-MergeFolder
{
  param(
    [string]$Topic
  )
  
  $rootFolder = "Merge - $Topic" 
 
  #$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Continue
  New-Item -ItemType directory -Path ".\$rootFolder\1_KundeAktuell\EinzelneObjekte"
  New-Item -ItemType directory -Path ".\$rootFolder\2_MergeQuelle\EinzelneObjekte"
  New-Item -ItemType directory -Path ".\$rootFolder\3_Merged\EinzelneObjekte"
}