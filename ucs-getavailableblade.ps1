$ucsOutput = "unassigned"
try
{
	$ucspassword = "B3ach8um" | ConvertTo-SecureString -AsPlainText -Force
	$cred = New-Object System.Management.Automation.PSCredential("admin", $ucspassword) 
	Connect-Ucs -Name "10.63.250.35" -Credential $cred

	foreach($blade in Get-UcsBlade -Association none){
		if($blade.Model -eq "N20-B6620-1"){
			Get-UcsServiceProfile -Name "test" | Associate-UcsServiceProfile -Blade $blade -Force
			$ucsOutput = "assigned"
			break
		}
	}
	Disconnect-Ucs
}
catch
{
}

