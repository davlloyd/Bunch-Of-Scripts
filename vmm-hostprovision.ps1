
$bmcaddress = "10.63.250.21"
$ip = "10.63.250.40"
$mac = "00-25-B5-00-00-0B"
$hostname = "mhvbronze10"
$hostprofilename = "Cisco UCS M71KR-E"
$hostgroupname = "HyperV"
$runaccountname = "Cisco UCSM"

$runasaccount = Get-SCRunAsAccount -Name $runaccountname
$physicaldetails = Find-SCComputer -BMCAddress $bmcaddress -BMCRunAsAccount $RunAsAccount -BMCProtocol "IPMI"

if ($physicaldetails -ne $null){
	$hostgroup = Get-SCVMHostGroup -Name $hostgroupname
	$hostprofile = Get-SCVMHostProfile -Name $hostprofilename
	New-SCVMHost -ComputerName $hostname -VMHostProfile $HostProfile -VMHostGroup $HostGroup -BMCAddress $bmcaddress -BMCRunAsAccount $RunAsAccount -RunAsynchronously -BMCProtocol "IPMI" -BMCPort "623" -ManagementAdapterMACAddress $mac -SMBiosGuid $physicaldetails.SMBiosGUID -LogicalNetwork "Host Network" -Subnet "10.63.250.0/26" -BypassADMachineAccountCheck
}

