# UD-Selector

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

# Update New-UDSingleSelctor
I have also added another component based on New-UDSelector, it works in exactly the same way but only allows a single selection. Requested and provided for UD members. So decided to call this one **New-UDSingleSelector** 
