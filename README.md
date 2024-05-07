# CreateDomainController
This project contains two scripts:
- CreateDomainController.ps1
- InstallDNS.ps1
- PrestageCluster.ps1

CreateDomainController does the majority of the work, performing the following steps:
- Creates a new resource group in Azure
- Creates a Windows VM in that resource group
- Installs Active Directory Domain Services on the VM
- Restarts the VM
- Promotes the VM to a domain controller
- Restarts the VM
- Updates the DNS IP for the VM vnet
- Create your cluster computer object in Active Directory
- Disable the new computer object
- Grant Create Computer Object permissions to the new computer object

InstallDNS is called from CreateDomainController to pass the secure SafeModeAdministratorPassword.
PrestageCluster is called from CreateDomainController to create the cluster name object in active directory and grant permissions.

