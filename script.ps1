$global:outfile="trackingTable.csv"

# Param (
#     [Parameter(Mandatory=$true)][string]$GithubToken
# )

function add-csv {
    if (!(Test-Path $outfile)) {
        $newcsv = {} | Select "FILE_NAME","SHA" | Export-Csv $outfile
        Import-Csv $outfile 
        Write-Output "Created csv file."       
    }
}



function main { 
    param (
        $token
    )

    $Header = @{
        "authorization" = "Bearer $token"
    }

    $branchResponse = Invoke-RestMethod https://api.github.com/repos/aaroncorreya/SmartDeploymentPOC/branches -Headers $header

    Write-Output $branchResponse
    Write-Output $branchResponse.GetType().Name

    $mainSha = $branchResponse | ForEach-Object -Process {if ($_.name -eq "main") {$_.commit.sha}}

    Write-Output $mainSha

    $treeUrl = "https://api.github.com/repos/aaroncorreya/SmartDeploymentPOC/git/trees/" + $mainSha + "?recursive=true"
    Write-Output $treeUrl
    $treeResponse = Invoke-RestMethod $treeUrl -Headers $header

    Write-Output $treeResponse.GetType().Name
    Write-Output $treeResponse.sha

    #Create hashtable
    $csvTable = @{}
    #Add all json files to the hashtable
    $treeResponse.tree | ForEach-Object -Process {if ($_.path.Substring($_.path.Length-5) -eq ".json") {$csvTable.Add($_.path, $_.sha)}}

    Write-Output "testing dictionary"
    Write-Output $csvTable

    #Enumerate through table and add to csv file
    add-csv
    $csvTable.GetEnumerator() | foreach {
        "{0},{1}" -f $_.Key, $_.Value | add-content -path $outfile
    }

    # $createFileUrl = "https://api.github.com/repos/aaroncorreya/SmartDeploymentPOC/repos/aaroncorreya/SmartDeploymentPOC/contents/trackingTable.csv"
    # $createResponse = Invoke-RestMethod $createFileUrl -Headers $header
    # Write-Output $createResponse
}

main -token $args[0]
