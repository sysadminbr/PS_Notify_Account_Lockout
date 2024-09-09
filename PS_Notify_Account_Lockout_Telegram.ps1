##############################################################################
# CITRA IT - EXCELÊNCIA EM TI
# SCRIPT PARA NOTIFICAR AO SUPORTE QUE UMA CONTA DO AD FOI BLOQUEADA
# Author: luciano@citrait.com.br
# Date: 22/08/2020
# version: 1.0
# Agende este script para ser executando quando ocorrer o seguinte evento:
# Log Channel: Security
# Source: Microsoft Windows security auditing.
# Event ID: 4740
##############################################################################


#-----------------------------------------------------------------------------
# Variáveis ajustáveis pelo usuário
#-----------------------------------------------------------------------------

# Id do boot telegram
$bot_id = "YOUR_TELEGRAM_BOT_ID_HERE"

# Id do chat 
$chat_id = [String] "YOUT_TELEGRAM_CHAT_ID_HERE"



############ DO NOT MODIFY FROM NOW ON UNLESS YOU ARE A PS EXPERT ############
############     DON'T TELL I DIDN'T WARN YOU :D      ############


# Habilitando todas as versões do protocolo ssl/tls. Nem sempre o Tls1.2 vem habilitado por padrão.
[system.net.servicepointmanager]::SecurityProtocol = [System.Net.SecurityProtocolType].GetEnumNames()

# Obtendo o último evento de conta bloqueada no eventviewer
# Hope simultaneous account lockout does not happen -.-
Get-WinEvent -FilterHashTable @{LogName="Security";ID=4740} -MaxEvents 1 | `
    ForEach-Object {
		$message = $_.message
		Invoke-WebRequest -UseBasicParsing -Method GET -ContentType "application/x-www-form-urlencoded" -URI `
			"https://api.telegram.org/bot$bot_id/sendMessage?chat_id=$chat_id&parse_mode=HTML&text=$message" | Out-Null
	}


