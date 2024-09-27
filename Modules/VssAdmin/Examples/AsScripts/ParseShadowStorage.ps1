
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
                    'volume:' {
                        $parts = $line -split 'volume:'
                        $key = $parts[0].Replace(' ','') + 'Volume'
                        $value = $parts[1].Trim()
                        if ($value -match '^\((?<name>[A-Z]:)\)(?<path>\\{2}.+\\$)') {
                            $volinfo = [pscustomobject]@{
                                Name = $Matches.name
                                Path = $Matches.path
                            }
                        }
                        $hash.Add($key,$volinfo)
                        break
                    }
                    'space:' {
                        $parts = $line.Split(':')
                        $key = $parts[0].Split(' ')[0] + 'Space'
                        $data = $parts[1].TrimEnd(')') -split ' \('
                        $space = [PSCustomObject]@{
                            Size = $data[0].Replace(' ','')
                            Percent = $data[1]
                        }
                        $hash.Add($key, $space)
                        break
                    }
                }
            }
            [pscustomobject]$hash
        }
    }

