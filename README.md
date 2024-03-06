# DevOps

## What is DevOps?
   * DevOps is the combination of practices and tools designed to increase the ability of an organization to deliver
   applications or services faster by ensuring that it has proper automation, quality, continuous monitoring and testing.

## Why DevOps?
   * It helps in reducing the work load and make the process of deploying the code into production simple and efficient.

## What is Software Development Lifecycle (SDLC)?
   * It is a set of standard that is followed in an organization to design, develop, and test.
   * The end goal of SDLC is to deliver high quality application or service.
   * Basic steps involved in SDLC are **Planning, Defining, Designing, Building, Testing, and Deploying.**

## AWS services for DevOps
   * **EC2** : It is a remote machine that you can configure based on your requirements. 
   * **VPC** : It is a virtual private cloud, where we can store and secure our EC2 instances and databases using 
                Security Groups, Subnets, Inbound/Outbound rules, CIDR.
   * **EBS** : It is block storage services known as volumes, which are attachable/ detachable to the ec2 instances. We
               can take a snapshot of the volumes and store them in s3 location and delete the volume to save the cost.
   * **S3**  : It is an object storage service where we can store the log files or any other kind of files, images. 
               There are  many types of S3, we have to choose them based on our requirement. The objects stored in S3 
               are encrypted in transit by default.
   * **IAM** : It is the service used to create a role, user, group and allocate the required permissions based on their
               roles, user requirements, or group requirements. The admin or root user can track the log data who accessed
               the services using IAM.
   * **CloudWatch** : It is a monitoring service that looks after the services like EC2, storage services and notifies
                      the respective user using the lambda function about their properties or permissions or storage
                      based on the requirement.
   * **Lambda** : It is a serverless event-driven function, which is triggered by other service and sends the output to
                  service or performs some tasks mentioned in the lambda function. It can auto-scale based on the load.
   * **Cloud Build Services** : CI/CD services 
     * **AWS code pipeline**
     * **AWS code Build**
     * **Aws code Deploy**
   * **AWS Configuration** : We can configure our requirements and create the tasks to perform when the services that
                             does not meet the requirement using AWS configuration.
   * **Billing and Costing** : Tracking the cost of services that are used by the organization. we can sort out the
                               billing anc costs of the services based on the projects or teams using the tags.
   * **AWS KMS** : It is a key management services that is used to store or rotate the keys or certificates required to encrypt or utilize the
                   services.
   * **CloudTrail** : It stores the API logs of the services.
   * **AWS EKS** : It is an Elastic Kubernetes Service managed by AWS.
   * **Fargate & ECS** : These are Elastic container services owned by AWS.
   * **ELK Stalk (Elasticsearch)** : It is the service where we can perform operations to search or go through the
                                     logs to find some important information.
## Difference between AWS CLI, Boto3, CFT, and Terraform.
   ### Scripting Languages   
   * AWS CLI : 
     * It is time efficient and easy to create the resources or lists the resources with single line of command.
     * We use bash scripting to run more than one command.

   * Boto3 :
     * It is used when we need to interact with AWS resources and get the list of objects or buckets to use them 
     in further coding tasks.
     * We use python scripting to perform the tasks.
     *  It is used to perform serverless programs.

   ### Template Languages (Infrastructure as a Code)
    
   * Cloud Formation Template (CFT) :
     * We can create the resources, roles, users, and can attach the policies by uploading a json or YAML file in
     the CFT console.

   * Terraform :
     * To use terraform, we have to download the terraform, set the configurations.
     * We can write the template using **"HashiCorp Configuration Language (HCL)"**.

## Difference between Ansible and Terraform (Ansible: refer ./scripts/ansible/README.md; Terraform: refer ./scripts/terraform/README.md)

   * **Ansible** is used to manage the configuration of servers and application deployment. It is good at provisioning and
    configuring individual servers and nodes, automating tasks, and managing software installations. Workflows are defined
    using playbooks.
   * **Terraform** is used for infrastructure provisioning and orchestration. It excels at defining and managing the 
    infrastructure components such as VM's, networks, and storage across various cloud providers and on-premises 
    environments. It is defined using **.tf files.** It uses **API as Code.**
   * **Ansible Roles** is used to group tasks into logical units, enhancing code reusability and make the playbook more
    readable and maintainable.
     * We can create role from scratch or use the existing roles in the **ansible galaxy community repo.**
     * We can use the roles in playbooks, using roles keyword, specifying the role name and desired options.
## Difference between boto3 client and boto3 resource.
   ### Boto3.client
   * It offers lower level AWS service access.
   * Boto3 generates the client from a JSON service definition file.
   * All AWS service operations are supported by clients.
   * Boto3 client gives the response in JSON format, where the user needs to parse through it.
   * User is responsible for the pagination.
     
   ### Boto3.resource
   * It offers higher level object-oriented service access.
   * Boto3 generates the resource from a JSON resource definition file.
   * It does not provide 100% API coverage of AWS services.
   * It does the pagination for user.
   * For new services, boto3 resource is not supported.

