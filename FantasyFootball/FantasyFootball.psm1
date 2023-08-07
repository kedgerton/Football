Import-Module -Name PowerHTML
$Path = $PSScriptRoot + "/Functions"
$Files = @($(Get-ChildItem -Path $Path).Name)

Foreach ( $File in $Files ) {
    . "$($Path)/$($File)"
}