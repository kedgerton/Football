function Write-FootballModule (){
    #- Set Vars -#
    $ModulePath = "/home/kedgerton/powershell/Modules"
    $GithubPath = "/home/kedgerton/GitHub/Football/Fantasy"
    
    #- Remove all files from the functions directory -#
    Set-Location "$($ModulePath)/Fantasy"
    Get-ChildItem -Path "./" | Remove-Item -Recurse -Force

    #- copy github files to module -#
    foreach ( $File in Get-ChildItem -Path $($($GithubPath)) ) {
        Copy-Item -Path "$($GithubPath)/$($File.Name)" -Destination "$($ModulePath)/Fantasy/$($File.Name)" -Recurse
    }
    Set-Location -Path "/home/kedgerton/GitHub/Football"
}