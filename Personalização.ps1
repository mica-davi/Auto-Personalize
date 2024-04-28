#Removem a barra de pesquisa do windows
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value "0"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarModePrevious" -Value "2"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "TraySearchBoxVisible" -value "0"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "TraySearchBoxVisibleOnAnyMonitor" -value "0"

#Exibe todos os icones da aba de notificação
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -value "0"

#Remove o Copilot da barra de tarefas
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCopilotButton" -value "0"

#Desabilita a transparencia
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -value "0"


#Desabilita as dicas da cortana na tela de bloqueio
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "RotatingLockScreenOverlayEnabled" -value "0"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -value "0"





$path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" #Caminho no registro dos icones na área de trabalho

#Adiciona os icones My Computer e Pasta pessoal na area de trabalho
$mycomputer = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" #Nome da chave My Computer
$mcexiste = Get-ItemProperty -Path $path -Name $mycomputer -ErrorAction SilentlyContinue

if($mcexiste) #Verifica se a chave mycomputer existe, se n existe ele cria e atribui o valor 0, se já existir ele muda o valor para 0
{
    Set-ItemProperty -Path $path -Name $mycomputer -Value "0"
}else{
    New-ItemProperty -Path $path -Name $mycomputer -Value "0"
}


$pastapessoal = "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" #Nome da chave da pasta pessoal
$ppexiste= Get-ItemProperty -Path $path -Name $pastapessoal -ErrorAction SilentlyContinue

if($ppexiste) #Verifica se a chave da pasta pessoal existe, se n existe ele cria e atribui o valor 0, se já existir ele muda o valor para 0
{
    Set-ItemProperty -Path $path -Name $pastapessoal -Value "0"
}else{
    New-ItemProperty -Path $path -Name $pastapessoal -Value "0"
}




#Pastas do menu iniciar
#Este não fui eu que fiz, mas uma explicação de como funciona

#Ele vai até o registro que está sendo usado, e pega os primeiros 20 bytes para montar a nova chave.
#Os primeiros bytes são compostos por: Bytes genéricos, e bytes que marcam o momento em que foi feito a ultima alteração (Ou seja, eles pode continuar os mesmos
#já que o momento em que isso não importa pra gente)

#Depois, Ele vai adicionar mais 3 bytes 'genéricos' (eles servem pra indicar que o numero a seguir corresponde ao tamanho da lista de itens)

#Então, ele vai adicionando à chave os bytes correspondentes a cada pasta.

#Depois ele adiciona mais uns bytes genéricos pra determinar o fim do valor da chave.

#Depois ele muda o conteudo da chave para a chave modificada que a gente criou

$itemsToDisplay = @("explorer", "settings", "documents", "downloads", "personal") #Lista de itens no menu iniciar

#$key pega a chave que ta sendo usada atualmente
$key = Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*windows.data.unifiedtile.startglobalproperties\Current" 
$data = $key.Data[0..19] -Join "," #$data = os primeiros 20 bytes, + uma ',' entre eles
If ($itemsToDisplay.Length -gt 0) {
    $data += ",203,50,10,$($itemsToDisplay.Length)" #determina a quantidade de itens da lista


    If ($itemsToDisplay -contains "explorer") {
        $data += ",5,188,201,168,164,1,36,140,172,3,68,137,133,1,102,160,129,186,203,189,215,168,164,130,1,0"
    }
    If ($itemsToDisplay -contains "settings") {
        $data += ",5,134,145,204,147,5,36,170,163,1,68,195,132,1,102,159,247,157,177,135,203,209,172,212,1,0"
    }
    If ($itemsToDisplay -contains "documents") {
        $data += ",5,206,171,211,233,2,36,218,244,3,68,195,138,1,102,130,229,139,177,174,253,253,187,60,0"
    }
    If ($itemsToDisplay -contains "downloads") {
        $data += ",5,175,230,158,155,14,36,222,147,2,68,213,134,1,102,191,157,135,155,191,143,198,212,55,0"
    }
    If ($itemsToDisplay -contains "music") {
        $data += ",5,160,140,172,128,11,36,209,254,1,68,178,152,1,102,170,189,208,225,204,234,223,185,21,0"
    }
    If ($itemsToDisplay -contains "pictures") {
        $data += ",5,160,143,252,193,3,36,138,208,3,68,128,153,1,102,176,181,153,220,205,176,151,222,77,0"
    }
    If ($itemsToDisplay -contains "videos") {
        $data += ",5,197,203,206,149,4,36,134,251,1,68,244,133,1,102,128,201,206,212,175,217,158,196,181,1,0"
    }
    If ($itemsToDisplay -contains "network") {
        $data += ",5,196,130,214,243,15,36,141,16,68,174,133,1,102,139,181,211,233,254,210,237,177,148,1,0"
    }
    If ($itemsToDisplay -contains "personal") {
        $data += ",5,202,224,246,165,7,36,202,242,3,68,232,158,1,102,139,173,143,194,249,160,135,212,188,1,0"
    }
}
$data += ",194,60,1,194,70,1,197,90,1,0" #Determina o fim da lista
Set-ItemProperty -Path $key.PSPath -Name "Data" -Type Binary -Value $data.Split(",") #muda o valor da chave





