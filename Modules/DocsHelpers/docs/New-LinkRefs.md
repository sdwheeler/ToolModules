---
external help file: sdwheeler.DocsHelpers-help.xml
Module Name: sdwheeler.DocsHelpers
ms.date: 09/09/2021
schema: 2.0.0
---

# New-LinkRefs

## Synopsis
Creates Markdown link references for all links in a Markdown file.

## Syntax

```
New-LinkRefs [[-path] <String[]>]
```

## Description

The cmdlet creates Markdown link references for all links in a Markdown file. These references are
usually found at the end of the Markdown file. The output can be pasted in the the Markdown file.
You then must edit the hyperlinks in the file to transform them into the reference-style syntax.

## Examples

### Example 1 - Create link references for an article

```powershell
Get-MDLinks .\install\Installing-PowerShell-Core-on-Windows.md
```

```Output
[Universal C Runtime]: https://www.microsoft.com/download/details.aspx?id=50410
[WMF Overview]: /powershell/scripting/wmf/overview
[ZIP install]: #zip
[Command line options]: /windows/desktop/Msi/command-line-options
[prerequisites]: #prerequisites
[https://aka.ms/powershell-release?tag=stable]: https://aka.ms/powershell-release?tag=stable
[https://aka.ms/powershell-release?tag=preview]: https://aka.ms/powershell-release?tag=preview
[https://aka.ms/powershell-release?tag=lts]: https://aka.ms/powershell-release?tag=lts
[Nano Server Image Builder]: /windows-server/get-started/deploy-nano-server
[.NET Core SDK]: /dotnet/core/sdk
[.NET Global tool]: /dotnet/core/tools/global-tools
[Microsoft Store]: https://www.microsoft.com/store/apps/9MZ1SNWT0N5D
[Understanding how packaged desktop apps run on Windows]: /windows/msix/desktop/desktop-to-uwp-behind-the-scenes
```

## Parameters

### -Path

The path to a Markdown file containing links. Wildcards are supported but the output from all files
combined.

```yaml
Type: System.String[]
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
