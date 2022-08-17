[CmdletBinding()]
param (
    $environment,
    $realeites_deployment__sql_files,
    $artifact_name 
)

Write-Host "$environment,$realeites_deployment__sql_files"

$env:Agent_ReleaseDirectory
$env:Build_Artifactstagingdirectory
$env:System_DefaultWorkingDirectory
$env:System_ArtifactsDirectory

$source_path = "$env:Build_Artifactstagingdirectory\$artifact_name\"
$source_path = $source_path.replace('\a\', '\') 
$source_path
$realeites_deployment__sql_files = (Get-ChildItem -Path $source_path -Include *.sql* -File -Recurse -Name)
$sql_files = $realeites_deployment__sql_files | ForEach-Object {"$source_path\$PSItem"}
$realeites_deployment__sql_files = $sql_files -join ','
Write-Host "$realeites_deployment__sql_files,$environment"

$realeites_deployment__environment = $environment | ConvertTo-Json
$realeites_deployment__sql_files = $realeites_deployment__sql_files | ConvertTo-Json

Write-Host "$realeites_deployment__sql_files,$environment"
 