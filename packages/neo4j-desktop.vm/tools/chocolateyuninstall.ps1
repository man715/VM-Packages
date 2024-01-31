$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Neo4j Desktop'
$category = 'Utilities'

VM-Uninstall $toolName $category
