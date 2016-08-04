
$target = "mhvbronze02.vce.asc"
$hosttarget = Get-SCVMHost -VMMServer vcevmm02 | where {$_.Name -eq $target}

foreach($vm in Get-SCVirtualMachine  -VMMServer vcevmm02)
{
	Write-Host "Shifting:" $vm.Name
	Move-SCVirtualMachine -VM $vm -VMHost $hosttarget -RunAsynchronously
}

