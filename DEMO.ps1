Import-Module UniversalDashboard.Community
Import-Module UniversalDashboard.UDSelector
Get-UDDashboard | Stop-UDDashboard
$theme = New-UDTheme -Name "Basic" -Definition @{
    '.css-1wa3eu0-placeholder'        = @{
        'color' = "rgb(164, 174, 193) !important"
    }
    '.css-1okebmr-indicatorSeparator' = @{
        'background-color' = "rgb(164, 174, 193) !important"
    }
    '.css-1hwfws3'                    = @{
        'height'      = "30px"
        'align-items' = "flex-start"
        'box-sizing'  = "initial !important"
        'flex-wrap'   = "initial !important"
    }
    '.css-1rhbuit-multiValue'         = @{
        'background-color' = "rgb(183, 195, 219) !important"

    }
    '.css-xb97g8'                     = @{
        'background-color' = "rgb(164, 174, 193)"
        'color'            = "#fffaf4"
    }
    '.css-12jo7m5'                    = @{
        'color' = "rgb(255, 255, 255) !important"
    }
    '.css-tlfecz-indicatorContainer'  = @{
        'color' = "rgb(164, 174, 193) !important"
    }
    '.css-yk16xz-control'             = @{
        'border-color' = "rgb(164, 174, 193) !important"
    }
    '.css-1g6gooi'                    = @{
        'padding-top' = "9px !important"
        'color'       = "rgb(164, 174, 193) !important"
    }
} -Parent "Default"
$dashboard = New-UDDashboard -Title "New Component" -Theme $theme -Content {
    New-UDRow -Columns {
        New-UDColumn -size 5 -Content {
            New-UDCard -BackgroundColor "#8789c0" -Content {
                New-UDSelector -Id "Selector" -options @(
                    @{ value = "merry"; label = "Merry" },
                    @{ value = "christmas"; label = "Christmas" },
                    @{ value = "everyone"; label = "Everyone" },
                    @{ value = "pal"; label = "Pal" }
                )
            }

            New-UDButton -Text "Toast" -OnClick {
                (Get-UDElement -id "Selector").Attributes.selectedOption | Out-File C:\UD\t1.txt
                $val = (Get-UDElement -id "Selector").Attributes.selectedOption
                Show-UDToast -Message "Selected:- $val" -Position topLeft -Duration 4000
            }
            New-UDButton -Text "RemoveMe" -OnClick {
                Remove-UDElement -id "Selector"
            }
            New-UDButton -text "ShowME" -OnClick {
                Set-UDElement -id "Selector" -Attributes @{
                    hidden = $false
                }
            }
        }
    }
}
Start-UDDashboard -Dashboard $dashboard -Port 10005