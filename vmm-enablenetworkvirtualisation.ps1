$vSwitch = Get-VMSwitch -SwitchType External
# Check if Network Virtualization is bound
# This could be done by checking for the binding and seeing if it is enabled
ForEach-Object -InputObject $vSwitch {
if ((Get-NetAdapterBinding -ComponentID "ms_netwnv" -InterfaceDescription $_.NetAdapterInterfaceDescription).Enabled -eq $false){
  # Lets enable it
  Enable-NetAdapterBinding -InterfaceDescription $_.NetAdapterInterfaceDescription -ComponentID "ms_netwnv"
}
}