## Difference between Lambda (serverless) and EC2 instance (server).

   * Lambda functions are Event-driven functions i.e., it runs the script inside it only when 
     the event assigned is happened.
   * Lambda function will automatically scale up when the request is raised by the user and scale down when the assigned
     task is completed.
   * EC2 instance will stay active until you terminate it, and you have to take care about the scaling up and down.
   * For EC2 instances user will get an ip address and can manage the security and other settings.
   * In case of Lambda, user cannot know where the function is hosted or any details like ip addresses.
   * Best use case of lambda function for devops engineer are cost optimization, Security.
   * In terms of security, we can check for any resources that are restricted or the organization does not want to use
     by creating a function to check every day.
   * For the Lambda you pay-per-use, where for EC2 you pay-as-you-go

## Introduction to Serverless Computing

Today, we're going to embark on an exciting journey into the world of serverless computing and explore AWS Lambda,
a powerful service offered by Amazon Web Services.

So, what exactly is "serverless computing"? Don't worry; it's not about eliminating servers altogether. 
Instead, serverless computing is a cloud computing execution model where you, as a developer, don't have to manage 
servers directly. You focus solely on writing and deploying your code, while the cloud provider takes care of all 
the underlying infrastructure.

## Understanding AWS Lambda

In this serverless landscape, AWS Lambda shines as a leading service. AWS Lambda is a compute service that lets you run 
your code in response to events without the need to provision or manage servers. It automatically scales your 
applications based on incoming requests, so you don't have to worry about capacity planning or dealing with server 
maintenance.

## How Lambda Functions Fit into the Serverless World

At the heart of AWS Lambda are "Lambda functions." These are individual units of code that perform specific tasks. 
Think of them as small, single-purpose applications that run independently.

Here's how Lambda functions fit into the serverless world:

1. **Event-Driven Execution**: Lambda functions are triggered by events. An event could be anything, like a new file 
being uploaded to Amazon S3, a request hitting an API, or a specific time on the clock. When an event occurs, Lambda 
executes the corresponding function.

2. **No Server Management**: As a developer, you don't need to worry about managing servers. AWS handles everything 
behind the scenes. You just upload your code, configure the trigger, and Lambda takes care of the rest.

3. **Automatic Scaling**: Whether you have one user or one million users, Lambda scales automatically. Each function 
instance runs independently, ensuring that your application can handle any level of incoming traffic without manual 
intervention.

4. **Pay-per-Use**: One of the most attractive features of serverless computing is cost efficiency. With Lambda, 
you pay only for the compute time your code consumes. When your code isn't running, you're not charged.

5. **Supported Languages**: Lambda supports multiple programming languages like Node.js, Python, Java, Go, and more. 
You can choose the language you are comfortable with or that best fits your application's needs.

## Real-World Use Cases

Now, let's explore some real-world use cases to better understand how AWS Lambda can be applied:

1. **Automated Image Processing**: Imagine you have a photo-sharing app, and users upload images every day. 
You can use Lambda to automatically resize or compress these images as soon as they are uploaded to S3.

2. **Chatbots and Virtual Assistants**: Build interactive chatbots or voice-controlled virtual assistants using Lambda. 
These assistants can perform tasks like answering questions, fetching data, or even controlling smart home devices.

3. **Scheduled Data Backups**: Use Lambda to create scheduled tasks for backing up data from one storage location to 
another, ensuring data resilience and disaster recovery.

4. **Real-Time Analytics**: Lambda can process streaming data from IoT devices, social media, or other sources, 
allowing you to perform real-time analytics and gain insights instantly.

5. **API Backends**: Develop scalable API backends for web and mobile applications using Lambda. It automatically 
handles the incoming API requests and executes the corresponding functions.

## Commonly used Shell commands

* ls, cd, mkdir, rm -rf, mv, chmod, df, ps -ef, grep, pipe(|), wc -l, which, whereis. 
* trap: to block the usage of any command.  **trap "echo don't use the ctrl+c" SIGINT**
* awk: prints the required information.   **awk -F "{delimiter}" '{print $2}'** 
* find: finds the files in the given location. **find {location} -name {name of the file}**
* curl v/s wget: **curl gets the output of the given URL where wget downloads the information from the given URL.**
* set -x : To debug the script.
* set -e : Interrupts when error occur.
* set -o pipefail : Interrupts when pipeline commands fail.
* Crontab: performs the tasks in the executable file at the allocated time provided by the user.
  * crontab -u : specify the name of the user whose crontab is to be tweaked.
  * crontab -l : lists the crontabs of the user.
  * crontab -e : edits the crontabs.
  * crontab -r : removes the crontabs.
* Difference between soft link and hard link.
  * Hardlink
    * Hardlink will create a copy of the file, and we can retrieve it from the original file if it gets deletes.
    * In hardlink, changes made in each file is reflected into another file.
    * We cannot create hardlinks to the directories, and they can only point to files with in the same filesystem.
  * Softlink
    * Softlink is a separate file containing the path to the original file.
    * It acts as a shortcut and changes will not reflect.
    * Softlink can point to file across different filesystems and even link to directories.
* traceroute : provides the network utility information

