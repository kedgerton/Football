class init {
    hidden [string]$URIRANK   = 'https://www.cbssports.com/fantasy/football/rankings/ppr'
    hidden [string]$URIPLAYER = 'https://www.cbssports.com/nfl/players'
    hidden [string]$LASTYEAR  = '2022'
    hidden [string]$THISYEAR  = '2023'
    hidden [array]$Positions  = ('QB','RB','WR','TE')
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
                $PlayerID           = $([regex]::Match($PlayersURL ,"[0-9]{1,}")).value
                $this.'PlayerHomeURL' = "$($this.URIPLAYER)/$($PlayerID)/$($name)"
                $this.'FantasyURL'     = "$($this.URIPLAYER)/$($PlayerID)/$($name)/fantasy"
                $this.'GameLogURL'    = "$($this.URIPLAYER)/$($PlayerID)/$($name)/game-log/$($this.LASTYEAR)"
                $this.'CareerURL'      = "$($this.URIPLAYER)/$($PlayerID)/$($name)/career-stats"
                $this.Position      = $($_Position) 
            }
        }
    }
}

# class playerbio : init {
#     [string]${Player Name}
#     [string]$Position
#     [string]$Rank
#     [string]$NumTeamExp
#     [string]${Team Name}
#     [string]$Height
#     [string]$Weight
#     [string]$Age
#     [string]$College
#     [string]$IMG
#     [bool]$Drafted

#     [void] runrequest(){
#         $PlayerHomeWebRequest = $(Invoke-WebRequest -UseBasicParsing -Uri $($this.'PlayerHomeURL')).content
#         $FantasyWebRequest    = $(Invoke-WebRequest -UseBasicParsing -Uri $($this.'FantasyURL')).content
#         $this.biodata($PlayerHomeWebRequest,$FantasyWebRequest)
#     }

#     [void] biodata($homeweb,$fantasyweb){
#         $HomeObject    = $($homeweb    | ConvertFrom-Html)
#         $FantasyObject = $($fantasyweb | ConvertFrom-Html)

#         try{
#             $this.'Rank' = Invoke-Command {
#                 $FantasyObject.SelectNodes('//section')[2].childnodes[5].childnodes[5].childnodes[1].innertext -replace "\s" -replace "#"
#             }
#         }
#         catch{
#             $this.'Rank' = 0
#         }
#         $this.'Height' =  Invoke-Command {
#             $Regex = '[0-9]{1}\-[0-9]{1,2}'
#             [regex]::Match($($HomeObject.SelectNodes('//table')[1].ChildNodes[1].ChildNodes.childnodes[0].innertext -replace '\s',"") , $regex).value
#         }
#         $this.'Weight' =  Invoke-Command {
#             $Regex = '(?<=\,)[0-9]{3}.+'
#             [regex]::Match($($HomeObject.SelectNodes('//table')[1].ChildNodes[1].ChildNodes.childnodes[0].innertext -replace '\s',"") , $regex).value
#         }
#         $this.'Team Name' =  Invoke-Command {
#             $HomeObject.selectnodes('//aside')[0].ChildNodes[1].childnodes[5].childnodes[3].childnodes[3].childnodes[1].InnerText.TrimEnd()
#         }
#         $this.'NumTeamExp' =  Invoke-Command {
#             $Regex  = '[0-9]{1,2}'
#             $Regex2 = '\#[0-9]{1,}'
#             $exp    = [regex]::Match($($HomeObject.SelectNodes('//table')[1].ChildNodes[1].ChildNodes.childnodes[4].innertext -replace '\s',"") , $regex).value
#             $num    = [regex]::Match($($HomeObject.SelectNodes('//aside')[1].childnodes[2].innertext), $Regex2).value
#             return "$($num) $($Position) / $($this.'Team Name') / EXP: $($exp)YRS"
#         }
#         $this.'Age' =  Invoke-Command {
#             $Regex  = '[0-9]{1,2}'
            
#             [regex]::Match($($HomeObject.SelectNodes('//table')[1].ChildNodes[1].ChildNodes.childnodes[2].innertext -replace '\s',"") , $regex).value
#         }
#         $this.'College' =  Invoke-Command {
#             $Regex = '(?<=\:\s)[A-z]{1,}.+'
#             [regex]::Match($($HomeObject.SelectNodes('//table')[1].ChildNodes[1].ChildNodes.childnodes[3].innertext) , $regex).value.TrimEnd()
#         }
#         $this.'IMG' = Invoke-Command {
#             "https://sportshub.cbsistatic.com/i/sports/player/headshot/$($PlayerID).png?width=160"
#         }
#     }
# }

