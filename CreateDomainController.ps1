<#Connect to your Azure account #>
Connect-AzAccount;

<# Set local variables #>
$prefix = "yourprefix";
$rg = "$prefix`-rg";
$location = "EastUS";
$dc = "$prefix`-dc";
$vnet = "$prefix`-vn";
$subnet = "$prefix`-sn";
$sgname = "$prefix`-sg";
$ipname = "$prefix`-ip";
$domainname = "$prefix.local";

<# Create a new resource group #>
New-AzResourceGroup -Name $rg -Location $location;

<# Set variables for the domain controller creation #>
$vmsplat = @{
    ResourceGroupName = $rg
    Name = $dc
    Location = $location
    VirtualNetworkName = $vnet
    SubnetName = $subnet
    SecurityGroupName = $sgname
    PublicIpAddressName = $ipname
    OpenPorts = 80,3389
}

Write-Output "Creating VM";
<# Create domain controller #>
New-AzVm @vmsplat;

<# Build command to add Active Directory Domain Services (ADDS) to the domain controller #>
$dcscript = "Add-WindowsFeature -Name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools"

Write-Output "Add ADDS";
<# Run the command to add ADDS #>
Invoke-AzVMRunCommand -ResourceGroupName $rg -VMName $dc -CommandId 'RunPowerShellScript' -ScriptString $dcscript; 

Write-Output "Restart VM after ADDS install";
<# Restart the domain controller after adding ADDS #>
Restart-AzVM -ResourceGroupName $rg -Name $dc;

<# Prompt for the SafeModeAdministratorPassword #>
$dnspassword = Read-Host -AsSecureString;

Write-Output "Promote VM to domain controller";
<# Execute InstallDNS.ps1 against the VM to promote it to a domain controller #>
$installdns = Invoke-AzVMRunCommand -ResourceGroupName $rg -VMName $dc -CommandId 'RunPowerShellScript' -ScriptPath C:\temp\InstallDNS.ps1; 

Write-Output "Restart VM after DC promotion";
<# Restart the domain controller #>
Restart-AzVM -ResourceGroupName $rg -Name $dc;

Write-Output "Update DNS IP for your VNET";
<# Update the virtual network with the IP address for your DNS server #>
$vNetsettings = Get-AzVirtualNetwork -ResourceGroupName $rg -name $vNet
$vm = Get-AzVm -ResourceGroupName $rg -Name $dc;
$vmnic = ($vm.NetworkProfile.NetworkInterfaces.id).Split('/')[-1]
$vmnicinfo = Get-AzNetworkInterface -Name $vmnic
$dnsip = $vmnicinfo.IpConfigurations.PrivateIpAddress;
$newObject = New-Object -type PSObject -Property @{"DnsServers" = $dnsip}
$vNetSettings.DhcpOptions = $newObject
$vNetSettings | Set-AzVirtualNetwork

