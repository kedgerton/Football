function Write-FootballModule (){
    #- Set Vars -#
    $ModulePath = "/home/kedgerton/powershell/Modules"
    $GithubPath = "/home/kedgerton/GitHub/Football/FantasyFootball"
    
    #- Remove all files from the functions directory -#
    Set-Location "$($ModulePath)/FantasyFootball"
    Get-ChildItem -Path "./Functions" | Remove-Item -Recurse -Force

    #- copy github files to module -#
    foreach ( $File in Get-ChildItem -Path $("$($GithubPath)/Functions") ) {
        Copy-Item -Path "$($GithubPath)/Functions/$($File.Name)" -Destination "$($ModulePath)/FantasyFootball/Functions/$($File.Name)"
    }
    Set-Location -Path "/home/kedgerton/GitHub/Football"
}