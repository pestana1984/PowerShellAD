#Pasta Origem do arquivos
$Orig = 'D:\ps\Origem'

#Pasta Destino para cópia dos arquivos
$Dest = 'D:\ps\Destino'

#Pega todos os arquivos do caminho de Origem
$Files= Get-ChildItem $Orig

#Percorremos todos os arquivos encontrados
foreach($Fl in $Files){
	#Removendo o que não interessa
	$NewNameFile = $Fl -split "_decrypted"
	#Damos um novo nome para o arquivo
	$NewNameFile = $NewNameFile[0]
	#Definimos o caminho total para o arquivo de Origem
	$FullFlOrig  = $Orig+'\'+$Fl
	#Definimos o caminho total para o arquivo de Destino
	$FullFlDest  = $Dest+'\'+$NewNameFile
	#Copiamos o arquivo para o Destino com seu novo nome
	Copy-Item $FullFlOrig $FullFlDest
	#Escrevemos na tela o nome do arquivo original
	Write-Host $Fl
	#Escrevemos na tela o nome do arquivo renomeado (Destino)
	Write-Host $NewNameFile
}