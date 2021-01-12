# New-UDSelector

>Bringing react-select to universaldashboard

## Please Read this to figure this component out
This component does work, and is easy enough to build into any dashboard, but I needed a sub-function to get the values
imported into the select list nicely.  Sadly I was able to figure out this when building this component through the plaster 
template.  So please read this guide to become a master at using this component...

### Step 1
To actually install the module via the marketplace or the powershell gallery 
**Install-Module UniversalDashboard.UDSelector**

### Step 2
Import the module into your dashboard project:-
**Import-Module -Name UniversalDashboard.UDSelector**

## Populating the list from SQL
So I thought it would be super handy to automatically fill the select list with values I wanted the user to select from
```
New-UDCard -BackgroundColor "#8789c0" -Endpoint {
$query = @"
SELECT [ProductCode]
,[ProductName]
FROM [YOUR-DB].[dbo].[Products]
"@
    $Products = Invoke-Sqlcmd2 -ServerInstance YOUR-SERVER -Database YOUR-DB -Query $query -Username USERNAME -Password PASSWORD
    $hash = @()
    foreach($item in $Products) {
    $hash += @{
    value = $item.ProductName
    label = $item.ProductCode
    }
    }
New-UDSelector -id  "selector1" -Options {
$hash
} -PlaceHolder "Select Product Codes..."
}
```
Hopefully from the above example you will see how you can use this method to populate the select list with any type of data, it just needs to be in a hash table format **value** **label** format as shown above in the code sample.

### Sub-Function
So another community member was kind enough to share his way of populating the multi-select list you will see in the above example I gave the select list an id of **selector1**
```
function Get-UDSelectorValue {
param($SelectorId)
$value = (((Get-UDElement -Id $SelectorId).Attributes.selectedOption | Select-Object Root -ErrorAction SilentlyContinue) | ConvertTo-Json -Depth 2 | ConvertFrom-Json | Select-Object -ExpandProperty Root -ErrorAction SilentlyContinue) | Select-Object -First 1
if (!$value) {
$val = ((Get-UDElement -Id $SelectorId).Attributes.selectedOption | ConvertTo-Json -Depth 1 | ConvertFrom-Json | Select-Object -ExpandProperty SyncRoot) | Select-Object -ExpandProperty SyncRoot
$length = $val.length
$i = 0
Do {
if (($i % 2) -eq 0) {
$value += "'$($val[$i])'" + ","
}
$i++
}
While ($i -le $length)
$value = $value.TrimEnd(",")
}
return $value
}
```


## Get the selected values 
```
New-UDButtonParticle -Id "Explode3" -Text "Search" -Color "#2e3d55" -BackgroundColor "#2e3d55" -Icon search -onClick {
function Get-UDSelectorValue {
param($SelectorId)
$value = (((Get-UDElement -Id $SelectorId).Attributes.selectedOption | Select-Object Root -ErrorAction SilentlyContinue) | ConvertTo-Json -Depth 2 | ConvertFrom-Json | Select-Object -ExpandProperty Root -ErrorAction SilentlyContinue) | Select-Object -First 1
if (!$value) {
$val = ((Get-UDElement -Id $SelectorId).Attributes.selectedOption | ConvertTo-Json -Depth 1 | ConvertFrom-Json | Select-Object -ExpandProperty SyncRoot) | Select-Object -ExpandProperty SyncRoot
$length = $val.length
$i = 0
Do {
if (($i % 2) -eq 0) {
$value += "'$($val[$i])'" + ","
}
$i++
}
While ($i -le $length)
$value = $value.TrimEnd(",")
}
return $value
}
$Selected =  (Get-UDSelectorValue -SelectorId 'selector1') -replace ",''"
if (($Selected) -notmatch "\A'" )
{
$Selected = "'$Selected'"
}
$Session:Selected2 = $Selected
Show-UDToast -Message "You selected $Session:Selected2" -duration 5000 -Position center
@("GridData9","InsideGrid9","pivot3") | Sync-UDElement
start-sleep -Seconds 5
}
```
This then syncs the grid and pivot table to display the information that was selected with the selected items.

# Update New-UDSingleSelector
I have also added another component based on New-UDSelector, it works in exactly the same way but only allows a single selection. Requested and provided for UD members. So decided to call this one **New-UDSingleSelector** 

## Version 2.0 Released

I now updated this component so it can handle pre-selected items in the list, and the ability to either close or leave open the menu selection after selection.
here is a demo with two pre-selected items.  This could of been one pre-selected item, but I decided to have two for the demo. As well as showing you all the required CSS to style this component to your colour needs.

## Demo with new preselection
```
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
                New-UDSelector -Id "stuff" -Selected {
                    @{ value = "push"; label = "Push" },
                    @{ value = "pull"; label = "Pull" }
                } -options {
                    @{ value = "push"; label = "Push" },
                    @{ value = "pull"; label = "Pull" },
                    @{ value = "jump"; label = "Jump" },
                    @{ value = "throw"; label = "Throw" }
                    @{ value = "kick"; label = "Kick" }
                    @{ value = "punch"; label = "Punch" }
                }

            }

            New-UDButton -Text "Toast" -OnClick {
                $val2 = (Get-UDElement -id "stuff").Attributes.selectedOption.Count | ConvertTo-Json | ConvertFrom-Json
                if ([int]$val2 -gt 1) {
                    $val = (Get-UDElement -id "stuff").Attributes.selectedOption | ConvertTo-Json -Depth 1 | ConvertFrom-Json | Select-Object -ExpandProperty SyncRoot
                    [array]$source = $val | Select-Object -ExpandProperty SyncRoot
                    $c = 0
                    $values = $source | ? { $c % 2 -eq 0; $c++ }
                    $length = $values.length
                    $i = 0
                    Do {
                        $value += "'$($values[$i])'" + ","
                        $i++
                    }
                    While ($i -le $length)
                    $Session:value2 = $value.Substring(0, $value.Length - 4)
                    Show-UDToast -Message "Selected Values:- $Session:value2" -Position topLeft -Duration 4000
                    @("GridData", "InsideGrid") | Sync-UDElement
                }
                elseif ([int]$val2 -eq 1) {
                    $single = (Get-UDElement -id "stuff").Attributes.selectedOption
                    $selection = $single | Select-Object Root | ConvertTo-Json -Depth 2 | ConvertFrom-Json
                    $finalvalue = $selection | Select-Object -ExpandProperty Root
                    $Session:value2 = $finalvalue | Select-Object -First 1
                    Show-UDToast -Message "You Selected $Session:value2"
                }
            }

        }
    }
}
Start-UDDashboard -Dashboard $dashboard -Port 10005
```
