class playercareer_te : init {
    [string]${Player Name}
    [string]$Season
    [int]$TAR
    [int]$RECPT
    [int]$REYD
    [int]$RETD
    [int]$REFD
    [int]$REAVG
    [int]$FPTS

    [array] runrequest(){
        $CareerWebRequest = $(Invoke-WebRequest -UseBasicParsing -Uri $($this.'CareerURL')).content
        return $this.careerdata($CareerWebRequest)
    }
    [array] careerdata($career) {
        $CareerObject = $($career | ConvertFrom-Html)
        $CareerArray  = [System.Collections.ArrayList]::new()
        for ( $i = 0 ; $i -lt $($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes.count ) ; $i ++  ) {
            $YearCheck = $($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[0].innertext -replace '\s',"") 
            if ( $YearCheck -match '[0-9]{4}' -and $YearCheck -ne $this.THISYEAR ) {
                $script:Object = New-Object playercareer_te
                $script:Object.'Player Name' =  Invoke-Command {
                    $this.'Player Name'
                }
                $script:Object.'Season' =  Invoke-Command {
                    $Regex = '[0-9]{1,}'
                    [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[0].innertext -replace '\s',"") , $regex).value
                }
                $script:Object.'TAR' =  Invoke-Command {
                    $Regex = '[0-9]{1,}'
                    [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[5].innertext -replace '\s',"") , $regex).value
                }
                $script:Object.'RECPT' =  Invoke-Command {
                    $Regex = '[0-9]{1,}'
                    [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[6].innertext -replace '\s',"") , $regex).value
                }
                $script:Object.'REYD' =  Invoke-Command {
                    $Regex = '[0-9]{1,}'
                    [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[7].innertext -replace '\s',"") , $regex).value
                }
                $script:Object.'RETD' =  Invoke-Command {
                    $Regex = '[0-9]{1,}'
                    [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[9].innertext -replace '\s',"") , $regex).value
                }
                $script:Object.'REFD' =  Invoke-Command {
                    $Regex = '[0-9]{1,}'
                    [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[11].innertext -replace '\s',"") , $regex).value
                }
                $script:Object.'REAVG' =  Invoke-Command {
                    $Regex = '[0-9]{1,}'
                    [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[8].innertext -replace '\s',"") , $regex).value
                }
                $script:Object.'FPTS' =  Invoke-Command {
                    $Regex = '[0-9]{1,}'
                    [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
                }
                $CareerArray.Add($($script:Object | Select-Object -ExcludeProperty CareerURL,FantasyURL,'PlayerHomeURL','GameLogURL') )
            }
        }
        return $CareerArray
    }
}

class playerweek_te : init {
    [string]${Player Name}
    [string]$Week
    [int]$TAR
    [int]$RECPT
    [int]$REYD
    [int]$RETD
    [int]$REAVG
    [int]$FPTS

    [array] runrequest(){
        $WeekWebRequest = $(Invoke-WebRequest -UseBasicParsing -Uri $($this.'GameLogURL')).content
        return $this.careerdata($WeekWebRequest)
    }
    [array] careerdata($week) {
        $WeekObject = $($week | ConvertFrom-Html)
        $WeekArray  = [System.Collections.ArrayList]::new()
        for ( $i = 0 ; $i -lt $($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) ; $i ++  ) {
            $script:Object = New-Object playerweek_te
            $script:Object.'Player Name' =  Invoke-Command {
                $this.'Player Name'
            }
            $script:Object.'Week' =  Invoke-Command {
                $($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) - $i
            }
            $script:Object.'RECPT' = Invoke-Command {
                $Regex = '[0-9]{1,}'
                [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[4].innertext -replace '\s',"") , $regex).value
            }
            $script:Object.'REYD' = Invoke-Command {
                $Regex = '[0-9]{1,}'
                [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[5].innertext -replace '\s',"") , $regex).value
            }
            $script:Object.'RETD' = Invoke-Command {
                $Regex = '[0-9]{1,}'
                [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[7].innertext -replace '\s',"") , $regex).value
            }
            $script:Object.'FPTS' = Invoke-Command {
                $Regex = '[0-9]{1,}'
                [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
            }
            $WeekArray.Add($($script:Object | Select-Object -ExcludeProperty CareerURL,FantasyURL,'PlayerHomeURL','GameLogURL') )
        }
        return $WeekArray
    }
}