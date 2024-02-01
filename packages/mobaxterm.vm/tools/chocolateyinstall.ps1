$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MobaXterm'
$category = 'Utilities'

try {
    $zipUrl = 'https://download.mobatek.net/2362023122033030/MobaXterm_Installer_v23.6.zip'
    $zipSha256 = '6770BB1538143F530441E9DE17583D99E5CB529AE54340F84DE1F313F4081927'
    $installerName = Split-Path -Path $zipUrl -Leaf

    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        url           = $zipUrl
        checksum      = $zipSha256
        checksumType  = "sha256"
        fileFullPath  = Join-Path ${Env:TEMP} $installerName
        argumentList  = '/qn'
    }

    $filePath = Get-ChocolateyWebFile @packageArgs

    Expand-Archive $filepath ${ENV:TEMP}

    $filePath = Join-Path ${ENV:TEMP} "\MobaXterm_installer_23.6\MobaXterm_installer_23.6.msi"

    $executablePath = $(Join-Path ${env:ProgramFiles(x86)} "Mobatek\MobaXterm\MobaXterm.exe")

    VM-Assert-Path $packageArgs.fileFullPath

    $rc = (Start-Process -FilePath $filePath -ArgumentList $packageArgs.argumentList -PassThru -Wait).ExitCode
    if ($rc -eq 1) {
        throw "MobaXterm returned a failure exit code ($rc) for: ${Env:ChocolateyPackageName}"
    } else {
        VM-Assert-Path $executablePath
    }
    VM-Install-Shortcut $toolName $category $executablePath
} catch {
    VM-Write-Log-Exception $_
}

