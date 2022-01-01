resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Mecano Job'

version '1.1.0'

files {
	'visualsettings.dat'
}

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
}

client_scripts {
    '@es_extended/locale.lua',
    'client/menu.lua',
    'client/functions.lua'
    
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'server/main.lua',
    
}

dependencies {'es_extended'}
