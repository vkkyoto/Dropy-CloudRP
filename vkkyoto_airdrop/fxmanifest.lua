fx_version "cerulean"
game "gta5"
lua54 "yes"
author "leaked by vkkyoto#1834"
version "1.0.0"

client_script "client.lua"
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}
shared_script "Config.lua"