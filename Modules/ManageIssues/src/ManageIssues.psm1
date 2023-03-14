<#
.SYNOPSIS
Returns a list of stale issues from a GitHub repository.

.DESCRIPTION
This cmdlet returns a list of stale issues from a GitHub repository based on the age of the issue. You can be filter by one or more labels. The output can be saved to a CSV file for further processing.

.PARAMETER OlderThanDays
The number of days that an issue must be older than to be considered stale.

.PARAMETER OlderThanMonths
The number of months that an issue must be older than to be considered stale.

.PARAMETER Label
One or more labels that the issue must have. Multiple labels are specified as an array
(comma-separated list).

.PARAMETER RepoName
The name of the repository to search. The default is "MicrosoftDocs/azure-docs".

.PARAMETER OutPath
The path to a CSV file to save the output to. If not specified, the output is displayed in the
console.

.EXAMPLE
Find-Issue -OlderThanDays 30 -Label 'cloud-shell/svc'

This example returns a list of issues that are older than 30 days and have the label
"cloud-shell/svc".

.EXAMPLE
Find-Issue -OlderThanMonths 3 -Label 'sql/subsvc', 'synapse-analytics/svc' -OutPath C:\Temp\issues.csv

This example returns a list of issues that are older than 3 months and have the labels "sql/subsvc"
and "synapse-analytics/svc". The output is saved to the file C:\Temp\issues.csv.

.NOTES
This cmdlet requires a GitHub personal access token to be stored in the environment variable
$Env:GITHUB_TOKEN.

#>
function Find-Issue {
    [CmdletBinding(DefaultParameterSetName = 'ByAgeDays')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'ByAgeDays')]
        [uint32]$OlderThanDays,

        [Parameter(Mandatory, ParameterSetName = 'ByAgeMonths')]
        [uint32]$OlderThanMonths,

        [Parameter(ParameterSetName = 'ByAgeDays')]
        [Parameter(ParameterSetName = 'ByAgeMonths')]
        [string[]]$Label,

        [Parameter(ParameterSetName = 'ByAgeDays')]
        [Parameter(ParameterSetName = 'ByAgeMonths')]
        [string]$RepoName = "MicrosoftDocs/azure-docs",

        [Parameter(ParameterSetName = 'ByAgeDays')]
        [Parameter(ParameterSetName = 'ByAgeMonths')]
        [string]$OutPath
    )

    if ([string]::IsNullOrEmpty($Env:GITHUB_TOKEN) -or
        [string]::IsNullOrEmpty($Env:GITHUB_TOKEN.trim())) {
        $PSCmdlet.ThrowTerminatingError('GitHub personal access token not found.' +
        ' store your token in the $Env:GITHUB_TOKEN environment variable.')
    }

    $hdr = @{
        Accept        = 'application/vnd.github.raw+json'
        Authorization = "token ${Env:\GITHUB_TOKEN}"
    }

    $today = Get-Date
    if ($PSCmdlet.ParameterSetName -eq 'ByAgeDays') {
        $date = $today.AddDays(-$OlderThanDays)
    } else {
        $date = $today.AddMonths(-$OlderThanMonths)
    }
    $queryparams = 'is:open repo:{0} created:<{1:yyyy-MM-dd}' -f $RepoName,$date
    if ($Label) {
        $queryparams += ' label:' + ($Label -join ' label:')
    }
    $query = 'q=' + [System.Net.WebUtility]::UrlEncode($queryparams) + '&sort=created&order=asc&per_page=100'

    try {
        $issuelist = Invoke-RestMethod "https://api.github.com/search/issues?$query" -Headers $hdr -FollowRelLink
    } catch {
        if (($_.ErrorDetails.Message | ConvertFrom-Json).message -match 'Validation failed') {
            $PSCmdlet.ThrowTerminatingError('Make sure your access token has been configured ' +
            'for SSO with the target orge (MicrosoftDocs).')
        } else {
            $PSCmdlet.ThrowTerminatingError($_.Exception.Message)
        }
    }

    $records = @()
    $issuelist.items | ForEach-Object {
        try {
            $number = $_.number
            $issue = (Invoke-RestMethod $_.url -Headers $hdr)
            $record = [pscustomobject]@{
                Number    = $RepoName + '#' + $issue.number
                Title     = $issue.title
                Age       = ($today - [datetime]($issue.created_at)).TotalDays
                UpdateAge = ($today - [datetime]($issue.updated_at)).TotalDays
                Labels    = $issue.labels.name -join ', '
                Assignee  = $issue.assignee.login
                htmlUrl   = $issue.html_url
                apiUrl    = $issue.url
                Created   = '{0:yyyy-MM-dd}' -f [datetime]($issue.created_at)
                Updated   = '{0:yyyy-MM-dd}' -f [datetime]($issue.updated_at)
            }
            if ($OutPath -eq '') {
                $record
            } else {
                $records += $record
            }
        } catch {
            if (($_.ErrorDetails.Message | ConvertFrom-Json).message -match 'Bad credentials') {
                $PSCmdlet.ThrowTerminatingError('Invalid GitHub credentials.' +
                ' Check the value of the $Env:GITHUB_TOKEN environment variable.')
            } else {
                Write-Error "Error processing issue #$number - $($_.Exception.Message)"
            }
        }
    }
    if ($OutPath) {
        $records | Export-Csv -Path $OutPath -NoTypeInformation
    }
}

<#
.SYNOPSIS
Adds a comment to a list of issues.

.DESCRIPTION
This cmdlet adds a comment to a list of issues. The list of issues is specified in a CSV file. The
CSV file must have a column named "apiUrl" that contains the URL of the GitHub API for the issue.
You can create this CSV file by using the Find-Issue cmdlet. The comment added to the issue is read
from the specified Markdown file.

.PARAMETER CsvPath
The path to the CSV file that contains the list of issues to add a comment to.

.PARAMETER CommentPath
The path to the Markdown file that contains the comment to add to the issue.

.EXAMPLE
Add-ClosingComment -CsvPath C:\Temp\issues.csv -CommentPath C:\Temp\comment.md

.NOTES
This cmdlet requires a GitHub personal access token to be stored in the environment variable
$Env:GITHUB_TOKEN.
#>
function Add-ClosingComment {
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateScript({Test-Path $_})]
        [string]$CsvPath,

        [Parameter(Mandatory, Position = 1)]
        [ValidateScript({Test-Path $_})]
        [string]$CommentPath
    )

    $hdr = @{
        Accept        = 'application/vnd.github.raw+json'
        Authorization = "token ${Env:\GITHUB_TOKEN}"
    }

    $comment = @{
        body = Get-Content $CommentPath -raw
    }
    $body = $comment | ConvertTo-Json

    Import-Csv $CsvPath | ForEach-Object {
        try {
            $issue = $_
            $number = $issue.Number
            $api = $issue.apiUrl + '/comments'
            $result = Invoke-RestMethod $api -Headers $hdr -Body $body -Method Post
            $result | Select-Object @{n='Issue'; e={$issue.Number}},
                                    @{n='CommentUrl'; e={$_.htmlUrl}}
        } catch {
            if (($_.ErrorDetails.Message | ConvertFrom-Json).message -match 'Bad credentials') {
                $PSCmdlet.ThrowTerminatingError('Invalid GitHub credentials.' +
                ' Check the value of the $Env:GITHUB_TOKEN environment variable.')
            } else {
                Write-Error "Error processing issue $number - $($_.Exception.Message)"
            }
        }
    }
}
