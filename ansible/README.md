## What is Ansible?
* It is an open source tool that enables automation, configuration, and orchestration of infrastructure.
  * Automating deployment of applications.
  * Managing multiple servers.
  * Making configurations one time.
  * Reducing all around complexity.
## Why, When, and Where
  * It helps in solving the problem of manually updating servers one by one. It allows to control fleet of servers from a
  single control server using SSH.
  * It helps in scaling the identical environments to meet the demands.
  * It can be used as a tools for migrating the applications from integrations, testing, and production in a reliable and
  dependable way.
  * It can be used as a tool for reviewing change logs and rolling back applications if failures occur.

**To avoid the ansible to connect to local machine via ssh while running ansible commands add the 
`ansible_connection=local` parameter to the local host.**

## Ansible config
* Create a config file in the ansible folder with the .cfg extension `ansible.cfg`.
* The config file can include environment-specific parameters to global ansible commands ran.
* Configuration file will be searched in the following order:
  ```
  * ANSIBLE_CONFIG (env variable if set)
  * ansible.cfg (in the current directory)
  * ~/.ansible.cfg (in the home directory)
  * /etc/ansible/ansible.cfg```
  
```INI
---
# ansible.cfg
  
[defaults]
inventory = ./hosts-dev ; This points the inline comment in INI
remote_user = ec2-user ; User you use to ssh into remote servers
private_key_file = ~/.ssh/ansible-course-kp.pem ; key-pair you use to ssh
host_key_checking = False
```
* Once the config file is set with the default inventory file, there is no need to mention the inventory file location
  when we run the ansible commands.
* We can create alias to the hosts by `<alias_name> ansible_host=<ip_address>` in the inventory file.

## Similar Tools

| Ansible                                             | Chef                               | Puppet                             | Salt                               |
|-----------------------------------------------------|------------------------------------|------------------------------------|------------------------------------|
| Only install once on control machine.               | Must be installed on all machines. | Must be installed on all machines. | Must be installed on all machines. |
| Push based.                                         | Pull based.                        | Pull based.                        | Push/Pull based.                   |
| Uses YAML                                           | Uses Puppet DSL                    | Uses Ruby                          | Uses YAML                          |
| Control machine must be Linux/Unix                  | Control machine must be Linux/Unix | Control machine must be Linux/Unix | Control machine must be Linux/Unix |

## Ansible Tasks
* Tasks are a way to run an adhoc commands against inventory file in a one-line single executable.
* Commands consists of ansible command, options, and host_pattern.

## Ansible handlers
* Handlers are used to perform tasks when some changes are made to the existing setup.
* With the variable notify in the tasks section, handlers will perform the tasks given under the notify if changes are
  made to the tasks where notify is mentioned.
* In the below yaml snippet, the handlers Restart apache and Restart memcached will run only when changes are made by
  task "Template configuration file".
* Handlers should be named in order in which they need to be performed.
```yaml
---
tasks:
  - name: Template configuration file
    ansible.builtin.template:
      src: template.j2
      dest: /etc/foo.conf
    notify:
      - Restart apache
      - Restart memcached

handlers:
  - name: Restart memcached
    ansible.builtin.service:
      name: memcached
      state: restarted

  - name: Restart apache
    ansible.builtin.service:
      name: apache
      state: restarted
```
## Ansible conditions (When)
* When you want to perform certain tasks for certain conditions you can use **when** condition in the tasks.
* For example, if you want to update packages only in linux remote servers. You have to perform yum update in linux 
  servers. In this scenario, you can use the below code.

```yaml
---
tasks:
  # Play 2 Get the OS type of the servers
  - name: Get the OS type of the servers
    hosts: webservers:loadbalancers   # performs only on webservers and loadbalancers group
    tasks:
      - name: Get the OS type of the hosts
        shell: uname
        register: uname_output   # Registers the output of the uname command in uname_output variable
      - name: print the uname output
        debug: msg="{{ uname_output.stdout }}"  # prints the stdout key value in the uname_output variable.

# Play 3 Updates the yum packages
  - name: update yum
    hosts: webservers:loadbalancers
    become: 'true'
    tasks:
      - yum:
          name: "*"
          state: latest
        when: uname_output.stdout == "Linux"
      
```

