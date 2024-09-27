
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
                }
            }
            [pscustomobject]$hash
        }
    }

