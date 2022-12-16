function New-WmiHelp {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Namespace = 'root\cimv2',
        [Parameter(Position = 1)]
        [string]$OutputPath = '.',
        [string]$TargetClass,
        [hashtable]$Metadata,
        [switch]$CreateValueTables,
        [switch]$IncludeInventoryClasses,
        [switch]$IncludePropertyTable
    )

    ###########
    # Helper functions
    ###########

    function hash2yaml {
        param(
            [Parameter(Mandatory=$true,
                    Position=0)]
            [hashtable]$meta,

            [Parameter(ParameterSetName='AsCode',
                    Mandatory=$true)]
            [switch]$AsCodeBlock,

            [Parameter(ParameterSetName='AsYaml',
                    Mandatory=$true)]
            [switch]$AsYamlDoc
        )

        if ($AsCodeBlock) {
            $header = '```yaml'
            $footer = '```'
        }

        if ($AsYamlDoc) {
            $header = '---'
            $footer = '---'
        }

        $header
        ForEach ($key in ($meta.keys | Sort-Object)) {
            '{0}: {1}' -f $key, $meta.$key
        }
        $footer
    }
    function Add-SingleLine {
        param([string]$line)
        $null = $mdContent.AppendLine($line)
    }
    function Add-MultipleLines {
        [Parameter(Mandatory=$true)]
        param([string[]]$yaml)

        foreach ($line in $yaml) {
            $null = $mdContent.AppendLine($line)
        }
    }
    function Write-QualifierBlock {
        param(
            [System.Management.QualifierDataCollection]$qualifiers,
            [string[]]$exclusions
        )

        ### Create collection of value qualifiers
        if ($CreateValueTables) {
            $vhash = @{}
            $exclusions += $valueQualifiers
            foreach ($q in $qualifiers) {
                if ($q.name -in $valueQualifiers) {
                    $vhash.Add("$($q.Name)","$($q.Value -join '~!~')")
                }
            }
        }

        ### Create collection of qualifier (may exclude value qualifiers)
        $qhash = @{}
        foreach ($q in $qualifiers) {
            if ($q.name -notin $exclusions) {
                $qhash.Add("$($q.Name)","$($q.Value -join ', ')")
            }
        }

        ### Output values as a table
        if ($CreateValueTables) {
            if ($vhash.ContainsKey('Values')) {
                Add-MultipleLines 'Possible values include:', ''
                $hasMap = $false
                if ($vhash.ContainsKey('ValueMap')) {
                    $hasMap = $true
                    $ValueMap = $vhash.ValueMap -split '~!~'
                }
                $Values = $vhash.Values -split '~!~'
                Add-MultipleLines '| ValueMap | Value |', '|---|---|'
                for ($x=0; $x -lt $Values.Count; $x++) {
                    if ($hasMap) {
                        Add-SingleLine ('| {0} | {1} |' -f $ValueMap[$x], $Values[$x])
                    } else {
                        Add-SingleLine ('| {0} | {1} |' -f $x, $Values[$x])
                    }
                }
                Add-SingleLine ''
            }
            elseif ($vhash.ContainsKey('BitValues')){
                Add-MultipleLines 'Possible BitValues include:', ''
                $hasMap = $false
                if ($vhash.ContainsKey('BitMap')) {
                    $hasMap = $true
                    $ValueMap = $vhash.BitMap -split '~!~'
                }
                $Values = $vhash.BitValues -split '~!~'
                Add-MultipleLines '| BitMap | Value |', '|---|---|'
                for ($x=0; $x -lt $Values.Count; $x++) {
                    if ($hasMap) {
                        Add-SingleLine ('| {0} | {1} |' -f $ValueMap[$x], $Values[$x])
                    } else {
                        Add-SingleLine ('| {0} | {1} |' -f $x, $Values[$x])
                    }
                }
                Add-SingleLine ''
            }
            elseif ($vhash.ContainsKey('Enumeration')) {
                Add-MultipleLines 'Possible enumeration values include:', ''
                $vhash.Enumeration -split ',' | ForEach-Object {
                    Add-SingleLine ('- {0}' -f $_.Trim())
                }
                Add-SingleLine ''
            }
            elseif ($vhash.ContainsKey('Bits')) {
                Add-MultipleLines 'Possible bit values include:', ''
                $vhash.Bits -split ',' | ForEach-Object {
                    Add-SingleLine ('- {0}' -f $_.Trim())
                }
                Add-SingleLine ''
            }
        }

        ### Output qualifiers
        Add-MultipleLines (hash2yaml $qhash -AsCodeBlock)
        Add-SingleLine ''
    }
    function Get-MethodSyntax {
        param ([System.Management.MethodData]$method)

        $name = $method.Name
        $rvType = ''
        $parms = @()
        $text = @()

        foreach ($i in $method.InParameters.Properties) {
            $parms += "    [in] $($i.Type) $($i.Name.ToString())"
        }
        foreach ($o in $method.OutParameters.Properties) {
            if ($o.Name -eq 'ReturnValue') {
                $rvType = $o.Type
            } else {
                $parms += "    [out] $($o.Type) $($o.Name)"
            }
        }

        $text += 'Syntax'
        $text += ''
        $text += '```c'
        if ($parms.Count -eq 0) {
            $text += "$rvType $name();"
        } else {
            $text += "$rvType $name("
            for ($x=0; $x -lt $parms.Count-1; $x++) {
                $text += $parms[$x] + ','
            }
            $text += $parms[$x]
            $text += ');'
        }
        $text += '```'
        $text
    }
    function Get-QualifierValue($Qualifiers, $Name) {
        if ($Name -eq 'Description') {
            $r = '{{ Insert description }}'
        } else {
            $r = $null
        }
        foreach ($q in $Qualifiers) {
            if ($q.Name -eq $Name) {
                $r = $q.Value
                break
            }
        }

        if ($r) {
            $output = @()
            $r -split "`n" | ForEach-Object {
                $tmp = ($_ -replace '\r').Trim()
                if ($tmp -ne '') { $output += $tmp }
            }
            $r = $output -join "`r`n`r`n"
        }
        $r
    }
    function Test-QualifierExists($Qualifiers, $Name) {
        $r = $false

        foreach ($q in $Qualifiers) {
            if ($q.Name -eq $Name) {
                $r = $true
                break
            }
        }

        return $r
    }

    ###########
    # Initialize WMI
    ###########

    if (-not (Test-Path $OutputPath)) { New-Item -ItemType Directory $OutputPath -Force }

    $classQuery = 'SELECT * FROM meta_class WHERE NOT __Class LIKE "[_][_]%" AND NOT __Class LIKE "CIM[_]%" AND NOT __Class LIKE "Win32_Perf%" AND NOT __Class LIKE "MSFT[_]%" AND NOT __Class LIKE "SMS_CM_RES_COLL_%"'
    if (-not $IncludeInventoryClasses) {
        $classQuery += '  AND NOT __Class LIKE "SMS_G_System%" AND NOT __Class LIKE "SMS_GH_System%" AND NOT __Class LIKE "SMS_GEH_System%"'
    }

    If ($TargetClass) {
        $classQuery = "SELECT * FROM meta_class WHERE __Class = '{0}'" -f $TargetClass
    }

    $scope = [System.Management.ManagementScope]::new($Namespace)
    $objectQuery = [System.Management.ObjectQuery]::new($classQuery)

    $enumOptions = [System.Management.EnumerationOptions]::new()
    $enumOptions.EnumerateDeep = $true
    $enumOptions.UseAmendedQualifiers = $true

    $searcher = [System.Management.ManagementObjectSearcher]::new($scope, $objectQuery, $enumOptions)

    $valueQualifiers = 'Values', 'ValueMap', 'Enumeration', 'BitMap', 'BitValues', 'Bits'

    $articleMetadata = @{
        title = ''
        description = ''
        'ms.date' = get-date -Format 'MM/dd/yyyy'
    }

    if ($null -ne $Metadata) {
        foreach ($key in $Metadata.keys) {
            if ($articleMetadata.ContainsKey($key)) {
                $articleMetadata[$key] = $Metadata[$key]
            } else {
                $articleMetadata.Add($key,$Metadata[$key])
            }
        }
    }

    ###########
    # Process class information
    ###########

    foreach ($class in $searcher.Get()) {
        if ($class.Name -eq '') {
            $class.Name = $class.ClassPath.ClassName
        }
        Write-Host "== $($class.Name) =="

        $classFileName = "$($class.Name).md".ToLower()

        $mdContent = [System.Text.StringBuilder]::new()

        $articleMetadata.title = "$($class.Name) class"
        $articleMetadata.description = "$($class.Name) class in $Namespace"
        Add-MultipleLines (hash2yaml $articleMetadata -AsYamlDoc)
        Add-MultipleLines "# $($class.Name) class", ''

        $hasQualifers = $false
        foreach ($q in $class.Qualifiers) {
            if ($q.name -notin 'Description','ResID','ResDLL','Icon') {
                $hasQualifers = $true
            }
        }

        if ($hasQualifers) {
            Add-MultipleLines 'Class Qualifiers', ''
            Write-QualifierBlock -qualifiers $class.Qualifiers -exclusions 'Description','ResID','ResDLL','Icon'
        }

        if ($IncludePropertyTable) {
            Add-MultipleLines 'Property list', ''

            foreach ($p in $class.Properties) {
                $anchor = '#' + $p.Name.ToLower()
                Add-SingleLine "- [$($p.Name)]($anchor)"
            }
            Add-SingleLine ''
        }

        $classDescription = Get-QualifierValue -Qualifiers ($class.Qualifiers) -Name "Description"
        Add-MultipleLines '## Description', '', $classDescription, '', '## Properties', ''

        foreach ($p in $class.Properties) {
            Write-Host "  Property: $($p.Name)"
            $propDescription = Get-QualifierValue -Qualifiers ($p.Qualifiers) -Name "Description"

            Add-MultipleLines "### $($p.Name)", '', $propDescription, ''
            Write-QualifierBlock -qualifiers $p.Qualifiers -exclusions 'Description','ResID','ResDLL'
        }

        Add-MultipleLines '## Methods', ''

        if ($class.Methods.Count -eq 0) {
            Add-MultipleLines 'This class has no methods.', ''
        }
        else {
            foreach ($m in ($class.Methods | Sort-Object Name)) {
                $methodFileName = "$($class.Name)-$($m.Name)-method.md".ToLower()
                Add-SingleLine "- [$($m.Name)]($methodFileName)"
            }
            Add-SingleLine ''
        }

        Add-MultipleLines '## Notes', '',
                        '{{ Insert optional notes }}', '',
                        '## Related links', '',
                        '{{ Insert optional links }}'

        $mdContent.ToString() | Out-File (Join-Path $OutputPath $classFileName) -Encoding utf8 -Force

    ###########
    # Process method information
    ###########

        if ($class.Methods.Count -gt 0) {

            foreach ($m in $class.Methods) {
                Write-Host "  Method: $($m.Name)"
                $methodFileName = "$($class.Name)-$($m.Name)-method.md".ToLower()
                $mdContent = [System.Text.StringBuilder]::new()

                $articleMetadata.title = "$($m.Name)() method of $($class.Name) class"
                $articleMetadata.description = "$($m.Name)() method of $($class.Name) class in $Namespace"
                Add-MultipleLines (hash2yaml $articleMetadata -AsYamlDoc)
                Add-MultipleLines "# $($m.Name)() method of $($class.Name) class", ''

                $hasQualifers = $false
                foreach ($q in $m.Qualifiers) {
                    if ($q.name -ne 'Description') {
                        $hasQualifers = $true
                    }
                }

                if ($hasQualifers) {
                    Add-MultipleLines 'Method qualifiers', ''
                    Write-QualifierBlock -qualifiers $m.Qualifiers -exclusions 'Description'
                }

                Add-MultipleLines (Get-MethodSyntax $m)
                Add-SingleLine ''

                $methodDescription = Get-QualifierValue -Qualifiers ($m.Qualifiers) -Name "Description"
                $methodStatic = Test-QualifierExists -Qualifiers ($m.Qualifiers) -Name "Static"

                $lines = '## Description', '', $methodDescription, '', '> [!NOTE]'
                if ($methodStatic) {
                    $lines += '> This method is static, which means you can use this method without creating an instance of this class.'
                }
                else {
                    $lines += '> This method is not static, which means you need an instance of this class to execute this method.'
                }
                Add-MultipleLines $lines

                Add-MultipleLines '', '## Input Parameters', ''

                if ($m.InParameters.Properties.Count -eq 0) {
                    Add-MultipleLines 'This method has no input parameters.', ''
                }
                else {
                    foreach ($i in $m.InParameters.Properties) {
                        $iDescription = Get-QualifierValue -Qualifiers ($i.Qualifiers) -Name "Description"
                        Add-MultipleLines "### $($i.Name)", '', $iDescription, ''
                        Write-QualifierBlock -qualifiers $i.Qualifiers -exclusions 'Description','In'
                    }
                }

                Add-MultipleLines '## Output Parameters', ''
                if ($m.OutParameters.Properties.Count -eq 0) {
                    Add-MultipleLines 'This method has no output parameters.', ''
                }
                else {
                    foreach ($o in $m.OutParameters.Properties) {
                        if ($o.Name -eq 'ReturnValue') {
                            $rvdesc = Get-QualifierValue -Qualifiers ($o.Qualifiers) -Name "Description"
                            $rvtype = Get-QualifierValue -Qualifiers ($o.Qualifiers) -Name "CIMTYPE"
                            if ($m.OutParameters.Properties.Count -eq 1) {
                                Add-MultipleLines 'This method has no output parameters.', ''
                            }
                        } else {
                            $oDescription = Get-QualifierValue -Qualifiers ($o.Qualifiers) -Name "Description"
                            Add-MultipleLines "### $($o.Name)", '', $oDescription, ''
                            Write-QualifierBlock -qualifiers $o.Qualifiers -exclusions 'Description','ResID','ResDLL','Icon'
                        }
                    }
                }

                Add-MultipleLines '## Return value', '',
                                $rvdesc, '',
                                "Type: $rvtype", '',
                                '## Notes', '',
                                '{{ Insert optional notes }}', '',
                                '## Related links', '',
                                '{{ Insert optional links }}'

                $mdContent.ToString() | Out-File (Join-Path $OutputPath $methodFileName) -Encoding utf8 -Force
            }
        }
        Write-Host
    }
}