# class playercareer_wr : init {
#     [string]${Player Name}
#     [string]$Season
#     [int]$TAR
#     [int]$RECPT
#     [int]$REYD
#     [int]$RETD
#     [int]$REFD
#     [int]$REAVG
#     [int]$FPTS
    

#     [array] runrequest(){
#         $CareerWebRequest = $(Invoke-WebRequest -UseBasicParsing -Uri $($this.'CareerURL')).content
#         return $this.careerdata($CareerWebRequest)
#     }

#     [array] careerdata($career) {
#         $CareerObject = $($career | ConvertFrom-Html)
#         $CareerArray  = [System.Collections.ArrayList]::new()
#         for ( $i = 0 ; $i -lt $($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes.count ) ; $i ++  ) {
#             $YearCheck = $($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[0].innertext -replace '\s',"") 
#             if ( $YearCheck -match '[0-9]{4}' -and $YearCheck -ne $($this.THISYEAR)) {
#                 $script:Object = New-Object playercareer_wr
#                 $script:Object.'Player Name' =  Invoke-Command {
#                     $this.'Player Name'
#                 }
#                 $script:Object.'Season' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[0].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'TAR' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[5].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'RECPT' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[6].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'REYD' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[7].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'RETD' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[9].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'REFD' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[11].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'REAVG' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[8].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'FPTS' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
#                 }
#                 $CareerArray.Add($($script:Object | Select-Object -ExcludeProperty CareerURL,FantasyURL,'PlayerHomeURL','GameLogURL') )
#             }
#         }
#         return $CareerArray
#     }
# }

# class playercareer_qb : init {
#     [string]${Player Name}
#     [string]$Season
#     [int]$CMPPCT
#     [int]$PAYD
#     [int]$PATD
#     [int]$PAINT
#     [int]$RUYD
#     [int]$RUTD
#     [int]$FPTS

#     [array] runrequest(){
#         $CareerWebRequest = $(Invoke-WebRequest -UseBasicParsing -Uri $($this.'CareerURL')).content
#         return $this.careerdata($CareerWebRequest)
#     }
#     [array] careerdata($career) {
#         $CareerObject = $($career | ConvertFrom-Html)
#         $CareerArray  = [System.Collections.ArrayList]::new()
#         for ( $i = 0 ; $i -lt $($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes.count ) ; $i ++  ) {
#             $YearCheck = $($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[0].innertext -replace '\s',"") 
#             if ( $YearCheck -match '[0-9]{4}' -and $YearCheck -ne $this.THISYEAR ) {
#                 $script:Object = New-Object playercareer_qb
#                 $script:Object.'Player Name' =  Invoke-Command {
#                     $this.'Player Name'
#                 }
#                 $script:Object.'Season' = Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[0].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'CMPPCT' = Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[6].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'PAYD' = Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[8].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'PATD' = Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[10].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'PAINT' = Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[11].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'RUYD' = Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[15].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'RUTD' = Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[17].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'FPTS' = Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
#                 }
#                 $CareerArray.Add($($script:Object | Select-Object -ExcludeProperty CareerURL,FantasyURL,'PlayerHomeURL','GameLogURL') )
#             }
#         }
#         return $CareerArray
#     }
# }
# class playercareer_rb : init {
#     [string]${Player Name}
#     [string]$Season
#     [int]$RUATT
#     [int]$RUYD
#     [int]$RUTD
#     [int]$RECPT
#     [int]$REYD
#     [int]$RETD
#     [int]$FPTS

#     [array] runrequest(){
#         $CareerWebRequest = $(Invoke-WebRequest -UseBasicParsing -Uri $($this.'CareerURL')).content
#         return $this.careerdata($CareerWebRequest)
#     }
#     [array] careerdata($career) {
#         $CareerObject = $($career | ConvertFrom-Html)
#         $CareerArray  = [System.Collections.ArrayList]::new()
#         for ( $i = 0 ; $i -lt $($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes.count ) ; $i ++  ) {
#             $YearCheck = $($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[0].innertext -replace '\s',"") 
#             if ( $YearCheck -match '[0-9]{4}' -and $YearCheck -ne $this.THISYEAR ) {
#                 $script:Object = New-Object playercareer_rb
#                 $script:Object.'Player Name' =  Invoke-Command {
#                     $this.'Player Name'
#                 }
#                 $script:Object.'Season' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[0].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'RUATT' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[5].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'RUYD' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[6].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'RUTD' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[8].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'RECPT' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[12].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'REYD' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[13].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'RETD' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[15].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'FPTS' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
#                 }
#                 $CareerArray.Add($($script:Object | Select-Object -ExcludeProperty CareerURL,FantasyURL,'PlayerHomeURL','GameLogURL') )
#             }
#         }
#         return $CareerArray
#     }
# }
# class playercareer_te : init {
#     [string]${Player Name}
#     [string]$Season
#     [int]$TAR
#     [int]$RECPT
#     [int]$REYD
#     [int]$RETD
#     [int]$REFD
#     [int]$REAVG
#     [int]$FPTS

