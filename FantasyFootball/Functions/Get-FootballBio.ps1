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
function Get-FootballBio
{
    Param
    (
        [string]$Html,
        [string]$PlayerID
    )
    Begin {
        class NFL_Player {
            [string]${Player Name}
            [string]$Position
            [string]$Rank
            [string]$NumTeamExp
            [string]${Team Name}
            [string]$Height
            [string]$Weight
            [string]$Age
            [string]$College
            #[string]$Bye
            [string]$IMG
            [bool]$Drafted
        }
        $HtmlObject     = $Html | ConvertFrom-Html
        $FantasyTab     = "https://www.cbssports.com/nfl/players/$($PlayerID)/$($PlayersName)/fantasy/" -replace "\s",'-'
        $FantasyTabHtml = $(Invoke-WebRequest -UseBasicParsing -Uri $FantasyTab).content | ConvertFrom-Html
    }
    Process {
            $Object = New-Object NFL_Player
            $Object.'Player Name' =  Invoke-Command {
                $PlayersName
            }
            $Object.'Position' =  Invoke-Command {
                $Position
            }
            try{
                $object.'Rank' = Invoke-Command {
                    $FantasyTabHtml.SelectNodes('//section')[2].childnodes[5].childnodes[5].childnodes[1].innertext -replace "\s" -replace "#"
                }
            }
            catch{
                $object.'Rank' = 0
            }
            $Object.'Height' =  Invoke-Command {
                $Regex = '[0-9]{1}\-[0-9]{1,2}'
                [regex]::Match($($HtmlObject.SelectNodes('//table')[1].ChildNodes[1].ChildNodes.childnodes[0].innertext -replace '\s',"") , $regex).value
            }
            $Object.'Weight' =  Invoke-Command {
                $Regex = '(?<=\,)[0-9]{3}.+'
                [regex]::Match($($HtmlObject.SelectNodes('//table')[1].ChildNodes[1].ChildNodes.childnodes[0].innertext -replace '\s',"") , $regex).value
            }
            $Object.'NumTeamExp' =  Invoke-Command {
                $Regex = '[0-9]{1,2}'
                [regex]::Match($($HtmlObject.SelectNodes('//table')[1].ChildNodes[1].ChildNodes.childnodes[4].innertext -replace '\s',"") , $regex).value
            }
            $Object.'Team Name' =  Invoke-Command {
                $HtmlObject.selectnodes('//aside')[0].ChildNodes[1].childnodes[5].childnodes[3].childnodes[3].childnodes[1].InnerText.TrimEnd()
            }
            $Object.'Age' =  Invoke-Command {
                $Regex = '[0-9]{1,2}'
                [regex]::Match($($HtmlObject.SelectNodes('//table')[1].ChildNodes[1].ChildNodes.childnodes[2].innertext -replace '\s',"") , $regex).value
            }
            $Object.'College' =  Invoke-Command {
                $Regex = '(?<=\:\s)[A-z]{1,}.+'
                [regex]::Match($($HtmlObject.SelectNodes('//table')[1].ChildNodes[1].ChildNodes.childnodes[3].innertext) , $regex).value.TrimEnd()
            }
            $Object.'IMG' = Invoke-Command {
                "https://sportshub.cbsistatic.com/i/sports/player/headshot/$($PlayerID).png?width=160"
            }
    }
    End {
        $Object | Export-Csv -Path /home/kedgerton/GitHub/Football/2023_2024/CBSFootball$($Position)_Player.csv -Append
    }
}
 