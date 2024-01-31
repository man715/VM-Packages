$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Neo4jDesktop'
$category = 'Utilities'

VM-Uninstall $toolName $category
