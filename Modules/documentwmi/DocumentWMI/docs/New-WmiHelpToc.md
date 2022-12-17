---
external help file: DocumentWMI-help.xml
Module Name: DocumentWMI
ms.date: 06/05/2021
online version:
schema: 2.0.0
---

# New-WmiHelpToc

## SYNOPSIS
Creates a toc.yaml files for all markdown files in a folder.

## SYNTAX

```
New-WmiHelpToc [[-SourcePath] <string>] [[-OutputPath] <string>] [-TocBasePath <string>]
 [-StartDepth <int>]
```

## DESCRIPTION

Creates a `toc.yaml` files for all markdown files in a folder. Each class file will be a node in the
TOC. If a class has methods, the class and methods files are listed in a subnode of the class.

The contents of this `toc.yaml` file is meant to be copied and inserted in a larger TOC for your
docset. By default, all nodes in the TOC start at the root level (no indentation) and all file paths
(href) only list the filename (no directory path).

## EXAMPLES

### Example 1 - Create a TOC for a set of markdown

```powershell
New-WmiHelpToc -SourcePath c:\temp\WMIDocs -OutputPath c:\temp\WMIDocs
```

### Example 2 - Create a TOC for a set of markdown with a base file path

In this example, the base path `reference/win32` is added as a prefix to the filename in the
**href** key in the TOC.

```powershell
New-WmiHelpToc -SourcePath c:\temp\WMIDocs -OutputPath c:\temp\WMIDocs -TocBasePath 'reference/win32'
Get-Content toc.yaml
```

```Output
    Directory: C:\temp\WMIDocs

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---            6/5/2021  7:03 PM           1619 toc.yml

- name: Win32_ComputerSystem class
  items:
  - name: Win32_ComputerSystem class
    href: reference/win32/win32_computersystem.md
  - name: JoinDomainOrWorkgroup() method of Win32_ComputerSystem class
    href: reference/win32/win32_computersystem-joindomainorworkgroup-method.md
  - name: Rename() method of Win32_ComputerSystem class
    href: reference/win32/win32_computersystem-rename-method.md
  - name: SetPowerState() method of Win32_ComputerSystem class
    href: reference/win32/win32_computersystem-setpowerstate-method.md
  - name: UnjoinDomainOrWorkgroup() method of Win32_ComputerSystem class
    href: reference/win32/win32_computersystem-unjoindomainorworkgroup-method.md
- name: Win32_OperatingSystem class
  items:
  - name: Win32_OperatingSystem class
    href: reference/win32/win32_operatingsystem.md
  - name: Reboot() method of Win32_OperatingSystem class
    href: reference/win32/win32_operatingsystem-reboot-method.md
  - name: SetDateTime() method of Win32_OperatingSystem class
    href: reference/win32/win32_operatingsystem-setdatetime-method.md
  - name: Shutdown() method of Win32_OperatingSystem class
    href: reference/win32/win32_operatingsystem-shutdown-method.md
  - name: Win32Shutdown() method of Win32_OperatingSystem class
    href: reference/win32/win32_operatingsystem-win32shutdown-method.md
  - name: Win32ShutdownTracker() method of Win32_OperatingSystem class
    href: reference/win32/win32_operatingsystem-win32shutdowntracker-method.md
```

## PARAMETERS

### -OutputPath

Specifies the location where the `toc.yaml` file is written. The default is the current folder.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourcePath

Specifies the location where the to find the markdown files. The default is the current folder.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDepth

This parameter is used to indent the contents of the `toc.yaml` file. For example, if you intend to
insert these TOC entries in an existing TOC at a point that is 2 nodes deep, specify a
**StartDepth** of 2.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -TocBasePath

Specifies a string to be added as a prefix to the filename in the TOC. No validation is done on this
value. You must use correct path syntax for your docset.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose,
-WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.IO.FileInfo

## NOTES

## RELATED LINKS
