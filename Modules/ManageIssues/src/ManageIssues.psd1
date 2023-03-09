@{

    RootModule        = 'ManageIssues.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'cd79248e-2d34-4e3b-8014-ab5572b94d42'
    Author            = 'sean.wheeler@microsoft.com'
    CompanyName       = 'Microsoft'
    Copyright         = '(c) Microsoft. All rights reserved.'
    Description       = 'This module contains functions to query for issues in GitHub repositories and add closing comments.'
    PowerShellVersion = '7.0'
    AliasesToExport   = @()
    CmdletsToExport   = @()
    DscResourcesToExport = @()
    FunctionsToExport = @(
        'Find-Issue',
        'Add-ClosingComment'
    )
    VariablesToExport = ''
    PrivateData       = @{
        PSData = @{
            # Tags = @()
            LicenseUri = 'https://github.com/sdwheeler/ToolModules/blob/main/LICENSE'
            ProjectUri = 'https://github.com/sdwheeler/ToolModules/tree/main/Modules/ManageIssues'
            # IconUri = ''
            # ReleaseNotes = ''
        }

    }
}

