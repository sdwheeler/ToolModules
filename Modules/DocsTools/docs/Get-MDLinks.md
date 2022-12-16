---
external help file: sdwheeler.DocsHelpers-help.xml
Module Name: sdwheeler.DocsHelpers
ms.date: 09/09/2021
schema: 2.0.0
---

# Get-MDLinks

## Synopsis
Gets a list of the hyperlinks in the Markdown file.

## Syntax

```
Get-MDLinks [[-Path] <String>] [<CommonParameters>]
```

## Description

The cmdlet returns a **PSObject** containing the Markdown link parsed into it's parts:

- **label** - contains the text in the square brackets (`[]`) of the link
- **file** - contains the HTTP file path without the anchor or query strings
- **anchor** - contains the anchor string on the link
- **query** - contains the query string on the link

## Examples

### Example 1 - Get a list of links in an article

```powershell
Get-MDLinks .\install\Installing-PowerShell-Core-on-Windows.md
```

```Output
link   : [Universal C Runtime](https://www.microsoft.com/download/details.aspx?id=50410)
label  : Universal C Runtime
file   : https://www.microsoft.com/download/details.aspx
anchor :
query  : ?id=50410

link   : [WMF Overview](/powershell/scripting/wmf/overview)
label  : WMF Overview
file   : /powershell/scripting/wmf/overview
anchor :
query  :

link   : [ZIP install](#zip)
label  : ZIP install
file   :
anchor : #zip
query  :

link   : [Command line options](/windows/desktop/Msi/command-line-options)
label  : Command line options
file   : /windows/desktop/Msi/command-line-options
anchor :
query  :

link   : [prerequisites](#prerequisites)
label  : prerequisites
file   :
anchor : #prerequisites
query  :

link   : [https://aka.ms/powershell-release?tag=stable](https://aka.ms/powershell-release?tag=stable)
label  : https://aka.ms/powershell-release?tag=stable
file   : https://aka.ms/powershell-release
anchor :
query  : ?tag=stable

link   : [https://aka.ms/powershell-release?tag=preview](https://aka.ms/powershell-release?tag=preview)
label  : https://aka.ms/powershell-release?tag=preview
file   : https://aka.ms/powershell-release
anchor :
query  : ?tag=preview

link   : [https://aka.ms/powershell-release?tag=lts](https://aka.ms/powershell-release?tag=lts)
label  : https://aka.ms/powershell-release?tag=lts
file   : https://aka.ms/powershell-release
anchor :
query  : ?tag=lts

link   : [Nano Server Image Builder](/windows-server/get-started/deploy-nano-server)
label  : Nano Server Image Builder
file   : /windows-server/get-started/deploy-nano-server
anchor :
query  :

link   : [.NET Core SDK](/dotnet/core/sdk)
label  : .NET Core SDK
file   : /dotnet/core/sdk
anchor :
query  :

link   : [.NET Global tool](/dotnet/core/tools/global-tools)
label  : .NET Global tool
file   : /dotnet/core/tools/global-tools
anchor :
query  :

link   : [Microsoft Store](https://www.microsoft.com/store/apps/9MZ1SNWT0N5D)
label  : Microsoft Store
file   : https://www.microsoft.com/store/apps/9MZ1SNWT0N5D
anchor :
query  :

link   : [Understanding how packaged desktop apps run on Windows](/windows/msix/desktop/desktop-to-uwp-behind-the-scenes)
label  : Understanding how packaged desktop apps run on Windows
file   : /windows/msix/desktop/desktop-to-uwp-behind-the-scenes
anchor :
query  :
```

## Parameters

### -Path

The path to the Markdown file containing links. This can be a path to a folder containing Markdown
files. Wildcards are permitted.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose,
-WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## Inputs

### None

## Outputs

### System.Object

## Notes

## Related links
