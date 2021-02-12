Import-Module ActiveDirectory
$usuarios = Import-CSV -Path "C:\AD_COVID\usuarios.csv"

## DESCOMENTAR SOMENTE PARA USO COM UMA SENHA PADRÃO INICIAL
#$senha = ConvertTo-SecureString "123@Mudar" -AsPlainText -Force

foreach ($usuario in $usuarios) {

    $nomecompleto = $usuario.FirstName + " " + $usuario.LastName
    $nome = $usuario.FirstName
    $sobrenome = $usuario.LastName
    $departamento = $usuario.Department
    $endereco = $usuario.StreetAddress
    $cidade = $usuario.City
    $estado = $usuario.State
    ## COMENTAR A LINHA ABAIXO CASO A SENHA INICIAL SEJA IGUAL PARA TODOS
    $senha = ConvertTo-SecureString $usuario.Password -AsPlainText -Force
    $login = $usuario.FirstName + "." + $usuario.LastName
    
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

}