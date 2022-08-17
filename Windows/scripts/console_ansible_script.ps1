[CmdletBinding()]
param (
    $application_name,
    $environment,
    $server_group,
    $target_path, 
    $artifact_name 
)

Write-Host "$application_name $environment,$server_group,$target_path" 
$env:Agent_ReleaseDirectory
$env:Build_Artifactstagingdirectory
$env:System_DefaultWorkingDirectory
$env:System_ArtifactsDirectory

$source_path = "$env:Build_Artifactstagingdirectory\$artifact_name\"
$source_path = $source_path.replace('\a\', '\') 
$source_path = $source_path | ConvertTo-Json
$source_path 
$application_name = $application_name| ConvertTo-Json
$environment = $environment | ConvertTo-Json
$server_group = $server_group | ConvertTo-Json
$target_path = $target_path  | ConvertTo-Json

