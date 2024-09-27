##############################################################
#region Create Get-VssProvider Command
$cmdlet = @{
    Verb = 'Get'
    Noun = 'VssProvider'
    OriginalName = '$env:Windir/system32/vssadmin.exe'
}
$newCommand = New-CrescendoCommand @cmdlet
$newCommand.OriginalCommandElements = @('list','providers')
$newCommand.Description = 'List registered volume shadow copy providers'
$newCommand.Usage = New-UsageInfo -usage $newCommand.Description
$newCommand.Platform = @('Windows')
#$newCommand.Elevation = [pscustomobject]@{ Command = 'sudo'}

### Add an example to the command
$newCommand.Examples = @()
$example = @{
    Command = 'Get-VssProvider'
    Description = 'Get a list of VSS Providers'
    OriginalCommand = 'vssadmin list providers'
}
$newCommand.Examples += New-ExampleInfo @example

### Define the parameters and parameter sets
# No parameters for this command

### Add an Output Handler to the command
$newCommand.OutputHandlers = @()
$handler = New-OutputHandler
$handler.ParameterSetName = 'Default'
$handler.HandlerType = 'Function'
$handler.Handler = 'ParseProvider'
$newCommand.OutputHandlers += $handler

### Export the command to a JSON file
$exportCrescendoCommandSplat = @{
    command = $newCommand
    fileName = ".\$($cmdlet.Verb)-$($cmdlet.Noun).json"
    Force = $true
}
Export-CrescendoCommand @exportCrescendoCommandSplat
#endregion
##############################################################
#region Create Get-VssShadow Command
$cmdlet = @{
    Verb = 'Get'
    Noun = 'VssShadow'
    OriginalName = '$env:Windir/system32/vssadmin.exe'
}
$newCommand = New-CrescendoCommand @cmdlet
$newCommand.OriginalCommandElements = @('list','shadows')
$newCommand.Description = 'List existing volume shadow copies. Without any options, ' +
    'all shadow copies on the system are displayed ordered by shadow copy set. ' +
    'Combinations of options can be used to refine the output.'
$newCommand.Usage = New-UsageInfo -usage 'List existing volume shadow copies.'
$newCommand.Platform = ,'Windows'

### Add multiple examples to the command
$newCommand.Examples = @()
$example = @{
    Command = 'Get-VssShadow'
    Description = 'Get a list of VSS shadow copies'
    OriginalCommand = 'vssadmin list shadows'
}
$newCommand.Examples += New-ExampleInfo @example
$example = @{
    Command = 'Get-VssShadow -For C:'
    Description = 'Get a list of VSS shadow copies for volume C:'
    OriginalCommand = 'vssadmin list shadows /For=C:'
}
$newCommand.Examples += New-ExampleInfo @example
$example = @{
    Command = "Get-VssShadow -Shadow '{c17ebda1-5da3-4f4a-a3dc-f5920c30ed0f}"
    Description = 'Get a specific shadow copy'
    OriginalCommand = 'vssadmin list shadows /Shadow={3872a791-51b6-4d10-813f-64b4beb9f935}'
}
$newCommand.Examples += New-ExampleInfo @example

### Define the parameters and parameter sets
$newCommand.DefaultParameterSetName = 'Default'
$newCommand.Parameters = @()

#### Add a new parameter to the command
$parameters = New-ParameterInfo -OriginalName '/For=' -Name 'For'
$parameters.ParameterType = 'string'
$parameters.ParameterSetName = @('Default','ByShadowId','BySetId')
$parameters.NoGap = $true
$parameters.Description = "List the shadow copies for volume name like 'C:'"
$newCommand.Parameters += $parameters

#### Add a new parameter to the command
$parameters = New-ParameterInfo -OriginalName '/Shadow=' -Name 'Shadow'
$parameters.ParameterType = 'string'
$parameters.ParameterSetName = @('ByShadowId')
$parameters.NoGap = $true
$parameters.Mandatory = $true
$parameters.Description = "List shadow copies matching the Id in GUID format: " +
    "'{XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX}'"
$newCommand.Parameters += $parameters

