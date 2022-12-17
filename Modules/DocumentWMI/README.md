# DocumentWMI

**DocumentWMI** is a project to help create and maintain developer reference content for Windows
Management Instrumentation (WMI) classes, properties, and methods. It originated as a Microsoft
hackathon project for the **Microsoft Endpoint Configuration Manager** WMI SDK reference content
from the _root\ccm_ and _root\sms_ WMI namespaces. For those namespaces, this tool can generate over
2000 markdown files for the available classes and methods.

DocumentWMI is a PowerShell module that includes two cmdlets:

- `New-WmiHelp`: Create markdown files for a given WMI namespace.
- `New-WmiHelpToc`: Create a table of contents for those markdown files.

The module also includes help documentation with usage information. For more information on how to
use these cmdlets, after you install the module, use the `Get-Help` cmdlet. For markdown versions
of the help documentation, see [DocumentWMI module](./docs/DocumentWMI.md).

## How to install

The module is available on the PowerShell Gallery at: https://www.powershellgallery.com/packages/DocumentWMI.

Use the following PowerShell commands to install and import it:

```powershell
Install-Module -Name DocumentWMI -AllowPrerelease
Import-Module -Name DocumentWMI
```

## Contributing

First fork and clone this repository. This project welcomes contributions and suggestions. Most
contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have
the right to, and actually do, grant us the rights to use your contribution. For details, visit
https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a
CLA and decorate the PR appropriately (for example, status check and a comment). Simply follow the
instructions provided by the bot. You'll only need to do this once across all repos using our CLA.

This project has adopted the
[Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more
information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or
comments.

## Other resources

- How to file issues and get help: [Support](SUPPORT.md)
- Reporting security issues: [Security](SECURITY.md)
- Online documentation: [DocumentWMI module](./docs/DocumentWMI.md)
- Browse WMI namespaces using [WMI Explorer](https://github.com/vinaypamnani/wmie2)

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of
Microsoft trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion
or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those
third-party's policies.
