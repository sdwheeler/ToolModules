# PSStyle CHANGELOG

## v1.1.9 - 2025-01-31

Prevent noisy output when removing Type Accelerators at unload - Thanks DaRacci ([#11][11])

## v1.1.8 - 2024-04-16

Fixed format definitions

## v1.1.7 - 2023-12-15

Use Type Accelerators to export classes and enums

- This avoids the need to use the `using module` statement in a startup script, which adds noise to
  the loaded module list.

## v1.1.5 - 2023-06-05

Add static methods to the `PSStyle` class

- MapBackgroundColorToEscapeSequence
- MapColorPairToEscapeSequence
- MapForegroundColorToEscapeSequence

## v1.1.4 - 2023-06-03

Added the `FormatHyperlink()` method to the `PSStyle` class.

## v1.1.3 - 2023-04-24

Moved the PSStyle class definition to a separate file.

- Improves information shown by `Get-Module`

## v1.1.1 - 2023-01-04

Added logic to load without error (silently) on PowerShell 7.2 and higher.

## v1.1.0 - 2023-01-04

PSStyle class member parity with PowerShell 7.4-preview.1

- Added Dim and DimOff
- Added Formatting properties
  - CustomTableHeaderLabel
  - FeedbackProvider
  - FeedbackText

## v1.0.1 - 2022-12-17

Fixed a minor typo

## v1.0.0 - 2022-12-17

Initial release

- PSStyle class member parity with PowerShell 7.3.0

<!-- reference links -->
[11]: https://github.com/sdwheeler/ToolModules/pull/11