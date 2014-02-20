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
      $output = "$OutputPath\$($ObjectType)s_ALL_MERGED.txt"
      Get-ChildItem "$InputPath\$ObjectType*.txt" | 
      Get-Content -Encoding Oem | 
      Set-Content $output -Encoding Oem
      
      Get-Item $output
    }
  }

  if (($Behavoir -eq "All") -or ($Behavoir -eq "SingleFile"))
  {
    $output = "$OutputPath\ALL_MERGED.txt"
    Get-ChildItem "$InputPath\*.txt" |
    sort |
    Get-Content -Encoding Oem |
    Set-Content $output -Encoding Oem
    
    Get-Item $output
  }
}
