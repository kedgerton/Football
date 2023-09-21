class init {
    hidden [string]$URIRANK   = 'https://www.cbssports.com/fantasy/football/rankings/ppr'
    hidden [string]$URIPLAYER = 'https://www.cbssports.com/nfl/players'
    hidden [string]$LASTYEAR  = '2022'
    hidden [string]$THISYEAR  = '2023'
    hidden [string]$PlayerID
    hidden [array]$Positions  = @('QB','RB','WR','TE')
    hidden [string]${Player Name}
    hidden [string]$Position
    [string]${PlayerHomeURL}
    [string]${FantasyURL}
    [string]${GameLogURL}
    [string]${CareerURL}

    [void] getplayerurl($name){
        $this.'Player Name' = $name
        $name = $($name -replace '\s','-' -replace "\'").ToLower()
        foreach ( $_Position in $this.Positions) {
           $request = @{
                UseBasicParsing = $true
                Uri             = "$($this.URIRANK)/$($_Position)"
            }
            $Webrequest = Invoke-WebRequest @request
            $PlayersURL = $Webrequest.Links.href | Where-Object { $_ -like "/nfl/players/*/$($name)/fantasy/" } | Sort-Object -Unique
            if ( $PlayersURL ) {
                $this.PlayerID        = $([regex]::Match($PlayersURL ,"[0-9]{1,}")).value
                $this.'PlayerHomeURL' = "$($this.URIPLAYER)/$($this.PlayerID)/$($name)"
                $this.'FantasyURL'    = "$($this.URIPLAYER)/$($this.PlayerID)/$($name)/fantasy"
                $this.'GameLogURL'    = "$($this.URIPLAYER)/$($this.PlayerID)/$($name)/game-log/$($this.LASTYEAR)"
                $this.'CareerURL'     = "$($this.URIPLAYER)/$($this.PlayerID)/$($name)/career-stats"
                $this.Position        = $($_Position) 
            }
        }
    }
}