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





#Código para mudar os itens que aparecem no menu iniciar https://github.com/Disassembler0/Win10-Initial-Setup-Script/issues/199
#Essa é a maior gambiarra que eu já vi na minha vida e eu nem me atrevo a implementar








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

