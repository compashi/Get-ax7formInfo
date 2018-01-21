mazzy@mazzy.ru, 2018-01-21, [https://github.com/mazzy-ax/Get-ax7formInf](https://github.com/mazzy-ax/Get-ax7formInf)

![version](https://img.shields.io/badge/version-1.0.0-green.svg) ![license](https://img.shields.io/badge/license-MIT-blue.svg)

---

# Get-ax7formInfo

The cmdlet collects an information about form controls from Dynamics 365 For Operation (D365FO, Axapta 7).

1. collect data about grids and form controls with a pattern property.
2. save to csv-file
3. open csv-file in a related csv-editor (MS Excel commonly)

.NOTE

The cmdlet uses the Split-Pipeline to provide parallel data processing. To install module from the PowerShellGallery use the command:

    Install-Module -Name SplitPipeline

.LINK

    [https://github.com/nightroman/SplitPipeline](https://github.com/nightroman/SplitPipeline)
