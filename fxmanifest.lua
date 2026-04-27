fx_version 'cerulean'
game 'gta5'
lua54 'yes'

ui_page 'nui/index.html'

shared_script 'config.lua'

client_scripts {
    'client.lua',
    'drift.lua',
    'backfire.lua',
    'tuning.lua',
    'garage.lua',
    'events.lua',
	'smoke.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

files {
    'nui/index.html',
    'nui/garage.html',
    'nui/leaderboard.html',
    'nui/style.css',
    'nui/script.js'
}