($array = Get-SCStorageArray | where {$_.Name -eq "FAS2040-SCVMM"}) | fl Name, TotalCapacity, IsCloneCapable, IsSnapshotCapable, IsSanTransferCapable, StoragePools
($pools = $array.StoragePools | where {$_.IsManaged -eq $True}) | fl Name, TotalManagedSpace, Classification, StorageLogicalUnits

$luns = @()
foreach ($pool in $pools) {
    $assignedLuns = $pool.StorageLogicalUnits | where {$_.IsAssigned -eq $True -and $_.HostDisks.Count -ne 0} 
    $luns += $assignedLuns
}

$vmHosts = @()
$disks = @()
foreach($lun in $luns) {
    $vmHost = $lun.HostDisks[0].VMHost
    if ($vmHosts -notcontains $vmHost) {
        $vmHosts += $vmHost
    }
    
    foreach($disk in $lun.HostDisks) {
      if ($disks -notcontains $disk) {
          $disks += $disk
      }
    }
}

$vms = @()

foreach($vmHost in $vmHosts) {
 if($vmHost -ne $null) {
     $vms += Get-VM -VMHost $vmHost
 }
}
$vmWithArray = @()
foreach($vm in $vms) {
    foreach($passthroughDisk in $vm.PassThroughDisks) {
        if ($disks -contains $passthroughDisk) {
            $vmWithArray += $vm
        }
    }
    
    foreach($vdd in $vm.VirtualDiskDrives | where {$_.IsVHD}) {
        $vhd = $vdd.VirtualHardDisk
        
        if ($vhd.HostVolume -ne $null -and $vhd.HostVolume.StorageDisk -ne $null) {
            if (($disks -contains $vhd.HostVolume.StorageDisk) -and
                ($vmWithArray -notcontains $vm)) {
                $vmWithArray += $vm
            }
        }
    }
}
$vmWithArray | fl Name, VMHost
