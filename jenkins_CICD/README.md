# Jenkins

[//]: # ([Jenkins Pipeline using docker and kubernetes]&#40;https://github.com/iam-veeramalla/Jenkins-Zero-To-Hero/tree/main/python-jenkins-argocd-k8s&#41;)

* Jenkins is an automation platform that allows you to build, test, and deploy the pipelines.
* It can be used to automate any task.

## Jenkins Infrastructure
* It has master and slave servers known as **Agents**.
* **Master Server** controls pipelines and schedules builds.
* **Slave Server / Agents** performs the builds.

## Process

* When a user commits the code into source control repo, the commit trigger pipeline.
* The master selects the agent based on the configured labels, and the agent runs the builds.

## Types of Agents

* **Permanent Agents**: Dedicated servers for running jobs.
* **Cloud Agents**: Dynamic servers that spin up on demand. **Some of the cloud agents are Docker, Kubernetes.**

## Build Types
* **Free style** : 
  * Simplest method to create a build.
  * Feels like Shell scripting.
* **Pipelines** : 
  * Use the Groovy syntax.
  * Breaks into stages. **(Clone -> Build -> Test -> Package -> Deploy)**

