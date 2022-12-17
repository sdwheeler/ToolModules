# CHANGELOG

## v1.0.9 - 17-Dec-2022

- Moved code to a new repo - no functional changes

## v1.0.8 - 15-Sep-2022

- Added **original_content_git_url** property to the output of `Get-LocaleFreshness`

## v1.0.7 - 15-Sep-2022

- Added types and formatters for the output from `Get-LocaleFreshness`
- Added **Locales** parameter to `Get-LocaleFreshness`
- Updated help and CHANGELOG

## v1.0.6 - 04-Aug-2022

- Updated `Get-MDLinks`
  - Fixed regex and return all matches

## v1.0.5 - 17-Nov-2021

- Updated `Get-Syntax` to handle script files

## v1.0.4 - 12-Oct-2021

- Fixed bug in `Get-Syntax` markdown output missing last parameter

## v1.0.3 - 21-Sep-2021

- Fixed bug in date conversion on systems using a non-US date format

## v1.0.2 - 17-Sep-2021

- Fixed bug in `Get-ContentWithoutHeader` that miscalculated the end of the header
- Added CHANGELOG.md

## v1.0.1 - 16-Sep-2021

- Added `Test-YamlTOC`
- Updated the Help

## v1.0.0 - 09-Sep-2021

Initial release - contains the following cmdlets

- `Get-ContentWithoutHeader`
- `Get-HtmlMetaTags`
- `Get-LocaleFreshness`
- `Get-MDLinks`
- `Get-Metadata`
- `Get-OutputType`
- `Get-ShortDescription`
- `Get-Syntax`
- `Get-YamlBlock`
- `hash2yaml`
- `New-LinkRefs`
- `Remove-Metadata`
- `Set-Metadata`
- `Sort-Parameters`
- `Update-Metadata`
