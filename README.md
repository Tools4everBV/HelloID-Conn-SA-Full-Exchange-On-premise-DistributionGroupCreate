<!-- Description -->
## Description
This HelloID Service Automation Delegated Form provides Exchange On-Premise Distribution Group functionality. The following options are available:
 1. Give a name for a new distribution group to create
 2. If the name already exists a iteration is added or you can adjust the name
 3. Confirm the names generated
 4. Create the distribution group
 
<!-- TABLE OF CONTENTS -->
## Table of Contents
* [Description](#description)
* [All-in-one PowerShell setup script](#all-in-one-powershell-setup-script)
  * [Getting started](#getting-started)
* [Post-setup configuration](#post-setup-configuration)
* [Manual resources](#manual-resources)


## All-in-one PowerShell setup script
The PowerShell script "createform.ps1" contains a complete PowerShell script using the HelloID API to create the complete Form including user defined variables, tasks and data sources.

 _Please note that this script asumes none of the required resources do exists within HelloID. The script does not contain versioning or source control_


### Getting started
Please follow the documentation steps on [HelloID Docs](https://docs.helloid.com/hc/en-us/articles/360017556559-Service-automation-GitHub-resources) in order to setup and run the All-in one Powershell Script in your own environment.

 
## Post-setup configuration
After the all-in-one PowerShell script has run and created all the required resources. The following items need to be configured according to your own environment
 1. Update the following [user defined variables](https://docs.helloid.com/hc/en-us/articles/360014169933-How-to-Create-and-Manage-User-Defined-Variables)
<table>
  <tr><td><strong>Variable name</strong></td><td><strong>Example value</strong></td><td><strong>Description</strong></td></tr>
  <tr><td>ADdistributionGroupsOU</td><td>[{ "OU": "OU=Distribution Groups,OU=Groups,DC=domain,DC=local"}]</td><td>Active Directory OU where the corresponding AD group is created</td></tr>
  <tr><td>ExchangeConnectionUri</td><td>http://exchangeserver/powershell</td><td>Exchangeserver where distribution is created</td></tr>
  <tr><td>ExchangeAdminUsername</td><td>domain/user</td><td>Exchangeserver admin account</td></tr>
  <tr><td>ExchangeAdminPassword</td><td>********</td><td>Exchangeserver admin password</td></tr>
</table>

## Manual resources
This Delegated Form uses the following resources in order to run

### Powershell data source 'Exchange-create-check-names-distributiongroup'
This Powershell data source runs an Active Directory query to verify the name of the distribution group is not already present.

### Delegated form task 'Exchange-on-premise-create-distribution-group'
This delegated form task will create the distribution group in Exchange with a corresponding AD group.

# HelloID Docs
The official HelloID documentation can be found at: https://docs.helloid.com/