#     [array] runrequest(){
#         $CareerWebRequest = $(Invoke-WebRequest -UseBasicParsing -Uri $($this.'CareerURL')).content
#         return $this.careerdata($CareerWebRequest)
#     }
#     [array] careerdata($career) {
#         $CareerObject = $($career | ConvertFrom-Html)
#         $CareerArray  = [System.Collections.ArrayList]::new()
#         for ( $i = 0 ; $i -lt $($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes.count ) ; $i ++  ) {
#             $YearCheck = $($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[0].innertext -replace '\s',"") 
#             if ( $YearCheck -match '[0-9]{4}' -and $YearCheck -ne $this.THISYEAR ) {
#                 $script:Object = New-Object playercareer_te
#                 $script:Object.'Player Name' =  Invoke-Command {
#                     $this.'Player Name'
#                 }
#                 $script:Object.'Season' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[0].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'TAR' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[5].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'RECPT' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[6].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'REYD' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[7].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'RETD' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[9].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'REFD' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[11].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'REAVG' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[8].innertext -replace '\s',"") , $regex).value
#                 }
#                 $script:Object.'FPTS' =  Invoke-Command {
#                     $Regex = '[0-9]{1,}'
#                     [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
#                 }
#                 $CareerArray.Add($($script:Object | Select-Object -ExcludeProperty CareerURL,FantasyURL,'PlayerHomeURL','GameLogURL') )
#             }
#         }
#         return $CareerArray
#     }
# }

# class playerweek_te : init {
#     [string]${Player Name}
#     [string]$Week
#     [int]$TAR
#     [int]$RECPT
#     [int]$REYD
#     [int]$RETD
#     [int]$REAVG
#     [int]$FPTS

#     [array] runrequest(){
#         $WeekWebRequest = $(Invoke-WebRequest -UseBasicParsing -Uri $($this.'GameLogURL')).content
#         return $this.careerdata($WeekWebRequest)
#     }
#     [array] careerdata($week) {
#         $WeekObject = $($week | ConvertFrom-Html)
#         $WeekArray  = [System.Collections.ArrayList]::new()
#         for ( $i = 0 ; $i -lt $($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) ; $i ++  ) {
#             $script:Object = New-Object playerweek_te
#             $script:Object.'Player Name' =  Invoke-Command {
#                 $this.'Player Name'
#             }
#             $script:Object.'Week' =  Invoke-Command {
#                 $($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) - $i
#             }
#             $script:Object.'RECPT' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[4].innertext -replace '\s',"") , $regex).value
#             }
#             $script:Object.'REYD' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[5].innertext -replace '\s',"") , $regex).value
#             }
#             $script:Object.'RETD' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[7].innertext -replace '\s',"") , $regex).value
#             }
#             $script:Object.'FPTS' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
#             }
#             $WeekArray.Add($($script:Object | Select-Object -ExcludeProperty CareerURL,FantasyURL,'PlayerHomeURL','GameLogURL') )
#         }
#         return $WeekArray
#     }
# }

# class playerweek_qb : init {
#     [string]${Player Name}
#     [string]$Week
#     [int]$CMPPCT
#     [int]$PAYD
#     [int]$PATD
#     [int]$PAINT
#     [int]$RUYD
#     [int]$RUTD
#     [int]$FPTS