function New-WmiHelpToc {
    [CmdletBinding()]
    [OutputType([System.IO.FileInfo])]
    param(
        [Parameter(Position=0)]
        [string]$SourcePath = '.',
        [Parameter(Position=1)]
        [string]$OutputPath = '.',
        [string]$TocBasePath,
        [int]$StartDepth = 0
    )

    ###########
    # Helper functions
    ###########
    function get-yamlblock {
        param($mdpath)
        $doc = Get-Content $mdpath
        $start = $end = -1
        $hdr = ""

        for ($x = 0; $x -lt 30; $x++) {
        if ($doc[$x] -eq '---') {
            if ($start -eq -1) {
            $start = $x + 1
            } else {
            if ($end -eq -1) {
                $end = $x - 1
                break
            }
            }
        }
        }
        if ($end -gt $start) {
        $hdr = $doc[$start..$end]
        $hdr
        }
    }
    function get-metadata {
        param(
            $path,
            [switch]$Recurse
        )

        foreach ($file in (dir -rec:$Recurse -file $path)) {
            $ignorelist = 'keywords','helpviewer_keywords','ms.assetid'
            $lines = get-yamlblock $file
            $meta = @{}
            foreach ($line in $lines) {
                $i = $line.IndexOf(':')
                if ($i -ne -1) {
                    $key = $line.Substring(0,$i)
                    if (!$ignorelist.Contains($key)) {
                        $value = $line.Substring($i+1).replace('"','')
                        switch ($key) {
                            'title' {
                                $value = $value.split('|')[0].trim()
                            }
                            'ms.date' {
                                $value = Get-Date $value -Format 'MM/dd/yyyy'
                            }
                            Default {
                                $value = $value.trim()
                            }
                        }
                        $meta.Add($key,$value)
                    }
                }
            }
            [pscustomobject]$meta
        }
    }

    ###########
    # Validate Parameters
    ###########
    if (-not (Test-Path $SourcePath -PathType Container)) {
        Write-Error ('Source path is not a valid folder: {0}' -f $SourcePath)
        exit 2 # ERROR_FILE_NOT_FOUND
    }
    if (-not (Test-Path $OutputPath -PathType Container)) {
        Write-Error ('Output path is not a valid folder: {0}' -f $SourcePath)
        exit 2 # ERROR_FILE_NOT_FOUND
    }

    ###########
    # Initialize
    ###########

    $TocFile = Join-Path $OutputPath 'toc.yml'
    $SourcePath = Join-Path $SourcePath '*.md'
    if ($TocBasePath -ne '') {
        if (-not $TocBasePath.EndsWith('/')) {
            $TocBasePath += '/'
        }
    }

    $hasMethods = $false
    $indentLevel = $StartDepth
    $tab = '  '
    $nodeTemplate = @'
{indent}- name: {title}
{indent}  items:
'@
    $itemTemplate = @'
{indent}- name: {title}
{indent}  href: {filepath}
'@

    ###########
    # Collect files
    ###########
    Write-Verbose 'Collecting class files...'
    $classFiles = dir $SourcePath -Exclude *-method.md | Select-Object BaseName, FullName, Name

    Write-Verbose 'Collecting method files...'
    $methodFiles = dir -path $SourcePath -Include "*-method.md" | Select-Object BaseName, FullName, Name
    foreach ($class in $classFiles) {
        $m = $methodFiles | Where-Object Name -like "$($class.BaseName)-*"
        $class | Add-Member -MemberType NoteProperty -Name Methods -Value $m
    }

    ###########
    # Process files
    ###########
    Write-Verbose "Creating TOC file: $TocFile"
    $null = New-Item $TocFile -Force

    foreach ($class in $classFiles) {
        $filemetadata = get-metadata -path $class.FullName
        $title = $filemetadata.title
        $hasMethods = $class.Methods.Count -gt 0

        if ($hasMethods) {
            $node = $nodeTemplate -replace '{indent}', ($tab * $indentLevel)
            $node = $node -replace '{title}', $title
            Add-Content -Path $TocFile -Value $node
            $indentLevel++
        }
        $node = $itemTemplate -replace '{indent}', ($tab * $indentLevel)
        $node = $node -replace '{title}', $title
        $node = $node -replace '{filepath}', ($TocBasePath + $class.Name)
        Add-Content -Path $TocFile -Value $node

        if ($hasMethods) {
            foreach($method in $class.Methods){
                $filemetadata = get-metadata -path $method.FullName
                $title = $filemetadata.title
                $node = $itemTemplate -replace '{indent}', ($tab * $indentLevel)
                $node = $node -replace '{title}', $title
                $node = $node -replace '{filepath}', ($TocBasePath + $method.Name)
                Add-Content -Path $TocFile -Value $node
            }
            $indentLevel--
        }
    }

    Get-Item $TocFile
}