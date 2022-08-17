[CmdletBinding()]
param (
    $application_pool, 
    $application_name,
    $website_name,
    $environment,
    $server_group,
    $target_path,
    $artifact_name 
)

Write-Host "application_pool:$application_pool, application_name:$application_name, website_name:$website_name,environment:$environment,server_group:$server_group,target_path:$target_path" 
$env:Agent_ReleaseDirectory
$env:Build_Artifactstagingdirectory
$env:System_DefaultWorkingDirectory
$env:System_ArtifactsDirectory

#$source_path = (Get-Content -Path "$env:Build_Artifactstagingdirectory\a\mydir\temp.txt" -TotalCount 3)[-1] + "\PackageTmp\" 
#$source_path = $source_path.substring(15) 
#$source_path = $source_path.replace('\s\', '\a\s\') 
$source_path = "$env:Build_Artifactstagingdirectory\$artifact_name\"
$source_path = $source_path.replace('\a\', '\') 
$source_path = $source_path | ConvertTo-Json
$source_path

$application_pool = $application_pool | ConvertTo-Json
$application_name = $application_name| ConvertTo-Json
$website_name = $website_name | ConvertTo-Json
$environment = $environment | ConvertTo-Json
$server_group = $server_group | ConvertTo-Json
$target_path = $target_path  | ConvertTo-Json
$source_path

