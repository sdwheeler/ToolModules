
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
                    'set ID:' {
                        $id = [guid]$line.Split(':')[1].Trim()
                        $hash.Add('SetId',$id)
                        break
                    }
                    'creation time:' {
                        $datetime = [datetime]($line -split 'time:')[1]
                        $hash.Add('CreateTime',$datetime)
                        break
                    }
                    'Copy ID:' {
                        $id = [guid]$line.Split(':')[1].Trim()
                        $hash.Add('CopyId',$id)
                        break
                    }
                    'Original Volume:' {
                        $value = ($line -split 'Volume:')[1].Trim()
                        if ($value -match '^\((?<name>[A-Z]:)\)(?<path>\\{2}.+\\$)') {
                            $volinfo = [pscustomobject]@{
                                Name = $Matches.name
                                Path = $Matches.path
                            }
                        }
                        $hash.Add('OriginalVolume',$volinfo)
                        break
                    }
                    'Copy Volume:' {
                        $hash.Add('ShadowCopyVolume', $line.Split(':')[1].Trim())
                        break
                    }
                    'Machine:' {
                        $parts = $line.Split(':')
                        $hash.Add($parts[0].Replace(' ',''), $parts[1].Trim())
                        break
                    }
                    'Provider:' {
                        $hash.Add('ProviderName',$line.Split(':')[1].Trim(" '"))
                        break
                    }
                    'Type:' {
                        $hash.Add('Type',$line.Split(':')[1].Trim())
                        break
                    }
                    'Attributes' {
                        $attrlist = $line.Split(': ')[1]
                        $hash.Add('Attributes',$attrlist.Split(', '))
                        break
                    }
                }
            }
            [pscustomobject]$hash
        }
    }

