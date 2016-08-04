$ucsip = "10.63.250.35"
$uscaccount = "admin"
$ucspassword = "B3ach8um" | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($uscaccount, $ucspassword) 
Connect-Ucs -Name $ucsip -Credential $cred

$servicename = "mhvbronze11.vce.asc"

$serviceprofile = Get-UcsServiceProfile -Name $servicename
if($serviceprofile -ne $null){
	Add-UcsLsbootLan -BootPolicy -ModifyPresent -Order 1
	boot-policy-default
}else{
	Write-Host "Service profile does not exist"
}
Disconnect-Ucs
