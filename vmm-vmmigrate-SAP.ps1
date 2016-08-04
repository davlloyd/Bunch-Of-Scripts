# Prep: Intially place the sql and portal servers on mhvbronze01 and the desktop running the stream on mhvbronze05
# Run 1: Migrates the servers to the host mhvbronze05
# Run 2: Migrates the servers and desktop to mhvbronze01


# Run this first to get your variables set, they do not scavenge away so you only need to run once
$ap = Get-SCVirtualMachine -VMMServer vcevmm01 -Name "SAP - Application 01"
$db = Get-SCVirtualMachine -VMMServer vcevmm01 -Name "SAP - Database 01"
$ci = Get-SCVirtualMachine -VMMServer vcevmm01 -Name "SAP - Central Instance 01"
$desktop01 = Get-SCVirtualMachine -VMMServer vcevmm01 -Name "w7-desktop-01 - David"

$host01 = Get-SCVMHost -VMMServer vcevmm01 | where {$_.Name -eq "mhvbronze01.vce.asc"}
$host02 = Get-SCVMHost -VMMServer vcevmm01 | where {$_.Name -eq "mhvbronze02.vce.asc"}
$host05 = Get-SCVMHost -VMMServer vcevmm01 | where {$_.Name -eq "mhvbronze05.vce.asc"}
$host06 = Get-SCVMHost -VMMServer vcevmm01 | where {$_.Name -eq "mhvbronze06.vce.asc"}


# Starting position prep
Move-SCVirtualMachine -VM $ci -VMHost $host02 -RunAsynchronously
Move-SCVirtualMachine -VM $db -VMHost $host02 -RunAsynchronously
Move-SCVirtualMachine -VM $ap -VMHost $host02 -RunAsynchronously
Move-SCVirtualMachine -VM $desktop01 -VMHost $host02 -RunAsynchronously

# Run 1
Move-SCVirtualMachine -VM $ci -VMHost $host05 -RunAsynchronously
Move-SCVirtualMachine -VM $db -VMHost $host05 -RunAsynchronously
Move-SCVirtualMachine -VM $ap -VMHost $host05 -RunAsynchronously


# Run 2
Move-SCVirtualMachine -VM $ci -VMHost $host01 -RunAsynchronously
Move-SCVirtualMachine -VM $db -VMHost $host01 -RunAsynchronously
Move-SCVirtualMachine -VM $ap -VMHost $host01 -RunAsynchronously
Move-SCVirtualMachine -VM $desktop01 -VMHost $host01 -RunAsynchronously
