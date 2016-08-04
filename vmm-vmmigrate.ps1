# Prep: Intially place the sql and portal servers on mhvbronze01 and the desktop running the stream on mhvbronze05
# Run 1: Migrates the servers to the host mhvbronze05
# Run 2: Migrates the servers and desktop to mhvbronze01


# Run this first to get your variables set, they do not scavenge away so you only need to run once
$desktop01 = Get-SCVirtualMachine -VMMServer vcevmm01 -Name "w7-desktop-01 - David"
$desktop02 = Get-SCVirtualMachine -VMMServer vcevmm01 -Name "w7-desktop-02 - Roman"
$desktop03 = Get-SCVirtualMachine -VMMServer vcevmm01 -Name "w7-desktop-03 - Dean"
$portal01 = Get-SCVirtualMachine -VMMServer vcevmm01 -Name "sharepoint-farm2010-web-01"
$sql01 = Get-SCVirtualMachine -VMMServer vcevmm01 -Name "sharepoint-farm2010-web-01"
$host01 = Get-SCVMHost -VMMServer vcevmm01 | where {$_.Name -eq "mhvbronze01.vce.asc"}
$host02 = Get-SCVMHost -VMMServer vcevmm01 | where {$_.Name -eq "mhvbronze02.vce.asc"}
$host05 = Get-SCVMHost -VMMServer vcevmm01 | where {$_.Name -eq "mhvbronze05.vce.asc"}
$host06 = Get-SCVMHost -VMMServer vcevmm01 | where {$_.Name -eq "mhvbronze06.vce.asc"}


# Run 1
Move-SCVirtualMachine -VM $portal01 -VMHost $host05 -RunAsynchronously
Move-SCVirtualMachine -VM $sql01 -VMHost $host05 -RunAsynchronously


# Run 2
Move-SCVirtualMachine -VM $portal01 -VMHost $host01 -RunAsynchronously
Move-SCVirtualMachine -VM $sql01 -VMHost $host01 -RunAsynchronously
Move-SCVirtualMachine -VM $desktop03 -VMHost $host01 -RunAsynchronously
