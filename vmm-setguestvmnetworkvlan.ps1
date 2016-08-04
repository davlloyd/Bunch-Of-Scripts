$vmnetwork = get-scvmnetwork "Primary External Network"
$vm = get-scvirtualmachine -name "SAP - Database 01"
$vnic = $vm.Virtualnetworkadapters[0]
set-scvirtualnetworkadapter $vnic -vmnetwork $vmnetwork -vlanenabled $true -vlanid 352