#     [array] runrequest(){
#         $WeekWebRequest = $(Invoke-WebRequest -UseBasicParsing -Uri $($this.'GameLogURL')).content
#         return $this.careerdata($WeekWebRequest)
#     }
#     [array] careerdata($week) {
#         $WeekObject = $($week | ConvertFrom-Html)
#         $WeekArray  = [System.Collections.ArrayList]::new()
#         for ( $i = 0 ; $i -lt $($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) ; $i ++  ) {
#             $script:Object = New-Object playerweek_qb
#             $script:Object.'Player Name' =  Invoke-Command {
#                 $this.'Player Name'
#             }
#             $script:Object.'Week' =  Invoke-Command {
#                 $($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) - $i
#             }
#             $script:Object.'CMPPCT' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[4].innertext -replace '\s',"") , $regex).value
#             }
#             $script:Object.'PAYD' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[7].innertext -replace '\s',"") , $regex).value
#             }
#             $script:Object.'PATD' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[9].innertext -replace '\s',"") , $regex).value
#             }
#             $script:Object.'PAINT' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[10].innertext -replace '\s',"") , $regex).value
#             }
#             $script:Object.'RUYD' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[15].innertext -replace '\s',"") , $regex).value
#             }
#             $script:Object.'RUTD' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[18].innertext -replace '\s',"") , $regex).value
#             }
#             $script:Object.'FPTS' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
#             }
#             $WeekArray.Add($($script:Object | Select-Object -ExcludeProperty CareerURL,FantasyURL,'PlayerHomeURL','GameLogURL') )
#         }
#         return $WeekArray
#     }
# }

# class playerweek_rb : init {
#     [string]${Player Name}
#     [string]$Week
#     [int]$RUATT
#     [int]$RUYD
#     [int]$RUTD
#     [int]$RECPT
#     [int]$REYD
#     [int]$RETD
#     [int]$FPTS

#     [array] runrequest(){
#         $WeekWebRequest = $(Invoke-WebRequest -UseBasicParsing -Uri $($this.'GameLogURL')).content
#         return $this.careerdata($WeekWebRequest)
#     }
#     [array] careerdata($week) {
#         $WeekObject = $($week | ConvertFrom-Html)
#         $WeekArray  = [System.Collections.ArrayList]::new()
#         for ( $i = 0 ; $i -lt $($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) ; $i ++  ) {
#             $script:Object = New-Object playerweek_rb
#             $script:Object.'Player Name' =  Invoke-Command {
#                 $this.'Player Name'
#             }
#             $script:Object.'Week' =  Invoke-Command {
#                 $($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) - $i
#             }
#             $script:Object.'RUATT' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[4].innertext -replace '\s',"") , $regex).value
#             }
#             $script:Object.'RUYD' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[5].innertext -replace '\s',"") , $regex).value
#             }
#             $script:Object.'RUTD' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[8].innertext -replace '\s',"") , $regex).value
#             }
#             $script:Object.'RECPT' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[11].innertext -replace '\s',"") , $regex).value
#             }
#             $script:Object.'REYD' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[12].innertext -replace '\s',"") , $regex).value
#             }
#             $script:Object.'RETD' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[14].innertext -replace '\s',"") , $regex).value
#             }
#             $script:Object.'FPTS' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
#             }
#             $WeekArray.Add($($script:Object | Select-Object -ExcludeProperty CareerURL,FantasyURL,'PlayerHomeURL','GameLogURL') )
#         }
#         return $WeekArray
#     }
# }

# class playerweek_wr : init {
#     [string]${Player Name}
#     [string]$Week
#     [int]$TAR
#     [int]$RECPT
#     [int]$REYD
#     [int]$RETD
#     [int]$REAVG
#     [int]$FPTS

#     [array] runrequest(){
#         $WeekWebRequest = $(Invoke-WebRequest -UseBasicParsing -Uri $($this.'GameLogURL')).content
#         return $this.careerdata($WeekWebRequest)
#     }
#     [array] careerdata($week) {
#         $WeekObject = $($week | ConvertFrom-Html)
#         $WeekArray  = [System.Collections.ArrayList]::new()
#         for ( $i = 0 ; $i -lt $($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) ; $i ++  ) {
#             $script:Object = New-Object playerweek_wr
#             $script:Object.'Player Name' =  Invoke-Command {
#                 $this.'Player Name'
#             }
#             $script:Object.'Week' =  Invoke-Command {
#                 $($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) - $i
#             }
#             $script:Object.'RECPT' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[4].innertext -replace '\s',"") , $regex).value
#             }
#             $script:Object.'REYD' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[6].innertext -replace '\s',"") , $regex).value
#             }
#             $script:Object.'RETD' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[8].innertext -replace '\s',"") , $regex).value
#             }
#             $script:Object.'REAVG' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[5].innertext -replace '\s',"") , $regex).value
#             }
#             $script:Object.'FPTS' = Invoke-Command {
#                 $Regex = '[0-9]{1,}'
#                 [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
#             }
#             $WeekArray.Add($($script:Object | Select-Object -ExcludeProperty CareerURL,FantasyURL,'PlayerHomeURL','GameLogURL') )
#         }
#         return $WeekArray
#     }
# }