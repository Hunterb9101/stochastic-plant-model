Set-Variable -Name dt -Value (Get-Date -Format MMddyyyy)
Compress-Archive -Path $PSScriptRoot -DestinationPath $PSScriptRoot\model_$dt.zip
echo $dt