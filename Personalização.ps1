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
$mcexiste = Get-ItemProperty -Path $path -Name $mycomputer

if($mcexiste) #Verifica se a chave mycomputer existe, se n existe ele cria e atribui o valor 0, se já existir ele muda o valor para 0
{
    Set-ItemProperty -Path $path -Name $mycomputer -Value "0"
}else{
    New-ItemProperty -Path $path -Name $mycomputer -Value "0"
}


$pastapessoal = "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" #Nome da chave da pasta pessoal
$ppexiste= Get-ItemProperty -Path $path -Name $pastapessoal

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
$psexiste = Get-ItemProperty -Path $pspath -Name $psvalue

if($psexiste) #Verifica se a DontUsePowershell... existe, se n existe ele cria e atribui o valor 1, se já existir ele muda o valor para 1
{
    Set-ItemProperty -Path $pspath -Name $psvalue -Value "1"
}else{
    New-ItemProperty -Path $pspath -Name $psvalue -Value "1" -PropertyType DWord 
}




#Desabilita o botão visão de tarefas
$vtpath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$vtvalue = "ShowTaskViewButton"
$vtexiste = Get-ItemProperty -Path $vtpath -Name $vtvalue

if($vtexiste){
    Set-ItemProperty -Path $vtpath -Name $vtvalue -Value "0" 
}else{
    New-ItemProperty -Path $vtpath -Name $vtvalue -Value "0" -PropertyType DWord 
}



#Restarta o Explorer.exe (Necessário pra aplicar as mudanças cetinho)
stop-process -Name "explorer" -Force