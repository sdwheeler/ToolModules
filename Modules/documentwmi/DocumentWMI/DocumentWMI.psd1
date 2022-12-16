@{
    ModuleVersion     = '0.1.0'
    GUID              = 'adac1e12-d8aa-4806-bd3a-3531bab1978e'
    Author            = 'Microsoft Corporation'
    CompanyName       = 'Microsoft Corporation'
    Copyright         = '(c) Microsoft. All rights reserved.'
    Description       = 'This module creates documentation for WMI classes in markdown.'
    PowerShellVersion = '5.1'
    NestedModules     = 'DocumentWMI.psm1'
    FunctionsToExport = 'New-WmiHelp', 'New-WmiHelpToc'
    PrivateData       = @{
        PSData = @{
            Tags = @('WMI', 'Docs', 'markdown')
            LicenseUri = 'https://github.com/microsoft/documentwmi/blob/main/LICENSE'
            ProjectUri = 'https://github.com/microsoft/documentwmi'
            ReleaseNotes = 'https://github.com/microsoft/documentwmi/blob/main/LICENSE'
            RequireLicenseAcceptance = $false
            Prerelease = 'beta1'
            # IconUri = ''          # A URL to an icon representing this module.
            # ExternalModuleDependencies = @()    # External dependent modules of this module
        }
    }

    # RootModule = ''             # Script module or binary module file associated with this manifest.
    # CompatiblePSEditions = @()  # Supported PSEditions
    # PowerShellHostName = ''     # Name of the PowerShell host required by this module
    # PowerShellHostVersion = ''  # Minimum version of the PowerShell host required by this module
    # DotNetFrameworkVersion = '' # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # ClrVersion = ''             # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # ProcessorArchitecture = ''  # Processor architecture (None, X86, Amd64) required by this module
    # RequiredModules = @()       # Modules that must be imported into the global environment prior to importing this module
    # RequiredAssemblies = @()    # Assemblies that must be loaded prior to importing this module
    # ScriptsToProcess = @()      # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # TypesToProcess = @()        # Type files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()      # Format files (.ps1xml) to be loaded when importing this module
    # DscResourcesToExport = @()  # DSC resources to export from this module
    # ModuleList = @()            # List of all modules packaged with this module
    # FileList = @()              # List of all files packaged with this module
    # HelpInfoURI = ''            # HelpInfo URI of this module
    # DefaultCommandPrefix = ''   # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.

}

