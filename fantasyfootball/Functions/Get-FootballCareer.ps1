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
function Get-FootballCareer
{
    Param
    (
        [string]$Html
    )
    Begin {
        class QB_Career{
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
        class RB_Career{
            [string]${Player Name}
            [string]$Season
            [int]$RUATT
            [int]$RUYD
            [int]$RUTD
            [int]$RECPT
            [int]$REYD
            [int]$RETD
            [int]$FPTS
        }
        class WR_Career{
            [string]${Player Name}
            [string]$Season
            [int]$TAR
            [int]$RECPT
            [int]$REYD
            [int]$RETD
            [int]$REFD
            [int]$REAVG
            [int]$FPTS
        }
        class TE_Career{
            [string]${Player Name}
            [string]$Season
            [int]$TAR
            [int]$RECPT
            [int]$REYD
            [int]$RETD
            [int]$REFD
            [int]$REAVG
            [int]$FPTS
        }
        $HtmlObject = $Html | ConvertFrom-Html
        [System.Collections.ArrayList]$Career_Array = @()
        # For counting rows
        # $HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes.count
    } 
    Process {
        switch ( $Position ) {
            'QB' {
                for ( $i = 0 ; $i -lt $($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes.count ) ; $i ++  ) {
                    $YearCheck = $($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[0].innertext -replace '\s',"") 
                    if ( $YearCheck -match '[0-9]{4}' -and $YearCheck -ne '2022' ) {
                        $Object = New-Object QB_Career
                        $Object.'Player Name' =  Invoke-Command {
                            $PlayersName
                        }
                        $Object.'Season' = Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[0].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'CMPPCT' = Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[6].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'PAYD' = Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[8].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'PATD' = Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[10].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'PAINT' = Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[11].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'RUYD' = Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[15].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'RUTD' = Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[17].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'FPTS' = Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
                        }
                        $Career_Array.Add($Object) | Out-Null
                    }
                }
            }
            'RB' {
                for ( $i = 0 ; $i -lt $($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes.count ) ; $i ++  ) {
                    $YearCheck = $($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[0].innertext -replace '\s',"") 
                    if ( $YearCheck -match '[0-9]{4}' -and $YearCheck -ne '2022' ) {
                        $Object = New-Object RB_Career
                        $Object.'Player Name' =  Invoke-Command {
                            $PlayersName
                        }
                        $Object.'Season' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[0].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'RUATT' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[5].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'RUYD' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[6].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'RUTD' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[8].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'RECPT' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[12].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'REYD' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[13].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'RETD' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[15].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'FPTS' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
                        }
                        $Career_Array.Add($Object) | Out-Null
                    }
                }
            }
            'WR' {
                for ( $i = 0 ; $i -lt $($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes.count ) ; $i ++  ) {
                    $YearCheck = $($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[0].innertext -replace '\s',"") 
                    if ( $YearCheck -match '[0-9]{4}' -and $YearCheck -ne '2022' ) {
                        $Object = New-Object WR_Career
                        $Object.'Player Name' =  Invoke-Command {
                            $PlayersName
                        }
                        $Object.'Season' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[0].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'TAR' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[5].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'RECPT' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[6].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'REYD' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[7].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'RETD' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[9].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'REFD' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[11].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'REAVG' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[8].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'FPTS' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
                        }
                        $Career_Array.Add($Object) | Out-Null
                    }
                }
            }
            'TE' {
                for ( $i = 0 ; $i -lt $($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes.count ) ; $i ++  ) {
                    $YearCheck = $($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[0].innertext -replace '\s',"") 
                    if ( $YearCheck -match '[0-9]{4}' -and $YearCheck -ne '2022' ) {
                        $Object = New-Object TE_Career
                        $Object.'Player Name' =  Invoke-Command {
                            $PlayersName
                        }
                        $Object.'Season' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[0].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'TAR' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[5].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'RECPT' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[6].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'REYD' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[7].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'RETD' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[9].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'REFD' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[11].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'REAVG' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[8].innertext -replace '\s',"") , $regex).value
                        }
                        $Object.'FPTS' =  Invoke-Command {
                            $Regex = '[0-9]{1,}'
                            [regex]::Match($($HtmlObject.SelectNodes('//table')[0].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
                        }
                        $Career_Array.Add($Object) | Out-Null
                    }
                }
            }
        }
    }
    End {
        $Career_Array | Export-Csv -Path C:\Users\Kenne\Downloads\TEST\CBSFootball$($Position)_Career.csv -Append
    }
}