#### Add a new parameter to the command
$parameters = New-ParameterInfo -OriginalName '/Set=' -Name 'Set'
$parameters.ParameterType = 'string'
$parameters.ParameterSetName = @('BySetId')
$parameters.NoGap = $true
$parameters.Mandatory = $true
$parameters.Description = "List shadow copies matching the shadow set Id in GUID format: " +
    "'{XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX}'"
$newCommand.Parameters += $parameters

### Add an Output Handler to the command
$newCommand.OutputHandlers = @()

$handler = New-OutputHandler
$handler.Handler = 'ParseShadow'
$handler.HandlerType = 'Function'
$handler.ParameterSetName = 'Default'
$newCommand.OutputHandlers += $handler

$handler = New-OutputHandler
$handler.Handler = 'ParseShadow'
$handler.HandlerType = 'Function'
$handler.ParameterSetName = 'ByShadowId'
$newCommand.OutputHandlers += $handler

$handler = New-OutputHandler
$handler.Handler = 'ParseShadow'
$handler.HandlerType = 'Function'
$handler.ParameterSetName = 'BySetId'
$newCommand.OutputHandlers += $handler

### Export the command to a JSON file
$exportCrescendoCommandSplat = @{
    command = $newCommand
    fileName = ".\$($cmdlet.Verb)-$($cmdlet.Noun).json"
    Force = $true
}
Export-CrescendoCommand @exportCrescendoCommandSplat
#endregion
##############################################################
#region Create Get-VssShadowStorage Command
$cmdlet = @{
    Verb = 'Get'
    Noun = 'VssShadowStorage'
    OriginalName = '$env:Windir/system32/vssadmin.exe'
}
$newCommand = New-CrescendoCommand @cmdlet
$newCommand.OriginalCommandElements = @('list','shadowstorage')
$newCommand.Description = 'List volume shadow copy storage associations. With no parameters, all associations are listed by default.'
$newCommand.Usage = New-UsageInfo -usage $newCommand.Description
$newCommand.Platform = @('Windows')

### Add multiple examples to the command
$newCommand.Examples = @()
$example = @{
    Command         = 'Get-VssShadowStorage'
    Description     = 'List all associations'
    OriginalCommand = 'vssadmin list shadowstorage'
}
$newCommand.Examples += New-ExampleInfo @example
$example = @{
    Command         = 'Get-VssShadowStorage -For C:'
    Description     = 'List all associations for drive C:'
    OriginalCommand = 'vssadmin list shadowstorage /On=C:'
}
$newCommand.Examples += New-ExampleInfo @example
$example = @{
    Command         = 'Get-VssShadowStorage -On C:'
    Description     = 'List all associations on drive C:'
    OriginalCommand = 'vssadmin list shadowstorage /On=C:'
}
$newCommand.Examples += New-ExampleInfo @example

### Define the parameters and parameter sets
$newCommand.DefaultParameterSetName = 'ForVolume'
$newCommand.Parameters = @()

#### Add a new parameter to the command
$parameters = New-ParameterInfo -OriginalName '/For=' -Name 'For'
$parameters.ParameterType = 'string'
$parameters.ParameterSetName = @('ForVolume')
$parameters.NoGap = $true
$parameters.Description = "List all associations for a given volume. Provide a volume name like 'C:'"
$newCommand.Parameters += $parameters

#### Add a new parameter to the command
$parameters = New-ParameterInfo -OriginalName '/On=' -Name 'On'
$parameters.ParameterType = 'string'
$parameters.ParameterSetName = @('OnVolume')
$parameters.NoGap = $true
$parameters.Description = "List all associations on a given volume. Provide a volume name like 'C:'"
$newCommand.Parameters += $parameters

### Add an Output Handler to the command
$newCommand.OutputHandlers = @()

$handler = New-OutputHandler
$handler.Handler = 'ParseShadowStorage'
$handler.HandlerType = 'Function'
$handler.ParameterSetName = 'ForVolume'
$newCommand.OutputHandlers += $handler

$handler = New-OutputHandler
$handler.Handler = 'ParseShadowStorage'
$handler.HandlerType = 'Function'
$handler.ParameterSetName = 'OnVolume'
$newCommand.OutputHandlers += $handler

