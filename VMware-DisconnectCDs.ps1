connect-viserver '10.63.249.13' -User 'administrator' -Password 'B3ach8um'
foreach ($vm in Get-VM){
	$net = Get-NetworkAdapter -VM $vm
	if(!$net.ConnectionState.Connected){
		Set-NetworkAdapter -NetworkAdapter $net 
		Write-Host "Network adapter not connected: " $vm.Name
	}
	$cd = Get-CDDrive -VM $vm
	if ($cd.ConnectionState.Connected -or $cd.ConnectionState.StartConnected){
		Write-Host "Resetting DVD setup for : " $vm.Name
		#Set-CDDrive -CD $cd -NoMedia -Confirm:$false
	}
}	
