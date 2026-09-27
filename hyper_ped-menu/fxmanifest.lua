fx_version("cerulean")
game("gta5")

author("Hyper")
description("Hyper's Ped Menu")
version("0.0.1")

shared_scripts({
	"@es_extended/imports.lua",
	"Config.lua",
})

client_scripts({
	"Code/client-side.lua",
})

server_scripts({
	"Code/server-side.lua",
})

ui_page("UI/index.html")

files({
	"UI/index.html",
	"UI/style.css",
	"UI/index.js",
	"UI/images/body.svg",
})
