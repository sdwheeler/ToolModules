function ParseProvider {
    param(
        [Parameter(Mandatory)]
        $cmdResults
    )
    # Split output into blocks of text separated by blank lines
    $textBlocks = ($cmdResults | Out-String) -split "`r`n`r`n"

    # For each block of text, parse the lines and create a custom object
    foreach ($block in $textBlocks) {
        if ($block -ne '') {
            $hash = @{}
            # Split the block into lines then split the lines into key/value pairs
            $kvpairs = ($block -split "`r`n").Split(':').Trim()

            foreach ($kv in $kvpairs) {
                switch ($kv) {
                    'Provider name' {
                        if ($foreach.MoveNext()) {
                            $hash.Add('Name',$foreach.Current.Trim("'"))
                        }
                    }
                    'Provider type' {
                        if ($foreach.MoveNext()) {
                            $hash.Add('Type',$foreach.Current)
                        }
                    }
                    'Provider Id' {
                        if ($foreach.MoveNext()) {
                            $hash.Add('Id',([guid]$foreach.Current))
                        }
                    }
                    'Version' {
                        if ($foreach.MoveNext()) {
                            $hash.Add('Version',[version]$foreach.Current)
                        }
                    }
                    'Error' {
                        if ($foreach.MoveNext()) {
                            Write-Error ($block -join '')
                        }
                    }
                }
            }
            [pscustomobject]$hash
        }
    }
}

function ParseShadow {
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
}


function ParseShadowStorage {
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
}

function ParseWriter {
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
}

function ParseVolume {
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
}

function ParseResizeShadowStorage {
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
}

# Tests commands
# ParseProvider (Get-Content .\native-output\providers.txt -Raw)
# ParseShadow (Get-Content .\native-output\shadows.txt -Raw)
# ParseShadowStorage (Get-Content .\native-output\shadowstorage.txt -Raw)
# ParseWriter (Get-Content .\native-output\writers.txt -Raw)
# ParseVolume (Get-Content .\native-output\volumes.txt -Raw)
