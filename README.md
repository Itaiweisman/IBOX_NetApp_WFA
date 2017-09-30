# Overview

WFA is a  management software by NetApp , that provides automation and orchestration. WFA enables workflow automation on a service oriented manner.
Workflows could be tasks such as creating/deleting/expanding/mapping volumes, NFS Shares and so on or combination of those - for example - defining a tier of volumes that requires replication to secondary site, we can define a single process (workflow) that create a volume, map it to a host and create replication links to it in one step. workflows could be scheduled, executed manually, executed using API request etc. WFA can create reports on workflows status etc. WFA provided with no license agreement

# Commands
commands on WFA set of instructions to perform an action. command is consist of a code section (written on either PowerShell or Perl) ,  parameter definition (WFA knows to read the code and find what are the parameters that should be passed to the code), common settings (timeout, version etc) and DB interactions (WFA has a MySQL database that is can cache the managed assets configuration.
passwords can be set to be hided while typed. 
Note - for passing password securely, use the WFAInputPassword cmdlet provided by NetApp on the WFAWrapper module. see more details (https://community.netapp.com/t5/OnCommand-Storage-Management-Software-Discussions/Usage-of-WFAInputPassword/td-p/103789), and on the sample code above

## Forms 
Attriubtes should be provided on the request form. example below 
![WorkflowExamle](/screenshots/WF-user-form.png)

with this module all commands are written in PowerShell.

![WorkflowExamle](/screenshots/command-infinidat.png)
## Commands in used with InfiniBox Module

* Cinder related
	* CreateCinderVol - Creates an openstack volume, using Cinder.
	__Receives - Cinder host name/IP, Volume name, size__
	* GetToken - Get a token for Cinder authentication from keystone
	__Receives - Keystone host name/IP, User, password (encrypted)__
* CreateIboxVol - Creates an InfiniBox Volume, using InfiniBox API. 
__Receives - InfiniBox name/IP, Volume name, Pool, size, provision type (tuple of Thick / Thin)__ 
* ExtendVol - Extend an InfiniBox Volume
__Receives - InfiniBox name/IP, InfiniBox credentials, Volume Name, New Size__ 
* MapToHost - Map an InfiniBox Volume to host
__Receives - InfiniBox name/IP, InfiniBox credentials, Volume Name, Host Name__

# Workflows
workflows are combinations of commands and filters. workflows includes the order of commands to run, dependencies, parameter mapping (parameters which could be common, or passed between one command to another, for instance with a workflow that has two commands: first creates a volume, and second map it volume to a host, a common parameter would be the volume name)
 Workflows also includes form definition - how user input is expected: what data is mandatory and what is optional, default values, fixed values (for instance - when creating an InfiniBox volume - provision type should be chosen out of Thin and Thick only)
![WorkflowExamle](/screenshots/WF-Infinidat.png)
# The InfiniBox Package
 Written a package that includes workflows to create and map volumes, and have OpenStack Cinder integration .
 this could be imported by going to design->packs -> import and provide the dar file

 

