## Script to set the default NMP policy type and then update the existing LUNs
## with the defined policy

# Set the preferred path by setting the variable $psppolicynameto the required setting, then run the script
# and enter target details, cluster name can be wildcarded (e.g. clus*)



## Set policy name to set value to (RoundRobin / MostRecentlyUsed / Fixed)
$psppolicyname = "RoundRobin"

## Policy setting value (Options: VMW_PSP_MRU, VMW_PSP_RR, VMW_PSP_FIXED)
$pspPolicy = "VMW_PSP_RR"
switch($psppolicyname)
{
	"RoundRobin" { $pspPolicy = "VMW_PSP_RR" }
	"MostRecentlyUsed" { $pspPolicy = "VMW_PSP_MRU" }
	"Fixed" { $pspPolicy = "VMW_PSP_FIXED" }
}

Write-Host "Host NMP Policy Change Script/n/n"
$targetvCenter = Read-Host "Enter Target vCenter Name"
$targetCluster = Read-Host "Enter Target Cluster Name"

## Array Provider type, defaulted to VNX/Clariion
$arrayType = "VMW_SATP_CX"

$targetGood=$false
while(!$targetGood){ 
	$targetType = Read-Host "Select Target Array Type (1=VNX/Clariion, 2- VNX/Clariion with ALUA, 3=VMAX)"
	if(($targetType -eq "1") -or ($targetType -eq "2") -or ($targetType -eq "3")){
		switch($targetType)
		{
			"1" {$arrayType = "VMW_SATP_CX"}
			"2" {$arrayType = "VMW_SATP_ALUA_CX"}
			"3" {$arrayType = "VMW_SATP_SYMM"}
		}
		$targetGood=$true
	}
}

## Connect to vCenter
Read-Host "Hit <Enter> to specify the credentials for vCenter"
Connect-VIServer -Server $targetvCenter -Force -ErrorAction Stop 

$cluster = Get-Cluster -Name $targetCluster

## Enumerate through each of the hosts in the cluster selected
foreach ($targethost in (Get-Cluster $targetCluster | Get-VMHost)){
    ## Get a reference to the CLI
    $esxCli = Get-EsxCli -VMHost $targethost
    
	## First Step is to change the default policy for the array type going forwrd
    $esxCli.storage.nmp.satp.list() | %{
        $currentSATPState = $_
        ## Check if the current path is the selected array type and is not the selected path policy type already
        if (($currentSATPState.DefaultPSP -ne $pspPolicy) -and ($arrayType -eq $currentSATPState.Name)) {
            ## list values that are supporter
            Write-Host "Host: " $targethost.Name "/n"
			$currentSATPState
            ## Change policy to desired value
            $esxCli.storage.nmp.satp.set($null,$pspPolicy,$currentSATPState.Name)
        }
    }
	
	##Second step is chnge the policy for existing LUNS
	$luns = Get-ScsiLun -VmHost $targethost -LunType disk
	foreach($ds in $targethost.ExtensionData.Config.StorageDevice.MultipathInfo.Lun){
		## Check multipath setting for disk device and ensure array type
		if(($ds.StorageArrayTypePolicy.Policy -eq $arrayType) -and ($ds.Policy.Policy -ne $pspPolicy)){
			foreach($lun in $luns){
				## Get Scsi Disk object
				if(([VMware.Vim.HostScsiDisk]$lun.ExtensionData).Uuid -eq $ds.Id){
					write-host "Updating device policy: " $lun.canonicalName
					## Update policy
					Set-ScsiLun -ScsiLun $lun -MultipathPolicy $psppolicyname
				}
			}
		}
	}
}
