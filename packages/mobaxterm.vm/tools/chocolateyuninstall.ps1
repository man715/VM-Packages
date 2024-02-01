$ErrorActionPreference = 'Continue'

$toolName = "Neo4j Desktop"
$category = "Utilities"

Import-Module vm.common -Force -DisableNameChecking

VM-Uninstall-With-Uninstaller "Neo4j Desktop" "EXE" "/S"

VM-Remove-Tool-Shortcut $toolName $category
