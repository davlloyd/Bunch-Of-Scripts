$ucsip = "10.63.250.35"
$uscaccount = "admin"
$ucspassword = "B3ach8um" | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($uscaccount, $ucspassword) 
Connect-Ucs -Name $ucsip -Credential $cred

$servicename = "mhvbronze11.vce.asc"
$templatename = "HyperV-BFS-VNX"
$bladememmax = 129000
$bladememmin = 65000
$blademodel = "N20-B6620-1"
$assigned = $false

$template = Get-UcsServiceprofile -Type initial-template -Name $templatename
if($template -ne $null){
	$serviceprofile = Get-UcsServiceProfile -Name $servicename
	if($serviceprofile -eq $null){
		Add-UcsServiceProfile -Name $servicename -SrcTemplName $templatename
		foreach($blade in Get-UcsBlade -Association none){
			if($blade.Model -eq $blademodel){
				Get-UcsServiceProfile -Name $servicename | Associate-UcsServiceProfile -Blade $blade -Force
				$assigned = $true
				break
			}
		}
		if(!$assigned){
			Write-Host "Association incomplete"
		}
	}else{
		Write-Host "Service profile already exists"
	}
}else{
	Write-Host "Template does not exist"
}
Disconnect-Ucs
