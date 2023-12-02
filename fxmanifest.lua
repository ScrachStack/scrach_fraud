
fx_version('cerulean')
games({ 'gta5' })
author 'Zaps6000'
lua54 'yes'
version '1.5'
client_scripts({
'client/*'
});
server_scripts({
'server/*'
});
shared_scripts { '@ox_lib/init.lua', 'config.lua' }
depencedecy 'ox_lib'
