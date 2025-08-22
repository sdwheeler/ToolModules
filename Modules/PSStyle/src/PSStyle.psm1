using module .\PSStyle.class.psm1

$PSStyle = [PSStyle]::new()

# Define the types to export with type accelerators.
$ExportableTypes =@(
    [PSStyle]
    [OutputRendering]
    [ProgressView]
    [ForegroundColor]
    [BackgroundColor]
    [FormattingData]
    [ProgressConfiguration]
    [FileInfoFormatting]
)
# Get the internal TypeAccelerators class to use its static methods.
$TypeAcceleratorsClass = [psobject].Assembly.GetType(
    'System.Management.Automation.TypeAccelerators'
)
# Ensure none of the types would clobber an existing type accelerator.
# If a type accelerator with the same name exists, throw an exception.
$ExistingTypeAccelerators = $TypeAcceleratorsClass::Get
foreach ($Type in $ExportableTypes) {
    # Allow overriding if this module was the one who originally made it.
    $LoadedType = $ExistingTypeAccelerators[$Type.FullName];
    $Assembly = $LoadedType.Module.Assembly;
    $LoadingFile = ($Assembly.CustomAttributes.NamedArguments | Where-Object { $_.MemberName -eq 'ScriptFile' }).TypedValue.Value;
    if ($LoadingFile -eq $PSScriptRoot) {
        continue;
    }

    if ($Type.FullName -in $ExistingTypeAccelerators.Keys) {
        $Message = @(
            "Unable to register type accelerator '$($Type.FullName)'"
            'Accelerator already exists.'
        ) -join ' - '

        throw [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new($Message),
            'TypeAcceleratorAlreadyExists',
            [System.Management.Automation.ErrorCategory]::InvalidOperation,
            $Type.FullName
        )
    }
}
# Add type accelerators for every exportable type.
foreach ($Type in $ExportableTypes) {
    $TypeAcceleratorsClass::Add($Type.FullName, $Type)
}
# Remove type accelerators when the module is removed.
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    foreach($Type in $ExportableTypes) {
        $null = $TypeAcceleratorsClass::Remove($Type.FullName)
    }
}.GetNewClosure()

Export-ModuleMember -Variable PSStyle
