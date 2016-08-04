# ------------------------------------------------------------------------------
# Create Virtual Machine Wizard Script
# ------------------------------------------------------------------------------
# Script generated on Sunday, 15 July 2012 3:10:00 AM by Virtual Machine Manager
# 
# For additional help on cmdlet usage, type get-help <cmdlet name>
# ------------------------------------------------------------------------------


New-SCVirtualScsiAdapter -VMMServer localhost -JobGroup ed78c650-af8d-4b95-8f6a-0945d5ce7817 -AdapterID 7 -ShareVirtualScsiAdapter $false -ScsiControllerType DefaultTypeNoType 


New-SCVirtualDVDDrive -VMMServer localhost -JobGroup ed78c650-af8d-4b95-8f6a-0945d5ce7817 -Bus 1 -LUN 0 

$LogicalNetwork = Get-SCLogicalNetwork -VMMServer localhost -ID "58de67d6-2cb8-45c1-9528-ee20e85b123e"

New-SCVirtualNetworkAdapter -VMMServer localhost -JobGroup ed78c650-af8d-4b95-8f6a-0945d5ce7817 -MACAddressType Static -LogicalNetwork $LogicalNetwork -EnableMACAddressSpoofing $false -IPv4AddressType Dynamic -IPv6AddressType Dynamic 


Set-SCVirtualCOMPort -NoAttach -VMMServer localhost -GuestPort 1 -JobGroup ed78c650-af8d-4b95-8f6a-0945d5ce7817 


Set-SCVirtualCOMPort -NoAttach -VMMServer localhost -GuestPort 2 -JobGroup ed78c650-af8d-4b95-8f6a-0945d5ce7817 


Set-SCVirtualFloppyDrive -RunAsynchronously -VMMServer localhost -NoMedia -JobGroup ed78c650-af8d-4b95-8f6a-0945d5ce7817 

$CPUType = Get-CPUType -VMMServer localhost | where {$_.Name -eq "3.60 GHz Xeon (2 MB L2 cache)"}

$CapabilityProfile = Get-SCCapabilityProfile -VMMServer localhost | where {$_.Name -eq "Hyper-V"}

New-SCHardwareProfile -VMMServer localhost -CPUType $CPUType -Name "Profile38b75f45-c0ed-413c-98a7-bd9ef6c94db9" -Description "Profile used to create a VM/Template" -CPUCount 2 -MemoryMB 2048 -DynamicMemoryEnabled $true -DynamicMemoryMaximumMB 4096 -DynamicMemoryBufferPercentage 20 -MemoryWeight 5000 -VirtualVideoAdapterEnabled $false -CPUExpectedUtilizationPercent 20 -DiskIops 0 -CPUMaximumPercent 100 -CPUReserve 0 -NetworkUtilizationMbps 0 -CPURelativeWeight 100 -HighlyAvailable $true -NumLock $false -BootOrder "CD", "IdeHardDrive", "PxeBoot", "Floppy" -CPULimitFunctionality $false -CPULimitForMigration $false -CapabilityProfile $CapabilityProfile -JobGroup ed78c650-af8d-4b95-8f6a-0945d5ce7817 



New-SCVirtualDiskDrive -VMMServer localhost -IDE -Bus 0 -LUN 0 -JobGroup ed78c650-af8d-4b95-8f6a-0945d5ce7817 -VirtualHardDiskSizeMB 51200 -Dynamic -Filename "w8-desktop-01_disk_1" -VolumeType BootAndSystem 

$HardwareProfile = Get-SCHardwareProfile -VMMServer localhost | where {$_.Name -eq "Profile38b75f45-c0ed-413c-98a7-bd9ef6c94db9"}

New-SCVMTemplate -Name "Temporary Template21665b8d-eae3-4e48-a94f-db84ee915b5c" -HardwareProfile $HardwareProfile -JobGroup ed78c650-af8d-4b95-8f6a-0945d5ce7817 -NoCustomization 



$template = Get-SCVMTemplate -All | where { $_.Name -eq "Temporary Template21665b8d-eae3-4e48-a94f-db84ee915b5c" }
$virtualMachineConfiguration = New-SCVMConfiguration -VMTemplate $template -Name "w8-desktop-01"
Write-Output $virtualMachineConfiguration
$vmHost = Get-SCVMHost -ComputerName "mhvbronze02.vce.asc"
Set-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration -VMHost $vmHost
Update-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration
Update-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration
$operatingSystem = Get-SCOperatingSystem | where { $_.Name -eq "64-bit edition of Windows 8" }
New-SCVirtualMachine -Name "w8-desktop-01" -VMConfiguration $virtualMachineConfiguration -Description "" -BlockDynamicOptimization $false -JobGroup "ed78c650-af8d-4b95-8f6a-0945d5ce7817" -RunAsynchronously -DelayStartSeconds "0" -OperatingSystem $operatingSystem
