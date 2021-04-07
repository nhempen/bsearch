$password=$args[0]
$tgtfile=$args[1]
$hashtype=$args[2]
$stringAsStream = [System.IO.MemoryStream]::new()
$writer = [System.IO.StreamWriter]::new($stringAsStream)
$writer.write($password)
$writer.Flush()
$stringAsStream.Position = 0
$HASHED=(Get-FileHash -InputStream $stringAsStream -Algorithm $hashtype).Hash
write-host "------------------------------------------"
write-host "Searching $tgtfile for $hashtype : $HASHED"
$results=(Select-String -Path $tgtfile -Pattern $HASHED -List)
if ($null -eq $results)
{
    write-host "GOOD: Password $hashtype hash not found in ${tgtfile}."
} else {
    $results=($results.Line.split(":")[1])
    write-host "BAD: Password $hashtype hash was found and seen $results time(s) in source breaches."
}