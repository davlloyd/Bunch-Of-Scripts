Connect-VIServer vcenter

foreach($esxhost in Get-VMHost)
{
	$hostcon = Connect-VIServer -Server $esxhost.NetworkInfo.ConsoleNic. -User 'root' -Password 'B3ach8um'
	$excli = Get-EsxCli -Server 
	$esxcli.storage.nmp.satp.rule.list()
}
