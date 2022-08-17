
# Azure DevOps Pipeline Introduction 
Azure DevOps provides developer services for allowing teams to plan work, collaborate on code development, and build and deploy applications. Azure DevOps supports a collaborative culture and set of processes that bring together developers, project managers, and contributors to develop software.

# What is a CI/CD Pipeline?
A CI/CD pipeline is used to automate the process of continuous integration and continuous deployment. The pipeline facilitates the software delivery process via stages like Build, Test, Merge, and Deploy.
In simple words, a pipeline may sound like an overhead, but it isn’t. Instead, it’s a runnable specification of steps that reduce developers’ manual work by delivering a new version of a software productively and saves time.

# Reale Application's depolyment flow:

1. **So the deployment types will be:**
    1. deploy_type: "WEB" à build (depends on Build_type) start stop iis web site and pool + copy binaries
    2. deploy_type: " CONSOLE " à build (depends on Build_type) copy binaries
    3. deploy_type: "SQL à deploy SQL – server files

2. **Windows Deployment Flow steps:**

    1. The development team has committed their modifications to the main code.
    2. CI for pipeline triggers (See the Create Pipeline section below.)    
    3. The pipeline will run the phases once it is triggered. (using the azure common templet flow that is already in place)
    4. pipeline executes various stages
        > 1. Build&Publish (binary generation)
        > 2. Transfer to DES or TST
        > 3. Deploy to Pre-Production and Production When creating a tag(See the Create tag section below.)
    5. Pipeline common templates.
        > 1. Example pipeline common for all applications [Example ]( https://dev.azure.com/realeitesorg/rg.ites.devops.templates/_git/rg.ites.es.devops.templates?path=/Windows/azure-pipelines-windows-main.yml)
        > 2. Stages of the pipeline workflow [workflow ](https://dev.azure.com/realeitesorg/rg.ites.devops.templates/_git/rg.ites.es.devops.templates?path=/Windows/pipeline-workflow.yaml)
        > 3. [Build & Publish ](https://dev.azure.com/realeitesorg/rg.ites.devops.templates/_git/rg.ites.es.devops.templates?path=/Windows/buildAndPublish.yaml)
        > 4. [release or deploy ](https://dev.azure.com/realeitesorg/rg.ites.devops.templates/_git/rg.ites.es.devops.templates?path=/Windows/release.yaml)
        > 5. Example of Deploying Two Applications at the Same Time [Example ](https://dev.azure.com/realeitesorg/rg.ites.devops.templates/_git/rg.ites.es.devops.templates?path=/Windows/two-apps-pipeline-example.yaml)
        > 6. Deploy 2 Application workflow [workflow](https://dev.azure.com/realeitesorg/rg.ites.devops.templates/_git/rg.ites.es.devops.templates?path=/Windows/two-apps-workflow.yaml)
        > 7. Build & Publish Two Applications [Build&Publish](https://dev.azure.com/realeitesorg/rg.ites.devops.templates/_git/rg.ites.es.devops.templates?path=/Windows/two-apps-workflow.yaml)
        > 8. Powershell scripts for executing Ansible tasks [powershell scripts](https://dev.azure.com/realeitesorg/rg.ites.devops.templates/_git/rg.ites.es.devops.templates?path=/Windows/scripts/ansible_script.ps1)



 3.  **azure-pipelines-example.yaml**   

          trigger:
          branches:
            include:
              - main
          tags:
            include:
              - "*"
          resources:
          repositories:
            - repository: templates
              type: git
              name: rg.ites.devops.templates/rg.ites.es.devops.templates
              ref: main

          stages:
          - template: Windows/pipeline-workflow.yaml@templates   #Templet for workflow WEB, CONSOLE, SQL
            parameters:
              solution: "Main/NSI/RSG.Mon.BizTalkService/RSG.Mon.BizTalkService.sln" 
              application_pool: "RSG.Mon.BizTalkService"
              application_name: "RSG.Mon.BizTalkService"
              website_name: "RSG.Mon.BizTalkService"
              server_group: "SPA_BIZ"
              binarys_Path: "Main/NSI/RSG.Mon.BizTalkService/RSG.Mon.BizTalkService.Api"
              target_path: "C:\\Reale\\RSG.Mon.BizTalkService"
              environment: "DES"             #environment depends  DES, TST
              deploy_type: "Web"             #deploy depends  Web, Console, Sql
              build_type: "MsBuild"          #build depends  MsBuild, Core5            



4.  **two-apps-pipeline-example.yaml**

          trigger:
            branches:
              include:
                - main
            tags:
              include:
                - "*"
          resources:
            repositories:
              - repository: templates
                type: git
                name: rg.ites.devops.templates/rg.ites.es.devops.templates
                ref: main
          stages:
            - template: Windows/two-apps-workflow.yaml@templates    #Templet for workflow WEB, CONSOLE, SQL
              parameters:
              #Application 1 Parameters
              solution_1: "Main/NSI/RSG.DeploySQL/RSG.DeploySQL.sln" 
              application_pool_1: "RSG.Mon.BizTalkService"
              application_name_1: "RSG.Mon.BizTalkService"
              website_name_1: "RSG.Mon.BizTalkService"
              server_group_1: "SPA_BIZ"
              binarys_Path_1: "Main/NSI/RSG.DeploySQL"
              target_path_1: "C:\\Reale\\RSG.Mon.BizTalkService"
              deploy_type_1: "Sql"               #deploy depends  Web, Console, Sql
              build_type_1: "MsBuild"            #build depends  MsBuild, Core5              
              environment: "DES"                 #environment depends  DES, TST 

              #Application 2 Parameters
              solution_2: "Main/NSI/RSG.Mon.BizTalkService/RSG.Mon.BizTalkService.sln" 
              application_pool_2: "RSG.Mon.BizTalkService"
              application_name_2: "RSG.Mon.BizTalkService"
              website_name_2: "RSG.Mon.BizTalkService"
              server_group_2: "SPA_BIZ"
              binarys_Path_2: "Main/NSI/RSG.Mon.BizTalkService/RSG.Mon.BizTalkService.Api"
              target_path_2: "C:\\Reale\\RSG.Mon.BizTalkService"
              deploy_type_2: "Web"               #deploy depends  Web, Console, Sql
              build_type_2: "MsBuild"            #build depends  MsBuild, Core5              
     


5. **Build&Publish (binary generation):** 

    1. **Build Depends on deploy_type**
       
      
        | Environment | deploy_type | build_type |
        | ----------- | ----------- | ---------- |
        | DES  | Web  | MsBuild|
        | DES  | Web  |   Core5|      
        | DES  | Console | MsBuild|
        | DES  | Console| Core5|
        | DES |  Sql    | MsBuild|

        > 1. The build type and deploy type parameters must be supplied [Example](https://dev.azure.com/realeitesorg/rg.ites.devops.templates/_git/rg.ites.es.devops.templates?path=/Windows/azure-pipelines-windows-main.yml)
             deploy_type: "Web"             #deploy depends  Web, Console, Sql
             build_type: "MsBuild"          #build depends  MsBuild, Core5          
        > 2. The default parameter for Build & Publish is 'Release', which is dependent on the Build Configuration supplied (have a look at the yaml file [buildAndPublish.yaml](https://dev.azure.com/realeitesorg/rg.ites.devops.templates/_git/rg.ites.es.devops.templates?path=/Windows/buildAndPublish.yaml)
             - name: BuildConfiguration
                default: 'Release'
             - name: buildPlatform
                default: 'Any CPU' 

             EX:
              task: MSBuild@1
              displayName: "Build Web MsBuil"
              inputs:
                solution: ${{ parameters.solution }}
                platform: '${{ parameters.buildPlatform }}'
                configuration: '${{ parameters.BuildConfiguration }}'
                msbuildArguments: '/p:DeployOnBuild=true /p:WebPublishMethod=Package /p:PackageAsSingleFile=true /p:SkipInvalidConfigurations=true /p:PackageLocation="$(build.artifactstagingdirectory)\\"'

              task: DotNetCoreCLI@2
              displayName: Build Web Core5
              inputs:
                projects: ${{ parameters.solution }}
                arguments: '--configuration ${{ parameters.BuildConfiguration }}'


     2. **Publish Depends on deploy_type** 
         Publish depends on the configuration

            Ex:
              task: PublishPipelineArtifact@1
              displayName: PublishPipelineArtifact Web Core5
              inputs:
                targetPath: '$(build.artifactstagingdirectory)'
                artifactName: ${{ parameters.artifact_name }}
    
    2. **Stage to DES or TST** 
     > 1.  When the build and publish stages are completed, the next step is to deoloy to DES or TST. It is dependent on the initial parameter supply.
     > 2.  At this point, the binary files are being downloaded and the Ansible call script is being executed.
     
5. **Create Azure DevOps CI/CD Pipeline:**
    1. Create pipeline using existing yaml code templet's.
    2. Create ![picture 1](images/CreatePipeline.png)  

    3. Select Azure Repo ![picture 2](images/CreatePipeline_2.png)  

    4. Select Projec Repo![picture 3](images/CreatePipeline_3.png)

    5. Select start pipeline yaml ![picture 4](images/Pipeline_confiure.png)
  
    6. Select Existing yaml template code https://dev.azure.com/realeitesorg/rg.ites.devops.templates/_git/rg.ites.es.devops.templates?path=/Windows/azure-pipelines-windows-main.yml![picture 5](images/Pipeline_yml.png)  
    
    7. Change the parameters depends on you project solution and project parameters.

    8. Save and run the pipeline ![picture 6](images/Save_and_run_pipeline.png)  
    
    9. Displaying the Runing pipeline stages ![picture 7](images/Runing_pipeline.png) 

7. **Create a tag**
    1. When you add a tag for the most recent build in the repository, the pre-prod and prod stages are triggered.
    2. There are two ways to make a tag 
       > 1. In the Comman line teriminal, create a tag. 
       > 2. In Azure Devops Level, create a tag.

8. **Checks and approvals**
    1. Approvals can be added at the environment level.
       > 1.  when you run the existing templates pipeline example it will create environment automate.
         >1. 
    2. Approvals for the second stage of production 
       > 1. agent approval 
           ![picture 1](images/Environment.PNG)  
           ![picture 2](images/Environment_prod.PNG)  
       > 2. environment approvals



  
#Ansible Job

 **Steps:**

  1. Build in azure pipelines

  2. Ansible Task: Make a backup from Target server To Target\temporal\backup\application_name
  
  3. Ansible:Stop website: Ex: RSG.Mon.BizTalkService
  
  4. Ansible:Copy binaries to target_path
  
  5. Ansible:Start website: RSG.Mon.BizTalkService
  
  6. If error copy backup from DESCASBIZW01.reale.net\temporal\backup\RSG.Mon.BizTalkService
  
  7. Get logs in azure pipelines

 **Status: Can be any of the following**

  1. Pending - The inventory sync has been created, but not queued or started yet. Any job, not just inventory source syncs, will stay in pending until it’s actually ready to be run by the system. Reasons for inventory source syncs not being ready include dependencies that are currently running (all dependencies must be completed before the next step can execute), or there is not enough capacity to run in the locations it is configured to.

  2. Waiting - The inventory sync is in the queue waiting to be executed.

  3. Running - The inventory sync is currently in progress.

  4. Successful - The inventory sync job succeeded.

  5. Failed - The inventory sync job failed.


***
# DEVELOPMENT FLOW

![picture 1](images/Reale_Workflow.png)  
         





