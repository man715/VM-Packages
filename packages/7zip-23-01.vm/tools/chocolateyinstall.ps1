$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = '7z'
  $url = 'https://www.7-zip.org/a/7z2301.exe'
  $checksum = '9B6682255BED2E415BFA2EF75E7E0888158D1AAF79370DEFAA2E2A5F2B003A59'
  $url64 = 'https://www.7-zip.org/a/7z2301-x64.exe'
  $checksum64 = '26CB6E9F56333682122FAFE79DBCDFD51E9F47CC7217DCCD29AC6FC33B5598CD'

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    fileType      = 'EXE'
    url           = $url
    url64bit      = $url64
    checksumType  = 'sha256'
    checksum      = $checksum
    checksum64    = $checksum64
    silentArgs    = '/S'
  }
  Install-ChocolateyPackage @packageArgs

  $toolDir = Join-Path ${Env:ProgramFiles} '7-Zip' -Resolve
  $7zExecutablePath = Join-Path $toolDir "$toolName.exe" -Resolve
  Install-BinFile -Name $toolName -Path $7zExecutablePath

  # Add 7z unzip with password "infected" to the right menu for the most common extensions.
  # 7z can unzip other file extensions like .docx but these don't likely use the infected password.
  $extensions = @(".7z", ".bzip2", ".gzip", ".tar", ".wim", ".xz", ".txz", ".zip", ".rar")
  foreach ($extension in $extensions) {
    VM-Add-To-Right-Click-Menu $toolName 'unzip "infected"' "`"$7zExecutablePath`" e -pinfected `"%1`"" "$executablePath" -extension $extension
  }
} catch {
  VM-Write-Log-Exception $_
}
