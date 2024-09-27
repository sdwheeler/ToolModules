
    param(
        [Parameter(Mandatory)]
        $cmdResults
    )
    # Split output into blocks of text separated by blank lines
    $textBlocks = ($cmdResults | Out-String) -split "`r`n`r`n"

    if ($textBlocks[1] -like 'Error*') {
        Write-Error $textBlocks[1]
    } elseif ($textBlocks[1] -like 'Success*') {
        Get-VssShadowStorage
    } else {
        $textBlocks[1]
    }

