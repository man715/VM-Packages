$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking


$toolName = 'Neo4jDesktop'
$category = 'Utilities'

$exeUrl = 'https://dist.neo4j.org/neo4j-desktop/win-offline/Neo4j%20Desktop%20Setup%201.5.9.exe'
$exeSha256 = 'F89729DBA9A8AE4694C5F6F4AB0B5B22D86D0A682530BFE123D826BA15F2F162'
$exeName = 'Neo4j Desktop Setup 1.5.9.exe'
$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} "$toolName"
$workingDir = Join-Path "$toolDir" "$exename"

try {

    # Download the exe file
    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        url           = $exeUrl
        checksum      = $exeSha256
        checksumType  = "sha256"
        fileFullPath  = Join-Path "${Env:USERPROFILE}\AppData\Local\Temp" ("$exeName")
    }
    Get-ChocolateyWebFile @packageArgs
    $exePath = $packageArgs.fileFullPath
    VM-Assert-Path $exePath

    # Create a shortcut
    $executablePath = Join-Path "$workingDir" "$toolName.exe" -Resolve
    VM-Install-Shortcut $toolName $category $executablePath -consoleApp $true -executableDir $workingDir
} catch {
    VM-Write-Log-Exception $_
}