Select-AzSubscription -SubscriptionId 'test subscriptipon id'
$VMs = Get-AzVM
$data = @()
foreach($VirtualMachine in $VMs){
$vm=Get-AzVm -Name $VirtualMachine.Name
$VmSize=((Get-AzVM -ResourceGroupName $VirtualMachine.ResourceGroupName -Name $VirtualMachine.Name).HardwareProfile).VmSize
$nic = $vm.NetworkProfile.NetworkInterfaces
$networkinterface = ($nic.id -split '/')[-1]
$NetworkDetails = Get-AzNetworkInterface -Name $networkinterface
$Vnet=($NetworkDetails.IpConfigurations.Subnet.Id -split '/')[-3] 
$Subnet=($NetworkDetails.IpConfigurations.Subnet.Id -split '/')[-1] 
$IP=$NetworkDetails.IpConfigurations.PrivateIpAddress 
$OSDiskSize=(((Get-AzVM -ResourceGroupName $VirtualMachine.ResourceGroupName -Name $VirtualMachine.Name).StorageProfile).OSDisk).DiskSizeGB
$DataDiskSize=(((Get-AzVM -ResourceGroupName $VirtualMachine.ResourceGroupName -Name $VirtualMachine.Name).StorageProfile).DataDisk).DiskSizeGB
$row = New-Object PSObject
$row | Add-Member -MemberType NoteProperty -Name "SL_no" -Value $data.Count
$row | Add-Member -MemberType NoteProperty -Name "ResourceGroup Name" -Value $VirtualMachine.ResourceGroupName
$row | Add-Member -MemberType NoteProperty -Name "Server Name" -Value $VirtualMachine.Name
$row | Add-Member -MemberType NoteProperty -Name "Size" -Value $VmSize
$row | Add-Member -MemberType NoteProperty -Name "OS" -Value $VirtualMachine.OsType
$row | Add-Member -MemberType NoteProperty -Name "ProvisioningState" -Value $VirtualMachine.ProvisioningState
$row | Add-Member -MemberType NoteProperty -Name "Location" -Value $VirtualMachine.Location
$row | Add-Member -MemberType NoteProperty -Name "Virtual Network" -Value $Vnet
$row | Add-Member -MemberType NoteProperty -Name "Subnet" -Value $Subnet
$row | Add-Member -MemberType NoteProperty -Name "IP" -Value $IP
$row | Add-Member -MemberType NoteProperty -Name "OSDiskSize" -Value $OSDiskSize
$row | Add-Member -MemberType NoteProperty -Name "DataDiskSize" -Value $DataDiskSize
$data += $row
$data | Export-Csv "VMDetails.csv" -NoTypeInformation -Append
}
import-csv "VMDetails.csv" | ConvertTo-Json | Add-Content -Path "output.json"


 
 
 
