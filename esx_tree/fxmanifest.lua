fx_version 'adamant'

game 'gta5'

description 'ESX_Tree'

version '1.0.0'

client_scripts { 
  '@mysql-async/lib/MySQL.lua',
  'client.lua',
}

server_scripts { 
  'server.lua',
}

dependencies {
	'es_extended'
}
