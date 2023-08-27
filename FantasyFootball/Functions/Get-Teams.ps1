function Get-Teams() {
    $BaseUri       = "https://www.cbssports.com"
    $Standings_Uri = "$($BaseUri)/nfl/standings/"
    $Webrequest    = Invoke-WebRequest -Uri $Standings_Uri
    $TeamLinks     = $Webrequest.Links.href | ? { $_ -like "/nfl/teams/*" }

    [hashtable]$TeamsHash = @{}
    foreach ( $TeamLink in $TeamLinks ) {
        $TeamsHash[$BaseUri + $TeamLink] = [regex]::Match($TeamLink, "[A-Z]{2,3}").value
    }

    [System.Collections.ArrayList]$Team_Array = @()
    class NFLTeams {
        [string]${Team Name}
        [string]${Team Abv}
        [string]${Team Logo}
        [string]$Wins
        [string]$Losses
        [string]$Ties
        [string]$Conference
        [string]${Conference Wins}
        [string]${Conference Losses}
        [string]${Conference Ties}
        [string]${Conference Rank}
        [string]$Bye
    }
    foreach ( $Team in $TeamsHash.Keys | Where-Object { $_ -ne 'https://www.cbssports.com/nfl/teams/' } ) {
        $request         = (Invoke-WebRequest -UseBasicParsing -Uri $Team).content | ConvertFrom-Html
        $requestschedule = Invoke-WebRequest -UseBasicParsing -uri "$($Team)/schedule/" | ConvertFrom-Html
        $index           = 0
        [int]$tablecount = $requestschedule.Selectnodes('//table')[1].childnodes[2].childnodes.count
        for($i = 0; $i -lt $tablecount; $i++){
            $index++
            if ( $requestschedule.Selectnodes('//table')[1].childnodes[2].childnodes[$($i)].childnodes[2].innertext-like "*BYE*" ){
                $ByeNumber = $index
            }
        }
        $Object = New-Object NFLTeams
        $Object.'Team Name'         = (($request.SelectNodes('//h1')).innertext).TrimEnd() -replace '^[\s]{17}'
        $Object.'Team Abv'          = $TeamsHash[$Team].TrimEnd()
        $Object.'Team Logo'         = [regex]::match(($request.SelectNodes('//figure'))[5].OuterHTML, 'https:\/\/sports\.cbsimg\.net\/fly\/images\/nfl\/logos\/team\/light\/[0-9]{1,}\.svg').value
        $Object.Wins                = [regex]::Match(($request.SelectNodes('//aside'))[1].innerText, "[\d]{1,2}").value
        $Object.Losses              = [regex]::Match(($request.SelectNodes('//aside'))[1].innerText, "(?<=-)[\d]{1,2}(?=-)").value
        $Object.Ties                = [regex]::Match(($request.SelectNodes('//aside'))[1].innerText, "(?<=-)[\d]{1}(?=\s)").value
        $Object.'Conference'        = [regex]::Match(($request.SelectNodes('//aside'))[1].innerText, "[AN][F][C]").value
        $Object.'Conference Wins'   = [regex]::Match(($request.SelectNodes('//aside'))[1].innerText, "(?<=Overall\s\W\s).").value
        $Object.'Conference Losses' = [regex]::Match(($request.SelectNodes('//aside'))[1].innerText, "(?<=Overall\s\W\s.\-).").value
        $Object.'Conference Ties'   = [regex]::Match(($request.SelectNodes('//aside'))[1].innerText, "(?<=Overall\s\W\s.\-.\-).").value
        $Object.'Conference Rank'   = [regex]::Match(($request.SelectNodes('//aside'))[1].innerText, "(?<=Overall\s\W\s.\-.\-.\s[AN]FC\s.\s)[0-9][a-z]{2}").value
        $Object.'Bye'               = $ByeNumber

        $Team_Array.Add($Object) | Out-NUll
    }
    $Team_Array | Export-Csv -Path /home/kedgerton/GitHub/Football/2023_2024/Teams.csv -NoTypeInformation -force
}