$photo = [byte[]](Get-Content "C:\temp\crusoe.jpg" -Encoding byte)            
Set-ADUser Crusoe -Replace @{thumbnailPhoto=$photo}