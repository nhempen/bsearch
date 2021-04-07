#Will search a password hash file downloaded from https://haveibeenpwned.com/Passwords
param([switch] $help, $pass, $tfile)
$usage1="This will search the hash from https://haveibeenpwned.com/Passwords. If you have not already done so download the hash file."
$usage2="Two arguments required: -pass <password to search> -tfile <path to hash file> "
if ($help -Or $null -eq $pass -Or $null -eq $tfile) 
{ 
    Write-Host "$usage1"
    Write-Host "$usage2"
    exit
}
if (-Not (Test-Path -Path $tfile -PathType Leaf))
{
    Write-Host "Error: File $tfile doesn't exist."
    exit
}
$hashtype="SHA1"
$stringAsStream = [System.IO.MemoryStream]::new()
$writer = [System.IO.StreamWriter]::new($stringAsStream)
$writer.write($pass)
$writer.Flush()
$stringAsStream.Position = 0
$HASHED=(Get-FileHash -InputStream $stringAsStream -Algorithm $hashtype).Hash
write-host "------------------------------------------"
write-host "Searching $tfile for $hashtype : $HASHED"
$results=(Select-String -Path $tfile -Pattern $HASHED -List)
if ($null -eq $results)
{
    write-host "GOOD: $hashtype hash not found in ${tfile}."
} else {
    $results=($results.Line.split(":")[1])
    write-host "BAD: Password $hashtype hash was found and seen $results time(s) in source breaches."
}