### Export the command to a JSON file
$exportCrescendoCommandSplat = @{
    command = $newCommand
    fileName = ".\$($cmdlet.Verb)-$($cmdlet.Noun).json"
    Force = $true
}
Export-CrescendoCommand @exportCrescendoCommandSplat
#endregion
##############################################################
#region Create Get-VssVolume Command
$cmdlet = @{
    Verb = 'Get'
    Noun = 'VssVolume'
    OriginalName = '$env:Windir/system32/vssadmin.exe'
}
$newCommand = New-CrescendoCommand @cmdlet
$newCommand.OriginalCommandElements = @('list','volumes')
$newCommand.Description = 'Displays all volumes which may be shadow copied.'
$newCommand.Usage = New-UsageInfo -usage $newCommand.Description
$newCommand.Platform = @('Windows')

### Add multiple examples to the command
$newCommand.Examples = @()
$example = @{
    Command         = 'Get-VssVolume'
    Description     = 'Get all volumes eligible for shadow copies.'
    OriginalCommand = 'vssadmin list volumes'
}
$newCommand.Examples += New-ExampleInfo @example

### Define the parameters and parameter sets
# No parameters for this command

### Add an Output Handler to the command
$newCommand.OutputHandlers = @()
$handler = New-OutputHandler
$handler.Handler = 'ParseVolume'
$handler.HandlerType = 'Function'
$handler.ParameterSetName = 'Default'
$newCommand.OutputHandlers += $handler

### Export the command to a JSON file
$exportCrescendoCommandSplat = @{
    command = $newCommand
    fileName = ".\$($cmdlet.Verb)-$($cmdlet.Noun).json"
    Force = $true
}
Export-CrescendoCommand @exportCrescendoCommandSplat
#endregion
##############################################################
#region Create Get-VssWriter Command
$cmdlet = @{
    Verb = 'Get'
    Noun = 'VssWriter'
    OriginalName = '$env:Windir/system32/vssadmin.exe'
}
$newCommand = New-CrescendoCommand @cmdlet
$newCommand.OriginalCommandElements = @('list','writers')
$newCommand.Description = 'List subscribed volume shadow copy writers.'
$newCommand.Usage = New-UsageInfo -usage $newCommand.Description
$newCommand.Platform = @('Windows')

### Add multiple examples to the command
$newCommand.Examples = @()
$example = @{
    Command         = 'Get-VssVolume'
    Description     = 'Get all volumes eligible for shadow copies.'
    OriginalCommand = 'vssadmin list writers'
}
$newCommand.Examples += New-ExampleInfo @example

### Define the parameters and parameter sets
# No parameters for this command

### Add an Output Handler to the command
$newCommand.OutputHandlers = @()
$handler = New-OutputHandler
$handler.Handler = 'ParseWriter'
$handler.HandlerType = 'Function'
$handler.ParameterSetName = 'Default'
$newCommand.OutputHandlers += $handler

### Export the command to a JSON file
$exportCrescendoCommandSplat = @{
    command = $newCommand
    fileName = ".\$($cmdlet.Verb)-$($cmdlet.Noun).json"
    Force = $true
}
Export-CrescendoCommand @exportCrescendoCommandSplat
#endregion
##############################################################
#region Create Resize-VssShadowStorage Command
$cmdlet = @{
    Verb = 'Resize'
    Noun = 'VssShadowStorage'
    OriginalName = '$env:Windir/system32/vssadmin.exe'
}
$newCommand = New-CrescendoCommand @cmdlet
$newCommand.OriginalCommandElements = @('Resize', 'ShadowStorage')
$newCommand.Description = 'Resizes the maximum size for a shadow copy storage association between ForVolumeSpec and OnVolumeSpec. Resizing the storage association may cause shadow copies to disappear. As certain shadow copies are deleted, the shadow copy storage space will then shrink.'
$newCommand.Usage = New-UsageInfo -usage $newCommand.Description
$newCommand.Platform = @('Windows')