## Variables (vars)
* We can create local variables in the playbook in the below format, and we can use them in the tasks.
* Using variables we can replace the value at several places just by replacing in the variables section.
```yaml
---
vars:
  path_to_app: "/var/www/html"

tasks:
  - name: create index page
    copy:
      src: <local index page location>
      dest: "{{ path_to_app }}"
```
## Ansible Playbooks
* Playbooks are a set of adhoc commands written to yaml format to perform multiple tasks.
* Playbooks can declare configurations and orchestration steps and when and where to run.
* Playbooks gives us the ability to create infrastructure as code and manage it all in source control.
* We can import playbooks into another playbook using the **import_playbook** command.
```yaml
# all-playbooks.yaml
---

  - import_playbook: install_services.yml
  - import_playbook: setup_app.yml
  - import_playbook: setup_lb.yml
```
## Ansible commands
```yaml
List all hosts : ansible --list-hosts all -i <location of inventory file>
List Group of hosts : ansible --list-hosts <group_name>
List particular group of hosts : ansible --list-hosts <grp_1>:<grp_2>
List hosts except some hosts : ansible --list-hosts \!<host_name you don't want>,\!<host_name you don't want>
Pinging all the hosts in the inventory: ansible -m ping all (-m module flag, ping module name, all hosts)
Name of the operating system: ansible -m shell -a "uname" webservers:loadbalancers (-a pass the arguments)
Run the playbook: ansible-playbook <location_of_the_playbook>
List the variables: ansible -m setup all ( specific server)
To check the changes without applying them to the servers: ansible-playbook <playbook_name> --check (--check will run the file in dry run mode)
```

## Ansible Roles
* Roles can be created once, and reused across multiple playbooks and projects, saving time and effort.
* Roles make the complex playbooks into smaller, manageable units, improving readability and maintainability.
* Roles can be shared among others.
* To initialize the role run the command `ansible-galaxy role init <role_location/role_name>`
* When you initialize the role, it will create a folder with the below shown structure.
* Structure of the Roles
```yaml
defaults/main.yml: Defines default variables for the role.
tasks/main.yml: Contains the core tasks of the role.
handlers/main.yml: Includes handlers for tasks, if needed.
vars/main.yml: Holds additional variables specific to the role.
templates/: Stores jinja2 templates for dynamic configuration.
meta/main.yml: Provides metadata about the role.
```
* We can use the roles in our playbook using the **roles** keyword.
```yaml
- hosts: all
  roles:
    - { role: role_name, vars: { var1: "value1" }}
```
## Error handling
* We can handle the errors using the **ignore_errors: yes** or **changed_when: false** key values under the tasks you 
  need to perform the error handling.
* We can set warn argument to no, to disable the warnings.
```yaml
---
- hosts: webservers
  tasks:
    - name: name of the task
      command: service httpd status
      changed_when: false ( it ignores the changes made in the server )
    
    - name: name of the task
      command: /bin/false
      ignore_errors: yes (it ignores the errors)
      args:
        warn: no
  ```
## Tags

* We can assign tags to the tasks in the playbook. Using these tags we can run specific tasks by mentioning tags in the
  command line while running the playbook.
* We can also skip some of the tasks by mentioning skip argument in the command line while running the playbook.
* To run the specific tasks with the tags run the command `ansible-playbook <playbook_name> --tags <tag_name>`
  * To skip the specific tasks with the tags run the command `ansible-playbook <playbook_name> --skip-tags <tag_name>`
```yaml
---
tasks:
  - name: Upload application file
    copy:
      src: ../index.php
      dest: "{{ path_to_the_app }}"
    tags: upload
```

## Ansible Vault

* It is a way to keep sensitive information in encrypted files, rather than plain text, in playbooks.
* To create a vault run the command `ansible-vault create secret-variables.yml`. After running the command, you are 
  asked to set the password in the command prompt. 
* To access the vault, we need to provide password while running the playbook as shown 
  `ansible-playbook <playbook_name> --ask-vault-pass`
* To edit the vault, run the command `ansible-vault edit <vault_file>` and enter the password.
* To refer the variables stored in the vault in the playbook. We need to mention the location of the vault in the
  playbook under the key **vars_files** as shown below.
```yaml
---
  - hosts: webservers
    become: true
    vars:
      path_to_app: "/var/www/html"
    vars_files:
      - <location to the vault file>
  - tasks:
      - name: Use secret password
        debug: msg="{{ Secret_password_key }}""
```
* While running the above playbook, we need to mention the argument --ask-vault-pass and should enter the password.

## Ansible Prompts

* It is used to get the input from the user, whether he wants to perform the task or not.
* Based on the input it runs the tasks.
* We can set the prompts using the **vars_prompt** section in the playbook.
```yaml
---
  vars_prompt:
    - name: "upload_var"
      prompt: "Upload index.php file?"  (prompt this when you run the playbook)
  tasks:
    - name: Upload the application file
      copy:
        src: ../index.php
        dest: "{{ path_to_app }}"
      when: upload_var == 'yes' (Runs this task only when the user gives the input to the upload_var prompt as yes)
      tags: upload
```