## Difference between Centralized and Distributed version control systems
  * In centralized version control systems, developers have to push their code to a centralized location to share their
    code, if that system went down their communication and code will be lost.
  * In distributed version control systems, developers can create as many as duplicated locations of centralized code
    and push their code into it. This is known as forking the application.

## Git Branching Strategy
  * Master: It is the main branch that active development goes on.
  * Features: It is the branch where the developers develop and test their code and merges into master if everything
              went good.
  * Release: It is the branch where the application is released to customers when the developers think the code still now
             is ready to release and starts to work on feature branches for further implementation.
  * Hot-fix: It is the branch where the prod issues or issues that should be solved immediately will be done here and
             pushed back into both master and release branch when the issue is solved.

## Git Commands
  * ### To create Repository: 
    * **git init**                         - initializes git repository.
    * **git add <file_name>**              - adds the file_name file to the git.
    * **git commit -m "message you want"** - commits the added file to the local git repository.
    * **git push**                         - pushes the local repository code to the remote repository.
    * **git remote add <name> <url>**      - adds the remote repo to local repo at the given url with the given name.
  * **git diff** : shows the differences made in the project files.
  * **git log** : shows the log of the commits.
  * **git status** : shows the status of the files.
  * **git checkout <branch_name>** : switch to the branch_name branch from your current branch.
  * **git reset --hard <commit ID>** : Resets the project files to the given commit stage.
  * **git merge <branch_name>** : Merges the branch_name branch into current branch.
  * **git clone <url>** : Downloads the existing repository into your local location.
  * **git pull** : fetches the changes from remote repo and merges into current branch.
  * **git fetch** : fetches remote changes but does not merge into current branch. Gets all the commit information and
                    tracking information. Updates the local tracing branches to reflect the remote state. Used to check
                    the updates made in remote by other developers.
  * **git stash** : Temporarily saves the uncommitted changes in a stash and removes them from working directory.
                    Used when we need to revert to previous state without losing uncommitted changes.
                    We can list or drop using **git stash list or git stash drop**.
  * ### Merging the branches:
    * **git cherry-pick <commit_id>** : Adds the changes in the commit with commit_id from another branch to current 
                                        working branch. It is easy when we need to merge single commit.
    * **git merge <branch_name>** : merges the changes of branch_name branch into the current working branch on the top.
    * **git rebase <branch_name>** : merges the changes of branch_name branch into the current working branch at the
                                      point where you created the branch_name branch.

## Difference between CLONE and FORK
  * Clone will download the whole remote repo into your local system, where fork will copy the remote repo.
  * Using fork you can get the changes made to the remote repo using pull, where in clone you have to clone the repo
    again if you want the changes.

## Configuration Management with Ansible
  * Manages the configuration of multiple servers at one location.
  * **Puppet, Chef, Ansible, Salt** are some of the tools used for configuration management.
  * **Puppet** : 
    * It is a pull model. 
    * It uses master slave architecture.
    * We have to write in puppet language.
  * **Ansible** 
    * It is a push model. We can push the modifications from a single file to all the servers.
    * It uses agentless architecture.
    * Anisble can update the inventory with new servers with the use of **Dynamic Inventory.**
    * We can write our own modules using python.
    * It supports both Linux and Windows. For linux it uses SSH protocol and for windows it uses WinRM.
    * We can write ansible playbook in YAML language.
    * It supports all the cloud providers, it just needs the public ip address of the instance that has SSH enabled.
  * **Ansible adhoc commands** are for running one or two commands and **ansible playbook** is for running multiple
    commands.
  * We can group servers in the ansible by mentioning group names in square brackets in the inventory file.
  * Sample ansible command to create a txt file in multiple servers is 
    *  **ansible -i inventory all "shell" -a "touch sample.txt"** : This command creates the sample.txt file in all the
        servers mentioned in the inventory file using the shell command touch.
    * **ansible -i inventory webservers "shell" -a "touch sample.txt"** : This command creates the sample.txt file in
      servers under the group webservers in the inventory file.
  * **Ansible Playbook**: Using this playbook, we are going to install nginx and start the nginx.
    * create the YAML file
    * Start the file with **---** to indicate that it is a YAML file.
    * We can write multiple playbooks in single YAML file by separating them with the details list shown below.
    * Write the details about the playbook:
    ```yaml
    ---
      - name: Install and Start nginx   
        hosts: all or Inventory_group_name #[Takes from the inventory file] 
        become: ""{{ user_name | default('root') }}" # [uses username if provided or root by default]
        # true [Grants admin access] 
        # false [user is not specified and runs with the permissions who run the playbook]
        tasks:
          - name: Install nginx 
            shell: apt install nginx #[We can directly use the shell command]
            yum: #[we can use the apt module for ubuntu or yum for linux]
              name: nginx 
              state: present 
          - name: Start nginx 
            shell: systemctl start nginx 
            service: 
              name: nginx 
              state: started
      - name: Second playbook #[Second playbook]
        hosts: all or Inventory_group_name
        tasks:  
    ```
    * To execute the playbook **ansible-playbook -i inventory playbook.yml**
