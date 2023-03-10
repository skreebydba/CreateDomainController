# CreateDomainController
This project contains two scripts:
- CreateDomainController.ps1
- InstallDNS.ps1

CreateDomainController does the majority of the work, performing the following steps:
- Creates a new resource group in Azure
- Creates a Windows VM in that resource group
- Installs Active Directory Domain Services on the VM
- Restarts the VM
- Promotes the VM to a domain controller
- Restarts the VM
- Updates the DNS IP for the VM vnet

InstallDNS is called from CreateDomainController to pass the secure SafeModeAdministratorPassword.

Once the VM is built, you need to connect to the new domain controller and perform the following steps:
- Create your cluster computer object in Active Directory
- Disable the new computer object
- Grant Create Computer Object permissions to the new computer object

I am working on incorporating these three steps into the PowerShell script and will update the project when complete.
