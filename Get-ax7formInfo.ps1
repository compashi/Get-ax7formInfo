#Requires -Modules SplitPipeline

# use command to pass requirement
# > Install-Module -Name SplitPipeline


<#
.SYNOPSIS
    The cmdlet collects an information about form controls from Dynamics 365 For Operation (D365FO, Axapta 7).

.DESCRIPTION
    Steps:
    1. collect data about grids and form controls with a pattern property.
    2. save to csv-file
    3. open csv-file in a related csv-editor (MS Excel commonly)

.LINK
    https://github.com/mazzy-ax/Get-ax7formInfo

.NOTE
    The cmdlet uses the Split-Pipeline to provide parallel data processing.
    Use command to install module from the PowerShellGallery
    > Install-Module -Name SplitPipeline

.LINK
    https://github.com/nightroman/SplitPipeline

.AUTHOR
    mazzy@mazzy.ru, 2018-01-21
#>

[CmdletBinding()]
Param (
    [Parameter(Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$Path = 'C:\AOSService\PackagesLocalDirectory\',

    [Parameter(ValueFromPipelineByPropertyName = $true)]
    [string]$Filter = '*.xml',

    [Parameter(ValueFromPipelineByPropertyName = $true)]
    [string]$outFile = 'ax7formInfo.csv'
)

process { 
    (Get-ChildItem -Path $Path -Filter $Filter -Recurse -File -Force).FullName |
    #Select-Objct -First 1000 |
    Split-Pipeline -Verbose -Load 1000,10000 {process{
        $ns = @{ii="Microsoft.Dynamics.AX.Metadata.V6"; i="http://www.w3.org/2001/XMLSchema-instance"}

        Select-XML -XPath '/ii:AxForm' -LiteralPath $_ -Namespace $ns | ForEach-Object {
            $AxForm = $_.Node

            Select-XML '//AxFormControl[Pattern or Type="Grid"]' -Xml $AxForm.Design | ForEach-Object {
                $Control = $_.Node

                new-object psObject -property @{
                    Form = $XmlFileName
                    FormName = $AxForm.Name
                    FormTemplate = $AxForm.FormTemplate
                    FormStyle = $AxForm.Design.Style.InnerText
                    FormPattern = $AxForm.Design.Pattern.InnerText
                    FormPatternVersion = $AxForm.Design.PatternVersion.InnerText
                    WindowType = $AxForm.Design.WindowType.InnerText
                    DialogSize = $AxForm.Design.DialogSize.InnerText
                    Type = $Control.Type[0]
                    Name = $Control.Name
                    Pattern = $Control.Pattern
                    PatternVersion = $Control.PatternVersion
                }
            }
        }
    }} |
    Export-Csv $outFile -Encoding utf8 -NoTypeInformation

    # open csv editor
    Invoke-Item $outFile
}
