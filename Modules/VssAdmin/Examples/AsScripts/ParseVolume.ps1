
    param(
        [Parameter(Mandatory)]
        $cmdResults
    )
    # Split output into blocks of text separated by blank lines
    $textBlocks = ($cmdResults | Out-String) -split "`r`n`r`n"

    # For each block of text, parse the lines and create a custom object
    foreach ($block in $textBlocks) {
        if ($block -ne '') {
            $hash = [ordered]@{}
            # Split the block into lines
            $lines = ($block -split "`r`n").Trim()

            foreach ($line in $lines) {
                switch -regex ($line) {
                    'path:' {
                        $hash.Add('Path',($line -split ': ')[1].Trim("'"))
                        break
                    }
                    'name:' {
                        $hash.Add('Name',($line -split ': ')[1].Trim("'"))
                        # Output the object and create a new empty hash
                        [pscustomobject]$hash
                        $hash = [ordered]@{}
                        break
                    }
                }
            }
        }
    }

