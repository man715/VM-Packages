$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

VM-Uninstall-With-Uninstaller "Neo4j Desktop" "EXE" "/S"

