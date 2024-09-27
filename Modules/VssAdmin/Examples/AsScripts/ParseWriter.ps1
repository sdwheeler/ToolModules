
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
                    'name:' {
                        $hash.Add('Name',($line -split ': ')[1].Trim("'"))
                        break
                    }
                    'Id:' {
                        $parts = $line -split ': '
                        $key = $parts[0].Replace(' ','')
                        $id = [guid]$parts[1].Trim()
                        $hash.Add($key,$id)
                        break
                    }
                    'State:' {
                        $hash.Add('State', ($line -split ': ')[1].Trim())
                        break
                    }
                    'error:' {
                        $hash.Add('LastError', ($line -split ': ')[1].Trim())
                        break
                    }
                }
            }
            [pscustomobject]$hash
        }
    }

