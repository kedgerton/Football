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
function Get-FootballWeek
{
    Param
    (
        [string]$Html
    )
    Begin {
        class QB_WEEK{
            [string]${Player Name}
            [string]$Week
            [int]$CMPPCT
            [int]$PAYD
            [int]$PATD
            [int]$PAINT
            [int]$RUYD
            [int]$RUTD
            [int]$FPTS
        }
        class RB_WEEK{
            [string]${Player Name}
            [string]$Week
            [int]$RUATT
            [int]$RUYD
            [int]$RUTD
            [int]$RECPT
            [int]$REYD
            [int]$RETD
            [int]$FPTS
        }
        class WR_WEEK{
            [string]${Player Name}
            [string]$Week
            [int]$TAR
            [int]$RECPT
            [int]$REYD
            [int]$RETD
            [int]$REAVG
            [int]$FPTS
        }
        class TE_WEEK{
            [string]${Player Name}
            [string]$Week
            [int]$TAR
            [int]$RECPT
            [int]$REYD
            [int]$RETD
            [int]$REAVG
            [int]$FPTS
        }
        $HtmlObject = $Html | ConvertFrom-Html
        [System.Collections.ArrayList]$Week_Array = @()
        # gonna need to define between 1 table and 2
    }
    Process {
        switch ( $Position ) {
            'QB' {
                for ( $i = 0 ; $i -lt $($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) ; $i ++  ) {
                    $Object = New-Object QB_Week
                    $Object.'Player Name' =  Invoke-Command {
                        $PlayersName
                    }
                    $Object.'Week' =  Invoke-Command {
                        $($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) - $i
                    }
                    $Object.'CMPPCT' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[4].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'PAYD' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[7].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'PATD' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[9].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'PAINT' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[10].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'RUYD' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[15].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'RUTD' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[18].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'FPTS' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
                    }
                    $Week_Array.Add($Object) | Out-Null
                }
            }
            'RB' {
                for ( $i = 0 ; $i -lt $($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) ; $i ++  ) {
                    $Object = New-Object RB_Week
                    $Object.'Player Name' =  Invoke-Command {
                        $PlayersName
                    }
                    $Object.'Week' =  Invoke-Command {
                        $($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) - $i
                    }
                    $Object.'RUATT' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[4].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'RUYD' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[5].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'RUTD' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[8].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'RECPT' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[11].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'REYD' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[12].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'RETD' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[14].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'FPTS' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
                    }
                    $Week_Array.Add($Object) | Out-Null
                }
            }
            'WR' {
                for ( $i = 0 ; $i -lt $($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) ; $i ++  ) {
                    $Object = New-Object WR_Week
                    $Object.'Player Name' =  Invoke-Command {
                        $PlayersName
                    }
                    $Object.'Week' =  Invoke-Command {
                        $($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) - $i
                    }
                    $Object.'TAR' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'RECPT' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'REYD' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[5].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'RETD' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[7].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'REAVG' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[4].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'FPTS' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
                    }
                    $Week_Array.Add($Object) | Out-Null
                }
            }
            'TE' {
                for ( $i = 0 ; $i -lt $($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) ; $i ++  ) {
                    $Object = New-Object TE_Week
                    $Object.'Player Name' =  Invoke-Command {
                        $PlayersName
                    }
                    $Object.'Week' =  Invoke-Command {
                        $($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes.count ) - $i
                    }
                    $Object.'TAR' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'RECPT' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'REYD' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[5].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'RETD' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[7].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'REAVG' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[4].innertext -replace '\s',"") , $regex).value
                    }
                    $Object.'FPTS' = Invoke-Command {
                        $Regex = '[0-9]{1,}'
                        [regex]::Match($($HtmlObject.SelectNodes('//table')[-1].childnodes[2].childnodes[$i].childnodes[3].innertext -replace '\s',"") , $regex).value
                    }
                    $Week_Array.Add($Object) | Out-Null
                }
            }
        }
    }
    End {
        $Week_Array | Export-Csv -Path C:\Users\Kenne\Downloads\TEST\CBSFootball$($Position)_Week.csv -Append
    }
}