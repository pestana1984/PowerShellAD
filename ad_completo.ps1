## IMPORTA MODULO AD DENTRO DO POWERSHELL
Import-Module ActiveDirectory

## DESCOMENTAR SOMENTE PARA USO COM UMA SENHA PADRÃO INICIAL
#$senha = ConvertTo-SecureString "123@Mudar" -AsPlainText -Force

## IMPORTA CSV DE USUARIOS
$usuarios = Import-CSV -Path "C:\AD_COVID\usuarios.csv"

## COMENTAR CASO A OU PRIMARIA ESTEJA CRIADA
New-ADOrganizationalUnit -Name COVID -Path "DC=covid,DC=lab" -ProtectedFromAccidentalDeletion:$true

New-ADOrganizationalUnit -Name RJ -Path "OU=COVID,DC=covid,DC=lab" -ProtectedFromAccidentalDeletion:$true
New-ADOrganizationalUnit -Name SP -Path "OU=COVID,DC=covid,DC=lab" -ProtectedFromAccidentalDeletion:$true

Get-Content C:\AD_COVID\SETORES.TXT |
foreach {
    New-ADOrganizationalUnit -Name "$_" -Path "OU=RJ,OU=COVID,DC=covid,DC=lab" -ProtectedFromAccidentalDeletion:$true
    New-ADOrganizationalUnit -Name "$_" -Path "OU=SP,OU=COVID,DC=covid,DC=lab" -ProtectedFromAccidentalDeletion:$true
    }

$Setores=(Get-Content C:\AD_COVID\SETORES.TXT) 
foreach ($Setor in $Setores){
    Get-Content C:\AD_COVID\OUS_RJ.TXT |
    foreach {
        New-ADOrganizationalUnit -Name "$_" -Path "OU=$Setor,OU=RJ,OU=COVID,DC=covid,DC=lab" -ProtectedFromAccidentalDeletion:$true
        }
    Get-Content C:\AD_COVID\OUS_SP.TXT |
        foreach {
            New-ADOrganizationalUnit -Name "$_" -Path "OU=$Setor,OU=SP,OU=COVID,DC=covid,DC=lab" -ProtectedFromAccidentalDeletion:$true
            }
        }

foreach ($usuario in $usuarios) {

    $nomecompleto = $usuario.FirstName + " " + $usuario.LastName
    $nomefoto = $usuario.FirstName + $usuario.LastName
    $nome = $usuario.FirstName
    $sobrenome = $usuario.LastName
    $departamento = $usuario.Department
    $endereco = $usuario.StreetAddress
    $cidade = $usuario.City
    $estado = $usuario.State
    ## COMENTAR A LINHA ABAIXO CASO A SENHA INICIAL SEJA IGUAL PARA TODOS
    $senha = ConvertTo-SecureString $usuario.Password -AsPlainText -Force
    $login = $usuario.FirstName + "." + $usuario.LastName
    $photo = [byte[]](Get-Content "C:\AD_COVID\fotos\$nomefoto.jpg" -Encoding byte)

    New-ADUser `
            -SamAccountName "$login" `
            -UserPrincipalName "$login@covid.lab" `
            -Name "$nomecompleto" `
            -GivenName $nome `
            -Surname $sobrenome `
            -Enabled $True `
            -ChangePasswordAtLogon $True `
            -DisplayName "$Name" `
            -Department $departamento `
            -Path "OU=USUARIOS,OU=$departamento,OU=$estado,OU=covid,dc=covid,dc=lab" `
            -AccountPassword $senha

                
    Set-ADUser $login -Replace @{thumbnailPhoto=$photo}
}