#Substituir prompt de comando pelo windows powershell no menu quando eu clicar o botão direito
$pspath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$psvalue = "DontUsePowerShellOnWinX"
$psexiste = Get-ItemProperty -Path $pspath -Name $psvalue -ErrorAction SilentlyContinue

if($psexiste) #Verifica se a DontUsePowershell... existe, se n existe ele cria e atribui o valor 1, se já existir ele muda o valor para 1
{
    Set-ItemProperty -Path $pspath -Name $psvalue -Value "1"
}else{
    New-ItemProperty -Path $pspath -Name $psvalue -Value "1" -PropertyType DWord 
}




#Desabilita o botão visão de tarefas
$vtpath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$vtvalue = "ShowTaskViewButton"
$vtexiste = Get-ItemProperty -Path $vtpath -Name $vtvalue -ErrorAction SilentlyContinue

if($vtexiste){
    Set-ItemProperty -Path $vtpath -Name $vtvalue -Value "0" 
}else{
    New-ItemProperty -Path $vtpath -Name $vtvalue -Value "0" -PropertyType DWord 
}

$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"



#O script abaixo muda a cor de destaque do windows

#Path do registro
$RegPath="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"
#Hashtable da chave AccentPalletKey
$AccentColorMenuKey = @{
	Key   = 'AccentColorMenu';
	Type  = "DWORD";
	Value = '0xff74757a'
}

If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $AccentColorMenuKey.Key -ErrorAction SilentlyContinue))
{
	New-ItemProperty -Path $RegPath -Name $AccentColorMenuKey.Key -Value $AccentColorMenuKey.Value -PropertyType $AccentColorMenuKey.Type -Force
}
Else
{
	Set-ItemProperty -Path $RegPath -Name $AccentColorMenuKey.Key -Value $AccentColorMenuKey.Value -Force
}




#Hash table esquisita do Accent Pallet
$AccentPaletteKey = @{
	Key   = 'AccentPalette';
	Type  = "BINARY";
	Value = 'd9,d1,ce,00,c8,c0,be,00,a7,a0,9f,00,7a,75,74,00,5f,5b,5a,00,39,36,36,00,26,25,25,00,ea,00,5e,00'
}
$hexified = $AccentPaletteKey.Value.Split(',') | ForEach-Object { "0x$_" } #Esta linha adiciona '0x' antes de cada hex. é o formato q o regedit aceita ¯\_(ツ)_/¯

If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $AccentPaletteKey.Key -ErrorAction SilentlyContinue))
{
	New-ItemProperty -Path $RegPath -Name $AccentPaletteKey.Key -PropertyType Binary -Value ([byte[]]$hexified)
}
Else
{
	Set-ItemProperty -Path $RegPath -Name $AccentPaletteKey.Key -Value ([byte[]]$hexified) -Force
}


#MotionAccentId_v1.00 Key | Essa chave é quase sempre 0x000000db. Mas é bom definir pra garantir 
$MotionAccentIdKey = @{
	Key   = 'MotionAccentId_v1.00';
	Type  = "DWORD";
	Value = '0x000000db'
}

If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $MotionAccentIdKey.Key -ErrorAction SilentlyContinue))
{
	New-ItemProperty -Path $RegPath -Name $MotionAccentIdKey.Key -Value $MotionAccentIdKey.Value -PropertyType $MotionAccentIdKey.Type -Force
}
Else
{
	Set-ItemProperty -Path $RegPath -Name $MotionAccentIdKey.Key -Value $MotionAccentIdKey.Value -Force
}



#Hash table da chave StartMenuKey
$StartMenuKey = @{
	Key   = 'StartColorMenu';
	Type  = "DWORD";
	Value = '0xff5a5b5f'
}

If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $StartMenuKey.Key -ErrorAction SilentlyContinue))
{
	New-ItemProperty -Path $RegPath -Name $StartMenuKey.Key -Value $StartMenuKey.Value -PropertyType $StartMenuKey.Type -Force
}
Else
{
	Set-ItemProperty -Path $RegPath -Name $StartMenuKey.Key -Value $StartMenuKey.Value -Force
}


#Restarta o Explorer.exe (Necessário pra aplicar as mudanças cetinho)
Stop-Process -ProcessName explorer -Force -ErrorAction SilentlyContinue

