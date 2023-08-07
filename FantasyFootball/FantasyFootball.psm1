$Path = $PSScriptRoot + "/Functions"
# $Path = "/home/kedgerton/powershell/Modules/FantasyFootball/Functions"
$Files = @($(Get-ChildItem -Path $Path).Name)

Foreach ( $File in $Files ) {
    . "$($Path)/$($File)"
}