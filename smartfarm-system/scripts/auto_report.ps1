Write-Output "=======================================" > ..\backup\bao-cao-su-co.txt
Write-Output "      BAO CAO SU CO - SMARTFARM" >> ..\backup\bao-cao-su-co.txt
Write-Output "Ngay gio: $(Get-Date)" >> ..\backup\bao-cao-su-co.txt
Write-Output "=======================================" >> ..\backup\bao-cao-su-co.txt
Get-Content ..\data\log-he-thong.log | Select-String -Pattern "CRITICAL","ERROR" >> ..\backup\bao-cao-su-co.txt
Write-Output "---------------------------------------" >> ..\backup\bao-cao-su-co.txt
Write-Output "TONG SO SU CO:" >> ..\backup\bao-cao-su-co.txt
(Get-Content ..\data\log-he-thong.log | Select-String -Pattern "CRITICAL","ERROR").Count >> ..\backup\bao-cao-su-co.txt
