$ouname = 'Clusters';
$ou = New-ADOrganizationalUnit -Name $ouname -PassThru;
$clustername = "fbgdeplag-cl";

$oupath = $ou.DistinguishedName;
$adpath = "AD:\$($oupath)"
$computer = New-ADComputer -Name $clustername -SAMAccountName $clustername -Path $oupath -Enabled $false -PassThru;
$sid = New-Object System.Security.Principal.SecurityIdentifier $computer.SID;
$sid;

$acl = Get-Acl -Path $adpath
$objectguid = New-Object Guid bf967a86-0de6-11d0-a285-00aa003049e2;
$ace1 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $sid,"CreateChild","Allow",$objectguid

$acl.AddAccessRule($ace1);

Set-Acl -aclobject $acl $adpath;