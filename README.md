PoshMergeMaid
================

PowerShell module to assist you in manually merging files.

It basically handles input and output directories for your merge, checking available files, opening your merge tool with the right files from your defined directories and the file name of the current file you are merging.

A simple workflow would look like this:

* In you working directory create the merge directory using New-MergeFolder.
* Make sure you place your original files in the subdirectoy 1_CurrentVersion and your file-to-merge in 2_MergeSource.
* Use Set-MergeEnvironment to point to the subdirectories 1_CurrentVersion, 2_MergeSource, 3_Merged.
* Use Set-MergeTool to point to the executable of your merge tool.
* Use Start-MergeSession <file name> to start a merge session and let it open your merge tool with the correct files.
* Do your merge and make sure you have saved the merged file in your merge tool.
* Use Stop-MergeSession to declare the end of the merge session. This will handle naming the currently merged file.

Your setup (paths and merge tool) will be stored in user variables. They will still be available after you restart your PowerShell session and import this module again.