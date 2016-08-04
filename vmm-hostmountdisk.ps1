$vmHost = Get-SCVMHost -ComputerName "mhvbronze07"
$logicalUnits = @()
$logicalUnits += Get-SCStorageLogicalUnit -Name "mhvbronze07desktoptemplate"
Register-SCStorageLogicalUnit -StorageLogicalUnit $logicalUnits -VMHost $vmHost -JobGroup "9a63e1ef-6b01-443a-94e0-0c0860bc8a7f"
$lun = Get-SCStorageLogicalUnit -Name "mhvbronze07desktoptemplate"
Mount-SCStorageDisk -MasterBootRecord -QuickFormat -VolumeLabel "w7desktoptemplate" -StorageLogicalUnit $lun -JobGroup "9a63e1ef-6b01-443a-94e0-0c0860bc8a7f" -MountPoint "C:\Library\DesktopWin7Std"

Set-SCVMHost -VMHost $vmHost -JobGroup "9a63e1ef-6b01-443a-94e0-0c0860bc8a7f" -RunAsynchronously
