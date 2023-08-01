<#
.Synopsis
   Players Info
.DESCRIPTION
   Description of Players
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Get-FootballPlayers
{
    Param
    (
        [string]$Position
    )

    Begin {
        $rootURI = 'https://www.cbssports.com/fantasy/football/rankings/standard'
        [hashtable]$PlayersFantasyHash = @{}
        [hashtable]$PlayersInfoHash    = @{}
        [hashtable]$PlayersIDHash      = @{}
        [hashtable]$PlayersDashHash    = @{}
        #[hashtable]$GameLogHash        = @{}
        $Webrequest = Invoke-WebRequest -UseBasicParsing -Uri "$rootURI/$Position"
        $PlayersURL = $Webrequest.Links.href | Where-Object { $_ -like "/fantasy/football/players/*" -and $_ -notlike '*news/all/' } | Sort-Object -Unique

        for ($i = 0; $i -lt $PlayersURL.count; $i++) {
            $TextInfo                           = (Get-Culture).TextInfo
            $PlayerDash                         = [regex]::Matches($PlayersURL[$i],"(?<PlayersName>[\w-]{1,}(?=\/))")
            $PlayersName                        = $TextInfo.ToTitleCase(($PlayerDash.value[-1] -replace "-", ' '))
            $PlayersDashHash[$PlayersName]     += $PlayerDash[-1].value
            $PlayersFantasyHash[$PlayersName]  += @("https://www.cbssports.com$($PlayersURL[$i])")
            $PlayerID                           = $([regex]::Match($PlayersFantasyHash[$PlayersName] ,"[0-9]{1,}")).value
            $PlayersIDHash[$PlayersName]       += $PlayerID
            $PlayersDataWeb                     = Invoke-WebRequest -UseBasicParsing -Uri $($PlayersFantasyHash[$PlayersName])
            $PlayerDataLink                     = $PlayersDataWeb.Links.href | Where-Object { $_ -like "/nfl/players/$($PlayerID)/$($PlayerDash[-1].value)/" }
            $PlayersInfoHash[$PlayersName]     += @("https://www.cbssports.com$($PlayerDataLink)")
            #$GameLogHash[$PlayersName]         += @("https://www.cbssports.com/fantasy/football/players/game-log/2021/$($Matches.Values)")
        }
    }
    Process {
        foreach ( $NFLPlayer in $PlayersFantasyHash.Keys ) {
            Get-FootballPlayerData -PlayersName $NFLPlayer -Data 'Player' -PlayerID $PlayersIDHash[$NFLPlayer]
        }
        foreach ( $NFLPlayer in $PlayersFantasyHash.Keys ) {
            Get-FootballPlayerData -PlayersName $NFLPlayer -Data 'Career' -PlayerID $PlayersIDHash[$NFLPlayer]
        }
        foreach ( $NFLPlayer in $PlayersFantasyHash.Keys ) {
            Get-FootballPlayerData -PlayersName $NFLPlayer -Data 'Week'   -PlayerID $PlayersIDHash[$NFLPlayer]
        }
    }
    End {
    }
}
 