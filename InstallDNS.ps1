$dnspassword = "Y0ur$tr0ngP@$$w0rd";
 $domainname = "yourdomainname.local"
$securepassword = $dnspassword | ConvertTo-SecureString -AsPlainText -Force;
Install-ADDSForest -DomainName $domainname -SafeModeAdministratorPassword $securepassword -InstallDNS -Force
