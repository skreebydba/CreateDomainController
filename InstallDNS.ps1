$dnspassword = "JuanS0t022WN";
$securepassword = $dnspassword | ConvertTo-SecureString -AsPlainText -Force;
Install-ADDSForest -DomainName fbgdeplag.local -SafeModeAdministratorPassword $securepassword -InstallDNS -Force