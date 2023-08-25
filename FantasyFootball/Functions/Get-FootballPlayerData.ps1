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
function Get-FootballPlayerData
{
    Param
    (
        [string]$PlayersName,
        [ValidateSet('Player','Career','Week')]
        [string]$Data,
        [int64]$PlayerID
    )
    Begin {
        
        # [System.Collections.ArrayList]$Week_Array   = @()
        
        class NFL_Career{
            [string]${Player Name}
            [string]$Season
            [int]$CMPPCT
            [int]$PAYD
            [int]$PATD
            [int]$PAINT
            [int]$RUYD
            [int]$RUTD
            [int]$FPTS
        }
    }
    Process {
        switch ( $Data ) {
            'Player' {
                $FantasyWebRequest = $(Invoke-WebRequest -UseBasicParsing -Uri $($PlayersInfoHash[$PlayersName])).content
                Get-FootballBio -Html $FantasyWebRequest -PlayerID $PlayerID
            }
            'Career' {
                $FantasyWebRequest = $(Invoke-WebRequest -UseBasicParsing -Uri $("https://www.cbssports.com/nfl/players/$($PlayerID)/$($PlayersDashHash[$PlayersName])/career-stats/")).content
                Get-FootballCareer -Html $FantasyWebRequest

            }
            'Week' {
                $FantasyWebRequest = $(Invoke-WebRequest -UseBasicParsing -Uri $("https://www.cbssports.com/nfl/players/$($PlayerID)/$($PlayersDashHash[$PlayersName])/game-log/2022/")).content
                Get-FootballWeek -Html $FantasyWebRequest
            }
        }
    
    }
    End {

    }

}
 
