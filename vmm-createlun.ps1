# Set Parameters
$poolname = "FAST-Pool-01"
$lunsize = 46080
$lunname = "mhvbronze10pstestlun3"
$luntype = "Thin"
$hostname = "mhvbronze10"
$jobgroup = [Guid]::NewGuid().ToString()
$volumelabel = "vmvolume2"
$mountpoint = "F:\"

# Create LUN
$pool = Get-SCStoragePool -Name $poolname
$newlun = New-SCStorageLogicalUnit -StoragePool $pool -DiskSizeMB $lunsize -Name $lunname -Description "" -ProvisioningType $luntype

#Allocate LUN to Host group
$hostgroup = Get-SCVMHostGroup -Name "HyperV"
Set-SCStorageLogicalUnit -StorageLogicalUnit $newlun -VMHostGroup $hostgroup

#Present LUN to host
$vmhost = Get-SCVMHost -ComputerName $hostname
Register-SCStorageLogicalUnit -StorageLogicalUnit $newlun -VMHost $vmhost -JobGroup $jobgroup
Mount-SCStorageDisk -MasterBootRecord -QuickFormat -VolumeLabel $volumelabel -StorageLogicalUnit $newlun -JobGroup $jobgroup -MountPoint $mountpoint

#Execute job
Set-SCVMHost -VMHost $vmHost -JobGroup $jobgroup -RunAsynchronously
