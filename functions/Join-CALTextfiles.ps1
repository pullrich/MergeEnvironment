function Join-CALTextfiles
{
  param(
    [Parameter(Mandatory=$false)]
    $InputPath=$PWD,
    [Parameter(Mandatory=$true)]
    $OutputPath,
    [Parameter(Mandatory=$false)]
    [ValidateSet("ByType", "SingleFile", "All")]
    $Behavoir="All"
  )
  
  $ObjectTypes = "Table", "Form", "Report", "Dataport", "XMLport", "Codeunit", "MenuSuite", "Page"
  
  if (($Behavoir -eq "All") -or ($Behavoir -eq "ByType"))
  {
    foreach ($ObjectType in $ObjectTypes)
    {
      Get-ChildItem "$InputPath\$ObjectType*.txt" | 
      Get-Content -Encoding Oem | 
      Set-Content "$OutputPath\$($ObjectType)s_ALL_MERGED.txt" -Encoding Oem
    }
  }

  if (($Behavoir -eq "All") -or ($Behavoir -eq "SingleFile"))
  {
    Get-ChildItem "$InputPath\*.txt" |
    sort |
    Get-Content -Encoding Oem |
    Set-Content "$OutputPath\ALL_MERGED.txt" -Encoding Oem
  }
}
