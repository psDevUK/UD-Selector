Import-Module UniversalDashboard.Community -RequiredVersion 2.8.1
Import-Module UniversalDashboard.UDSelector
function New-UDSelectorItem {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param(
        [Parameter(
            ValueFromPipeline = $true,
            Mandatory = $true,
            Position = 0
        )]
        [string]$Value,
        [Parameter(
            ValueFromPipeline = $true,
            Mandatory = $false,
            Position = 1
        )]
        [string]$Label,
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Disabled"
        )]
        [switch]$isDisabled
    )
    Begin {
        $out = @{ };
    }

    Process {
        if ($null -eq $Label) {
            $Label = $Value
        }

        $out.label = $Label
        $out.value = $Value


        if ($isDisabled.IsPresent) {
            $out.isDisabled = $true
        }
    }

    End {
        return $out
    }
}
Get-UDDashboard | Stop-UDDashboard
$theme = New-UDTheme -Name "Basic" -Definition @{
    '.css-1wa3eu0-placeholder'        = @{
        'color' = "#56587b !important"
    }
    '.css-1okebmr-indicatorSeparator' = @{
        'background-color' = "#56587b !important"
    }
    '.css-1hwfws3'                    = @{
        'height'      = "30px"
        'align-items' = "flex-start"
        'box-sizing'  = "initial !important"
        'flex-wrap'   = "initial !important"
    }
    '.css-1rhbuit-multiValue'         = @{
        'background-color' = "#323246 !important"

    }
    '.css-xb97g8'                     = @{
        'background-color' = "#56587b"
        'color'            = "#fffaf4"
    }
    '.css-12jo7m5'                    = @{
        'color' = "rgb(255, 255, 255) !important"
    }
    '.css-tlfecz-indicatorContainer'  = @{
        'color' = "#56587b !important"
    }
    '.css-yk16xz-control'             = @{
        'border-color' = "#56587b !important"
    }
    '.css-1g6gooi'                    = @{
        'padding-top' = "9px !important"
        'color'       = "#56587b !important"
    }
} -Parent "Default"
$dashboard = New-UDDashboard -Title "New Component" -Theme $theme -Content {
    New-UDRow -Columns {
        New-UDColumn -size 7 -Content {
            $hash = $null
            $hash = @{ }
            $proc = get-process | Sort-Object -Property name -Unique
            foreach ($p in $proc) {
                $hash.add($p.name, $p.id)
            }
            New-UDCard -BackgroundColor "#8789c0" -Content {
                New-UDSelector -id  "stuff" -Options {
                    New-UDSelectorItem -value "SomeStuff1" -label "FancyLabel1"
                    New-UDSelectorItem -value "SomeStuff2" -label "FancyLabel2"
                     New-UDSelectorItem -value "SomeStuff3" -label "FancyLabel3"
                    New-UDSelectorItem -value "SomeStuff4" -label "FancyLabel4" -isDisabled
                } -PlaceHolder "New Fancy Component..."
            }
            New-UDButton -Text "Toast" -OnClick {
                $val = (Get-UDElement -id "stuff").Attributes.selectedOption | ConvertTo-Json -Depth 1 | ConvertFrom-Json | Select-Object -ExpandProperty SyncRoot
                $source = @(($val | Select-Object -ExpandProperty SyncRoot))
                $length = $source.length
                $i = 0
                Do {
                    if (($i % 2) -eq 0) {
                        $value += $source[$i] + ","
                    }
                    $i++
                }
                While ($i -le $length)
                $value = $value.TrimEnd(",")
                Show-UDToast -Message "Selected Values:- $value" -Position topLeft -Duration 4000

            }
            New-UDButton -Text "RemoveMe" -OnClick {
                Remove-UDElement -id "stuff"
            }
            New-UDButton -text "ShowME" -OnClick {
                Set-UDElement -id "stuff" -Attributes @{
                    hidden = $false
                }
            }
            New-UDButton -Text "ClearMe" -OnClick {
                Clear-UDElement -Id "stuff"
            }

        }

    }
}

Start-UDDashboard -Dashboard $dashboard -Port 10005
