
$mountdir = "d:\mount"
$winpeimage = "d:\temp\boot.wim"
$winpeimagetemp = $winpeimage + ".tmp"
mkdir $mountdir
copy $winpeimage $winpeimagetemp
dism /mount-wim /wimfile:$winpeimagetemp /index:1 /mountdir:$mountdir
$drivers = get-scdriverpackage | where { $_.tags -match "HBA" }
foreach ($driver in $drivers)  {dism /image:$mountdir /add-driver /driver:} 
Dism /Unmount-Wim /MountDir:$mountdir /Commit 
publish-scwindowspe -path $winpeimagetemp
del $winpeimagetemp 
