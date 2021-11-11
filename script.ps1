function main {
    $fileDirectory = ".\Deployments\";
    # $parse_results = New-Object System.Collections.ArrayList;

    # Use a foreach to loop through all the files in a directory.
    # This method allows us to easily track the file name so we can report 
    # our findings by file.
    foreach($file in Get-ChildItem $fileDirectory)
    {
        # Processing code goes here
        Write-Output $file
    }
}

main