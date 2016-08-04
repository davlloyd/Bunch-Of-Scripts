$ucsip = "10.63.250.35"
$uscaccount = "admin"
$ucspassword = "B3ach8um" | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($uscaccount, $ucspassword) 
Connect-Ucs -Name $ucsip -Credential $cred

$servicename = "mhvbronze10.vce.asc"



$serviceprofile = Get-UcsServiceProfile -Name $servicename
if($serviceprofile -ne $null){
	$blade = Get-UcsBlade -Dn $serviceprofile.pndn
	$mgmtdn = $blade.Dn + "/mgmt/ipv4-pooled-addr"
	$mgmtip = Get-UcsManagedObject -Dn $mgmtdn | select Addr
	$wwn = Get-UcsManagedObject -Dn "org-root/ls-$servicename/fc-vhba-a" | select nodeaddr
	$vhbaawwpn = Get-UcsManagedObject -Dn "org-root/ls-$servicename/fc-vhba-a" | select addr
	$vhbabwwpn = Get-UcsManagedObject -Dn "org-root/ls-$servicename/fc-vhba-b" | select addr
	$vnic0mac = Get-UcsManagedObject -Dn "org-root/ls-$servicename/ether-eth0" | select addr
	$vnic1mac = Get-UcsManagedObject -Dn "org-root/ls-$servicename/ether-eth1" | select addr
	
	
	
}else{
	Write-Host "Service profile does not exist"
}
Disconnect-Ucs
