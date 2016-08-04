$ucsip = "10.63.250.35"
$uscaccount = "admin"
$ucspassword = "B3ach8um" | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($uscaccount, $ucspassword) 
Connect-Ucs -Name $ucsip -Credential $cred

$servicename = "mhvbronze11.vce.asc"
$bootpolicyname = "SAN_BOOT_HA_FA"
$bootpolicyname = "PXE-BFS-VNX-SPA"


$serviceprofile = Get-UcsServiceProfile -Name $servicename
if($serviceprofile -ne $null){
	$bootpolicy = Get-UcsBootPolicy -Name $bootpolicyname
	if($bootpolicy -ne $null){
		Set-UcsServiceProfile -ServiceProfile $serviceprofile -BootPolicyName "PXEBoot" -Force
	}else{
		Write-Host "Boot policy not found"
	}
}else{
	Write-Host "Service profile does not exist"
}
Disconnect-Ucs
