$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $category = 'Office'
  $toolName = '7z'
  # $url = 'https://sourceforge.net/projects/sevenzip/files/7-Zip/15.05/7z1505.exe/download'
  # $checksum = 'fa99d29283d9a6c501b70d2755cd06cf5bc3dd8e48acc73926b6e0f389885120'
  $url = 'https://www.7-zip.org/a/7z2301-x64.exe'
  checksum = '9B6682255BED2E415BFA2EF75E7E0888158D1AAF79370DEFAA2E2A5F2B003A59'
  # $url64 = 'https://sourceforge.net/projects/sevenzip/files/7-Zip/15.05/7z1505-x64.exe/download'
  # $checksum64 = '6abaf04e44c87bd109df7485eb67a2d69a2e3e6e6deb9df59e5e707176c69449'
  $url = 'https://www.7-zip.org/a/7z2301-x64.exe'
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
