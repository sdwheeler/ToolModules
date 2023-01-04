# PSStyle module

This module creates the `$PSStyle` variable for versions of PowerShell that
don't have it built-in. For compatibility, the variable includes the same
nested properties that `$PSStyle` has in PowerShell 7.2 and higher. However,
the features that use some of those properties are not available in versions of
PowerShell prior to 7.2.

The purpose is to provide the ANSI string definitions and the `FromRGB()`
methods so that you can use the same `$PSStyle` code in your profile scripts
for Windows PowerShell 5.1 and PowerShell 7.2 and higher.

Trying to import the module in PowerShell 7.2 or higher fails with the
following error:

```
InvalidOperation: Cannot overwrite variable PSStyle because it is read-only or constant.
Import-Module: Cannot overwrite variable PSStyle because it is read-only or constant.
```