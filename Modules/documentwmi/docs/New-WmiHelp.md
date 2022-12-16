---
external help file: DocumentWMI-help.xml
Module Name: DocumentWMI
ms.date: 06/05/2021
online version:
schema: 2.0.0
---

# New-WmiHelp

## SYNOPSIS
Creates help documentation for WMI classes in structured markdown files.

## SYNTAX

```
New-WmiHelp [[-Namespace] <string>] [[-OutputPath] <string>] [-TargetClass <string>]
 [-Metadata <hashtable>] [-CreateValueTables] [-IncludeInventoryClasses] [-IncludePropertyTable]
```

## DESCRIPTION

Creates help documentation for WMI classes in structured markdown files. By default, this cmdlet
creates markdown files for each WMI class and its methods within the target namespace. Optionally,
you can target a specific class using the **TargetClass** parameter.

The cmdlet creates the markdown files using the following name patterns:

- `<classname>.md`
- `<classname>-<methodname>-method.md`

## EXAMPLES

### Example 1 - Create documentation for the Win32_OperatingSystem class

```powershell
New-WmiHelp -TargetClass Win32_OperatingSystem
dir Win32_OperatingSystem*
```

```Output
    Directory: C:\temp\WMIDocs

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---            6/5/2021  2:23 PM           1328 win32_operatingsystem-reboot-method.md
-a---            6/5/2021  2:23 PM           1407 win32_operatingsystem-setdatetime-method.md
-a---            6/5/2021  2:23 PM           1458 win32_operatingsystem-shutdown-method.md
-a---            6/5/2021  2:23 PM           1913 win32_operatingsystem-win32shutdown-method.md
-a---            6/5/2021  2:23 PM           2511 win32_operatingsystem-win32shutdowntracker-method.md
-a---            6/5/2021  2:23 PM          25140 win32_operatingsystem.md
```

### Example 2 - Create documentation for the Win32_ComputerSystem class with custom metadata

```powershell
$meta = @{
    titleSuffix = 'Win32 Classes'
    'ms.prod' = 'Windows Server'
    'ms.technology' = ''
    'ms.topic' = 'reference'
    author = 'aczechowski'
    'ms.author' = 'aaroncz'
    'manager' = 'dougeby'
}
New-WmiHelp -TargetClass Win32_ComputerSystem -Metadata $meta
```

## PARAMETERS

### -CreateValueTables

When this parameter is provided, value-type qualifiers are displayed as tables or lists. The
supported value types are:

- Values
- ValueMap
- BitValues
- BitMap
- Enumeration
- Bits

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeInventoryClasses

By default, this cmdlet does not output documentation for SCCM inventory classes. Using this
parameter includes the inventory classes.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludePropertyTable

When this parameter is used, the cmdlet creates a hyperlinked list of property names for the class.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Metadata

Use this to pass a hash table of metadata key/value pairs. This metadata is written as YAML
frontmatter in every markdown file. By default, the cmdlet creates the following metadata:

- description
- ms.date
- title

```yaml
Type: System.Collections.Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Namespace

Specifies the WMI namespace to be documented. The default namespace is `root\cimv2`

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: Root\cimv2
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputPath

Specifies the folder location to write the markdown files. Default location is the current folder.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: .\
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetClass

Specifies the WMI class to document. The class must exist within the target namespace.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose,
-WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

The cmdlet write output to the host (not the pipeline) to show progress.

## NOTES

## RELATED LINKS
