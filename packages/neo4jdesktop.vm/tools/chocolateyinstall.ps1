$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Neo4j Desktop'
$category = 'Utilities'

try {
    $exeUrl = 'https://dist.neo4j.org/neo4j-desktop/win-offline/Neo4j%20Desktop%20Setup%201.5.9.exe'
    $exeSha256 = 'F89729DBA9A8AE4694C5F6F4AB0B5B22D86D0A682530BFE123D826BA15F2F162'
    $installerName = Split-Path -Path $exeUrl -Leaf

    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        url           = $exeUrl
        checksum      = $exeSha256
        checksumType  = "sha256"
        fileFullPath  = Join-Path ${Env:TEMP} $installerName
        argumentList  = '/S /allusers'
    }
    $filePath = Get-ChocolateyWebFile @packageArgs
    $executablePath = $(Join-Path ${env:ProgramFiles} "Neo4j Desktop\Neo4j Desktop.exe")

    VM-Assert-Path $packageArgs.fileFullPath

    $rc = (Start-Process -FilePath $filePath -ArgumentList $packageArgs.argumentList -PassThru -Wait).ExitCode
    if ($rc -eq 1) {
        throw "Neo4j Desktop returned a failure exit code ($rc) for: ${Env:ChocolateyPackageName}"
    } else {
        VM-Assert-Path $executablePath
    }
    VM-Install-Shortcut $toolName $category $executablePath
} catch {
    VM-Write-Log-Exception $_
}

