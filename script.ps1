$global:outfile="trackingTable.csv"

function add-csv {
    if (!(Test-Path $outfile)) {
        $newcsv = {} | Select "FILE_NAME","SHA" | Export-Csv $outfile
        Import-Csv $outfile 
        Write-Output "Created csv file."       
    }
}

function main {
    $fileDirectory = ".\Deployments"
    add-csv 
    # $parse_results = New-Object System.Collections.ArrayList;

    # Use a foreach to loop through all the files in a directory.
    # This method allows us to easily track the file name so we can report 
    # our findings by file.
    # get current path and then add file name to it 
    foreach($file in Get-ChildItem $fileDirectory)
    {
        # Processing code goes here
        $filePath = $fileDirectory + "\" + $file;
        $sha =  (Get-Content -Path $file | ConvertFrom-Json).sha

        Write-Output $sha 

        "{0},{1}" -f $filePath,$sha | add-content -path $outfile
    }
}

main