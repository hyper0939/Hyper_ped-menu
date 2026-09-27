Config = {}

Config.Command = "pedmenu"

Config.Key = "F7"

Config.AllowedGroups = {
	"admin",
	"superadmin",
}

Config.Features = {
	Godmode = true,
	Invisible = true,
	Heal = true,
}

Config.HealHealth = 200
Config.HealArmour = 100

Config.Notifications = {
	NoPermission = "Du hast keine Berechtigung, das Ped-Menü zu verwenden.",
	PedChanged = "Dein Ped wurde erfolgreich geändert!",
	PedReset = "Dein Character wurde wiederhergestellt!",
	InvalidPed = "Ungültiger Ped-Name! Bitte überprüfe die Eingabe.",
	GodmodeOn = "Godmode ~g~aktiviert~s~!",
	GodmodeOff = "Godmode ~r~deaktiviert~s~!",
	InvisibleOn = "Unsichtbarkeit ~g~aktiviert~s~!",
	InvisibleOff = "Unsichtbarkeit ~r~deaktiviert~s~!",
	Healed = "Du wurdest vollständig geheilt!",
}