### Add multiple examples to the command
$newCommand.Examples = @()
$example = @{
    Command         = 'Resize-VssShadowStorage -For C: -On C: -MaxSize 900MB'
    Description     = 'Set the new storage size to 900MB'
    OriginalCommand = 'vssadmin resize shadowstorage /For=C: /On=C: /MaxSize=900MB'
}
$newCommand.Examples += New-ExampleInfo @example
$example = @{
    Command         = "Resize-VssShadowStorage -For C: -On C: -MaxPercent '20%'"
    Description     = 'Set the new storage size to 20% of the OnVolume size'
    OriginalCommand = 'vssadmin resize shadowstorage /For=C: /On=C: /MaxSize=20%'
}
$newCommand.Examples += New-ExampleInfo @example
$example = @{
    Command         = 'Resize-VssShadowStorage -For C: -On C: -Unbounded'
    Description     = 'Set the new storage size to unlimited'
    OriginalCommand = 'vssadmin resize shadowstorage /For=C: /On=C: /MaxSize=UNBOUNDED'
}
$newCommand.Examples += New-ExampleInfo @example

### Define the parameters and parameter sets
$newCommand.DefaultParameterSetName = 'ByMaxSize'
$newCommand.Parameters = @()

#### Add a new parameter to the command
$parameters = New-ParameterInfo -OriginalName '/For=' -Name 'For'
$parameters.NoGap = $true
$parameters.Description = "Provide a volume name like 'C:'"
$parameters.ParameterType = 'string'
$parameters.ParameterSetName = @('ByMaxSize', 'ByMaxPercent', 'ByMaxUnbound')
$newCommand.Parameters += $parameters

$parameters = New-ParameterInfo -OriginalName '/On=' -Name 'On'
$parameters.NoGap = $true
$parameters.Description = "Provide a volume name like 'C:'"
$parameters.ParameterType = 'string'
$parameters.ParameterSetName = @('ByMaxSize', 'ByMaxPercent', 'ByMaxUnbound')
$newCommand.Parameters += $parameters

$parameters = New-ParameterInfo -OriginalName '/MaxSize=' -Name 'MaxSize'
$parameters.NoGap = $true
$parameters.Description = 'New maximum size in bytes. Must be 320MB or more.'
$parameters.ParameterType = 'Int64'
$parameters.ParameterSetName = @('ByMaxSize')
$parameters.AdditionalParameterAttributes = @('[ValidateScript({$_ -ge 320MB})]')
$newCommand.Parameters += $parameters

$parameters = New-ParameterInfo -OriginalName '/MaxPercent=' -Name 'MaxPercent'
$parameters.NoGap = $true
$parameters.Description = "A percentage string like '20%'."
$parameters.ParameterType = 'string'
$parameters.ParameterSetName = @('ByMaxPercent')
$parameters.AdditionalParameterAttributes = @("[ValidatePattern('[0-9]+%')]")
$newCommand.Parameters += $parameters

$parameters = New-ParameterInfo -OriginalName '/MaxSize=UNBOUNDED' -Name 'Unbounded'
$parameters.NoGap = $true
$parameters.Description = "Sets the maximum size to UNBOUNDED."
$parameters.ParameterType = 'switch'
$parameters.ParameterSetName = @('ByMaxUnbound')
$newCommand.Parameters += $parameters

### Add an Output Handler to the command
$newCommand.OutputHandlers = @()

$handler = New-OutputHandler
$handler.Handler = 'ParseResizeShadowStorage'
$handler.HandlerType = 'Function'
$handler.ParameterSetName = 'ByMaxSize'
$newCommand.OutputHandlers += $handler

$handler = New-OutputHandler
$handler.Handler = 'ParseResizeShadowStorage'
$handler.HandlerType = 'Function'
$handler.ParameterSetName = 'ByMaxPercent'
$newCommand.OutputHandlers += $handler

$handler = New-OutputHandler
$handler.Handler = 'ParseResizeShadowStorage'
$handler.HandlerType = 'Function'
$handler.ParameterSetName = 'ByMaxUnbound'
$newCommand.OutputHandlers += $handler

### Export the command to a JSON file
$exportCrescendoCommandSplat = @{
    command = $newCommand
    fileName = ".\$($cmdlet.Verb)-$($cmdlet.Noun).json"
    Force = $true
}
Export-CrescendoCommand @exportCrescendoCommandSplat
#endregion
##############################################################
#region Create module
if (-not (Test-Path .\out)) { mkdir .\out}
Export-CrescendoModule -ModuleName .\out\PSVssAdmin -ConfigurationFile *.json -Force
#endregion
