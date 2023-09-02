class playercareer_qb : init {
    [string]${Player Name}
    [string]$Season
    [int]$CMPPCT
    [int]$PAYD
    [int]$PATD
    [int]$PAINT
    [int]$RUYD
    [int]$RUTD
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
                $script:Object = New-Object playercareer_qb
                $script:Object.'Player Name' =  Invoke-Command {
                    $this.'Player Name'
                }
                $script:Object.'Season' = Invoke-Command {
                    $Regex = '[0-9]{1,}'
                    [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[0].innertext -replace '\s',"") , $regex).value
                }
                $script:Object.'CMPPCT' = Invoke-Command {
                    $Regex = '[0-9]{1,}'
                    [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[6].innertext -replace '\s',"") , $regex).value
                }
                $script:Object.'PAYD' = Invoke-Command {
                    $Regex = '[0-9]{1,}'
                    [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[8].innertext -replace '\s',"") , $regex).value
                }
                $script:Object.'PATD' = Invoke-Command {
                    $Regex = '[0-9]{1,}'
                    [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[10].innertext -replace '\s',"") , $regex).value
                }
                $script:Object.'PAINT' = Invoke-Command {
                    $Regex = '[0-9]{1,}'
                    [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[11].innertext -replace '\s',"") , $regex).value
                }
                $script:Object.'RUYD' = Invoke-Command {
                    $Regex = '[0-9]{1,}'
                    [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[15].innertext -replace '\s',"") , $regex).value
                }
                $script:Object.'RUTD' = Invoke-Command {
                    $Regex = '[0-9]{1,}'
                    [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[17].innertext -replace '\s',"") , $regex).value
                }
                $script:Object.'FPTS' = Invoke-Command {
                    $Regex = '[0-9]{1,}'
                    [regex]::Match($($CareerObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
                }
                $CareerArray.Add($($script:Object | Select-Object -ExcludeProperty CareerURL,FantasyURL,'PlayerHomeURL','GameLogURL') )
            }
        }
        return $CareerArray
    }
}

class playerweek_qb : init {
    [string]${Player Name}
    [string]$Week
    [int]$CMPPCT
    [int]$PAYD
    [int]$PATD
    [int]$PAINT
    [int]$RUYD
    [int]$RUTD
    [int]$FPTS

    [array] runrequest(){
        $WeekWebRequest = $(Invoke-WebRequest -UseBasicParsing -Uri $($this.'GameLogURL')).content
        return $this.careerdata($WeekWebRequest)
    }
    [array] careerdata($week) {
        $WeekObject = $($week | ConvertFrom-Html)
        $WeekArray  = [System.Collections.ArrayList]::new()
        for ( $i = 0 ; $i -lt $($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) ; $i ++  ) {
            $script:Object = New-Object playerweek_qb
            $script:Object.'Player Name' =  Invoke-Command {
                $this.'Player Name'
            }
            $script:Object.'Week' =  Invoke-Command {
                $($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) - $i
            }
            $script:Object.'CMPPCT' = Invoke-Command {
                $Regex = '[0-9]{1,}'
                [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[4].innertext -replace '\s',"") , $regex).value
            }
            $script:Object.'PAYD' = Invoke-Command {
                $Regex = '[0-9]{1,}'
                [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[7].innertext -replace '\s',"") , $regex).value
            }
            $script:Object.'PATD' = Invoke-Command {
                $Regex = '[0-9]{1,}'
                [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[9].innertext -replace '\s',"") , $regex).value
            }
            $script:Object.'PAINT' = Invoke-Command {
                $Regex = '[0-9]{1,}'
                [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[10].innertext -replace '\s',"") , $regex).value
            }
            $script:Object.'RUYD' = Invoke-Command {
                $Regex = '[0-9]{1,}'
                [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[15].innertext -replace '\s',"") , $regex).value
            }
            $script:Object.'RUTD' = Invoke-Command {
                $Regex = '[0-9]{1,}'
                [regex]::Match($($WeekObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[18].innertext -replace '\s',"") , $regex).value
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