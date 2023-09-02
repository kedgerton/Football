function Get-AllPlayers() {
    [string]$Directory = '2023_2024'
    $TextInfo   = (Get-Culture).TextInfo
    $PlayerDict = [hashtable]::new()
    $Positions  = @('QB','RB','WR','TE')
    $rootURI    = 'https://www.cbssports.com/fantasy/football/rankings/ppr'
    Remove-Item -Path "/home/kedgerton/GitHub/Football/$($Directory)/*" -Recurse
    foreach ( $_Position in $Positions ) {
        $request = @{
            UseBasicParsing = $true
            Uri             = "$($rootURI)/$($_Position)"
        }
        $Webrequest  = Invoke-WebRequest @request
        $PlayersURL  = $Webrequest.Links.href | Where-Object { $_ -like "/nfl/players/*/fantasy/" } | Sort-Object -Unique

        for ($i = 0; $i -lt $PlayersURL.count; $i++) {
            $PlayerDash  = [regex]::Matches($PlayersURL[$i],"(?<PlayersName>[\w-]{1,}(?=\/))")
            $Player_Name = $TextInfo.ToTitleCase(($PlayerDash.value[-2] -replace "-", ' '))
            $PlayerDict.Add($Player_Name , $_Position)
        }
    }

    foreach ( $_Player in $PlayerDict.Keys ) {
        $Player = [playerbio]::new()
        $Player.getplayerurl($_Player)
        $Player.runrequest()
        switch ( $Player.Position ) {
            'QB' {
                $career = [playercareer_qb]::new()
                $career.getplayerurl($_Player)
                $result = $career.runrequest()
                $career.export($result)
                $week   = [playerweek_qb]::new()
                $week.getplayerurl($_Player)
                $result = $week.runrequest()
                $week.export($result)
                }
            'RB' {
                $career = [playercareer_rb]::new()
                $career.getplayerurl($_Player)
                $result = $career.runrequest()
                $career.export($result)
                $week   = [playerweek_rb]::new()
                $week.getplayerurl($_Player)
                $result = $week.runrequest()
                $week.export($result)
                }
            'WR' {
                $career = [playercareer_wr]::new()
                $career.getplayerurl($_Player)
                $result = $career.runrequest()
                $career.export($result)
                $week   = [playerweek_wr]::new()
                $week.getplayerurl($_Player)
                $result = $week.runrequest()
                $week.export($result)
                }
            'TE' {
                $career = [playercareer_te]::new()
                $career.getplayerurl($_Player)
                $result = $career.runrequest()
                $career.export($result)
                $week   = [playerweek_te]::new()
                $week.getplayerurl($_Player)
                $result = $week.runrequest()
                $week.export($result)
            }
        }
    }
}