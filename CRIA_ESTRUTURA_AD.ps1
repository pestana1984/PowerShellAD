## IMPORTA MODULO AD DENTRO DO POWERSHELL
Import-Module ActiveDirectory

## DESCOMENTAR SOMENTE PARA USO COM UMA SENHA PADRÃO INICIAL
$senha = ConvertTo-SecureString "123@Mudar" -AsPlainText -Force

## IMPORTA CSV DE USUARIOS
$usuarios = Import-CSV -Path "C:\AD_SCRIPT\usuarios.csv"

## COMENTAR CASO A OU PRIMARIA ESTEJA CRIADA
New-ADOrganizationalUnit -Name TMT -Path "DC=tmt,DC=stt" -ProtectedFromAccidentalDeletion:$true

Get-Content C:\AD_SCRIPT\SETORES.TXT |
foreach {
    New-ADOrganizationalUnit -Name "$_" -Path "OU=TMT,DC=tmt,DC=stt" -ProtectedFromAccidentalDeletion:$true
    }

$Setores=(Get-Content C:\AD_SCRIPT\SETORES.TXT) 
foreach ($Setor in $Setores){
    Get-Content C:\AD_SCRIPT\OUS.TXT |
    foreach {
        New-ADOrganizationalUnit -Name "$_" -Path "OU=$Setor,OU=TMT,DC=tmt,DC=stt" -ProtectedFromAccidentalDeletion:$true
        }
    }

foreach ($usuario in $usuarios) {

    $nomecompleto = $usuario.FirstName + " " + $usuario.LastName
    $nome = $usuario.FirstName
    $sobrenome = $usuario.LastName
    $departamento = $usuario.Department
    $email = $usuario.EmailAddress
    $login = $usuario.Login
    
    New-ADUser `
            -SamAccountName "$login" `
            -UserPrincipalName "$login@tmt.stt" `
            -Name "$nomecompleto" `
            -GivenName $nome `
            -Surname $sobrenome `
            -Enabled $True `
            -ChangePasswordAtLogon $True `
            -DisplayName "$Name" `
            -Department $departamento `
            -EmailAddress $email `
            -Path "OU=USUARIOS,OU=$departamento,OU=TMT,dc=tmt,dc=stt" `
            -AccountPassword $senha
}

Get-Content C:\AD_SCRIPT\PC_COMERCIAL.TXT |
foreach  {
    New-ADComputer -Name "$_" -SamAccountName "$_" -Path "OU=COMPUTADORES,OU=COMERCIAL,OU=TMT,DC=tmt,DC=stt" -Enabled $True
}

Get-Content C:\AD_SCRIPT\PC_DIRETORIA.TXT |
foreach  {
    New-ADComputer -Name "$_" -SamAccountName "$_" -Path "OU=COMPUTADORES,OU=DIRETORIA,OU=TMT,DC=tmt,DC=stt" -Enabled $True
}

Get-Content C:\AD_SCRIPT\PC_FINANCEIRO.TXT |
foreach  {
    New-ADComputer -Name "$_" -SamAccountName "$_" -Path "OU=COMPUTADORES,OU=FINANCEIRO,OU=TMT,DC=tmt,DC=stt" -Enabled $True
}

Get-Content C:\AD_SCRIPT\PC_LOGISTICA.TXT |
foreach  {
    New-ADComputer -Name "$_" -SamAccountName "$_" -Path "OU=COMPUTADORES,OU=LOGISTICA,OU=TMT,DC=tmt,DC=stt" -Enabled $True
}

Get-Content C:\AD_SCRIPT\PC_SUPORTE.TXT |
foreach  {
    New-ADComputer -Name "$_" -SamAccountName "$_" -Path "OU=COMPUTADORES,OU=SUPORTE,OU=TMT,DC=tmt,DC=stt" -Enabled $True
}

Get-Content C:\AD_SCRIPT\PC_VENDAS.TXT |
foreach  {
    New-ADComputer -Name "$_ -SamAccountName "$_" -Path "OU=COMPUTADORES,OU=VENDAS,OU=TMT,DC=tmt,DC=stt" -Enabled $True
}