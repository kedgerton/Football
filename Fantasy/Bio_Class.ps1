class playerbio : init {
    hidden [string]$File = '2023_2024'
    [string]${Player Name}
    [string]$Position
    [string]$Rank
    [string]$NumTeamExp
    [string]${Team Name}
    [string]$Height
    [string]$Weight
    [string]$Age
    [string]$College
    [string]$IMG
    [bool]$Drafted

    [void] runrequest(){
        $PlayerHomeWebRequest = $(Invoke-WebRequest -UseBasicParsing -Uri $($this.'PlayerHomeURL')).content
        $FantasyWebRequest    = $(Invoke-WebRequest -UseBasicParsing -Uri $($this.'FantasyURL')).content
        Write-Host "Collecting Player $($this.'Player Name') Bio Data" -NoNewline
        $this.biodata($PlayerHomeWebRequest,$FantasyWebRequest)
        Write-Host " [ DONE ]" -ForegroundColor Green
    }

    [void] biodata($homeweb,$fantasyweb){
        $HomeObject    = $($homeweb    | ConvertFrom-Html)
        $FantasyObject = $($fantasyweb | ConvertFrom-Html)

        try{
            $this.'Rank' = Invoke-Command {
                $FantasyObject.SelectNodes('//section')[2].childnodes[5].childnodes[5].childnodes[1].innertext -replace "\s" -replace "#"
            }
        }
        catch{
            $this.'Rank' = 0
        }
        $this.'Height' =  Invoke-Command {
            $Regex = '[0-9]{1}\-[0-9]{1,2}'
            [regex]::Match($($HomeObject.SelectNodes('//table')[1].ChildNodes[1].ChildNodes.childnodes[0].innertext -replace '\s',"") , $regex).value
        }
        $this.'Weight' =  Invoke-Command {
            $Regex = '(?<=\,)[0-9]{3}.+'
            [regex]::Match($($HomeObject.SelectNodes('//table')[1].ChildNodes[1].ChildNodes.childnodes[0].innertext -replace '\s',"") , $regex).value
        }
        $this.'Team Name' =  Invoke-Command {
            $HomeObject.selectnodes('//aside')[0].ChildNodes[1].childnodes[5].childnodes[3].childnodes[3].childnodes[1].InnerText.TrimEnd()
        }
        $this.'NumTeamExp' =  Invoke-Command {
            $Regex  = '[0-9]{1,2}'
            $Regex2 = '\#[0-9]{1,}'
            $exp    = [regex]::Match($($HomeObject.SelectNodes('//table')[1].ChildNodes[1].ChildNodes.childnodes[4].innertext -replace '\s',"") , $regex).value
            $num    = [regex]::Match($($HomeObject.SelectNodes('//aside')[1].childnodes[2].innertext), $Regex2).value
            return "$($num) $($Position) / $($this.'Team Name') / EXP: $($exp)YRS"
        }
        $this.'Age' =  Invoke-Command {
            $Regex  = '[0-9]{1,2}'
            
            [regex]::Match($($HomeObject.SelectNodes('//table')[1].ChildNodes[1].ChildNodes.childnodes[2].innertext -replace '\s',"") , $regex).value
        }
        $this.'College' =  Invoke-Command {
            $Regex = '(?<=\:\s)[A-z]{1,}.+'
            [regex]::Match($($HomeObject.SelectNodes('//table')[1].ChildNodes[1].ChildNodes.childnodes[3].innertext) , $regex).value.TrimEnd()
        }
        $this.'IMG' = Invoke-Command {
            "https://sportshub.cbsistatic.com/i/sports/player/headshot/$($PlayerID).png?width=160"
        }
        $this | Select-Object -ExcludeProperty CareerURL,FantasyURL,'PlayerHomeURL','GameLogURL' | Export-Csv -Path "/home/kedgerton/GitHub/Football/$($this.File)/CBSFootball$($this.Position)_Player.csv" -Append
    }
}