local ESX = exports["es_extended"]:getSharedObject()

local menuOpen = false
local godmodeOn = false
local invisibleOn = false

local savedPedData = nil

local function HasPermission()
	local playerData = ESX.GetPlayerData()
	if not playerData or not playerData.group then
		return false
	end
	for _, group in ipairs(Config.AllowedGroups) do
		if playerData.group == group then
			return true
		end
	end
	return false
end

local function SaveCurrentPed()
	if savedPedData then
		return
	end

	local ped = PlayerPedId()
	savedPedData = {
		model = GetEntityModel(ped),
		components = {},
		props = {},
		hairColor = { GetPedHairColor(ped), GetPedHairHighlightColor(ped) },
	}

	for i = 0, 11 do
		savedPedData.components[i] = {
			drawable = GetPedDrawableVariation(ped, i),
			texture = GetPedTextureVariation(ped, i),
			palette = GetPedPaletteVariation(ped, i),
		}
	end

	for i = 0, 8 do
		savedPedData.props[i] = {
			drawable = GetPedPropIndex(ped, i),
			texture = GetPedPropTextureIndex(ped, i),
		}
	end

	savedPedData.headOverlays = {}
	for i = 0, 12 do
		local _, overlayValue, colourType, firstColour, secondColour, overlayOpacity = GetPedHeadOverlayData(ped, i)
		savedPedData.headOverlays[i] = {
			index = overlayValue,
			colorType = colourType,
			firstCol = firstColour,
			secondCol = secondColour,
			opacity = overlayOpacity,
		}
	end

	savedPedData.faceFeatures = {}
	for i = 0, 19 do
		savedPedData.faceFeatures[i] = GetPedFaceFeature(ped, i)
	end

	local _, shapeFirst, shapeSecond, shapeThird, skinFirst, skinSecond, skinThird, shapeMix, skinMix, thirdMix =
		GetPedHeadBlendData(ped)
	savedPedData.headBlend = {
		shapeFirst = shapeFirst,
		shapeSecond = shapeSecond,
		shapeThird = shapeThird,
		skinFirst = skinFirst,
		skinSecond = skinSecond,
		skinThird = skinThird,
		shapeMix = shapeMix,
		skinMix = skinMix,
		thirdMix = thirdMix,
	}

	savedPedData.eyeColor = GetPedEyeColor(ped)
end

local function RestoreSavedPed()
	if not savedPedData then
		return false
	end

	local modelHash = savedPedData.model

	RequestModel(modelHash)
	while not HasModelLoaded(modelHash) do
		Wait(10)
	end

	SetPlayerModel(PlayerId(), modelHash)
	local ped = PlayerPedId()

	local hb = savedPedData.headBlend
	if hb then
		SetPedHeadBlendData(
			ped,
			hb.shapeFirst,
			hb.shapeSecond,
			hb.shapeThird,
			hb.skinFirst,
			hb.skinSecond,
			hb.skinThird,
			hb.shapeMix,
			hb.skinMix,
			hb.thirdMix,
			false
		)
	end

	for i = 0, 11 do
		local comp = savedPedData.components[i]
		if comp then
			SetPedComponentVariation(ped, i, comp.drawable, comp.texture, comp.palette)
		end
	end

	for i = 0, 8 do
		local prop = savedPedData.props[i]
		if prop then
			if prop.drawable == -1 then
				ClearPedProp(ped, i)
			else
				SetPedPropIndex(ped, i, prop.drawable, prop.texture, true)
			end
		end
	end

	if savedPedData.headOverlays then
		for i = 0, 12 do
			local ov = savedPedData.headOverlays[i]
			if ov then
				SetPedHeadOverlay(ped, i, ov.index, ov.opacity)
				if ov.colorType and ov.colorType > 0 then
					SetPedHeadOverlayColor(ped, i, ov.colorType, ov.firstCol, ov.secondCol)
				end
			end
		end
	end

	if savedPedData.faceFeatures then
		for i = 0, 19 do
			if savedPedData.faceFeatures[i] then
				SetPedFaceFeature(ped, i, savedPedData.faceFeatures[i])
			end
		end
	end

	if savedPedData.hairColor then
		SetPedHairColor(ped, savedPedData.hairColor[1], savedPedData.hairColor[2])
	end

	if savedPedData.eyeColor then
		SetPedEyeColor(ped, savedPedData.eyeColor)
	end

	SetModelAsNoLongerNeeded(modelHash)
	savedPedData = nil

	return true
end

local function OpenMenu()
	if menuOpen then
		return
	end
	if not HasPermission() then
		ESX.ShowNotification(Config.Notifications.NoPermission)
		return
	end
	menuOpen = true
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = "openMenu",
		features = Config.Features,
		godmode = godmodeOn,
		invisible = invisibleOn,
	})
end

local function CloseMenu()
	if not menuOpen then
		return
	end
	menuOpen = false
	SetNuiFocus(false, false)
	SendNUIMessage({ action = "closeMenu" })
end

local function SetPedModel(modelName)
	local modelHash = GetHashKey(modelName)

	if not IsModelInCdimage(modelHash) or not IsModelValid(modelHash) then
		ESX.ShowNotification(Config.Notifications.InvalidPed)
		return false
	end

	RequestModel(modelHash)
	while not HasModelLoaded(modelHash) do
		Wait(10)
	end

	SetPlayerModel(PlayerId(), modelHash)
	SetModelAsNoLongerNeeded(modelHash)

	return true
end

CreateThread(function()
	while true do
		if godmodeOn then
			local ped = PlayerPedId()
			SetEntityInvincible(ped, true)
			SetEntityHealth(ped, GetEntityMaxHealth(ped))
		end
		Wait(godmodeOn and 500 or 1000)
	end
end)

RegisterNUICallback("confirm", function(data, cb)
	local pedName = data.pedName
	if not pedName or pedName == "" then
		cb({ success = false })
		return
	end

	pedName = string.lower(pedName)

	SaveCurrentPed()

	if SetPedModel(pedName) then
		ESX.ShowNotification(Config.Notifications.PedChanged)
		TriggerServerEvent("hyper_ped-menu:logPedChange", pedName)
		cb({ success = true })
	else
		cb({ success = false })
	end
end)

RegisterNUICallback("reset", function(_, cb)
	if RestoreSavedPed() then
		ESX.ShowNotification(Config.Notifications.PedReset)
		TriggerServerEvent("hyper_ped-menu:logPedChange", "RESET")
		cb({ success = true })
	else
		ESX.ShowNotification(Config.Notifications.PedReset)
		cb({ success = true })
	end
end)

RegisterNUICallback("exit", function(_, cb)
	CloseMenu()
	cb("ok")
end)

RegisterNUICallback("godmode", function(_, cb)
	godmodeOn = not godmodeOn

	if not godmodeOn then
		SetEntityInvincible(PlayerPedId(), false)
	end

	ESX.ShowNotification(godmodeOn and Config.Notifications.GodmodeOn or Config.Notifications.GodmodeOff)
	cb({ active = godmodeOn })
end)

RegisterNUICallback("invisible", function(_, cb)
	invisibleOn = not invisibleOn
	local ped = PlayerPedId()

	if invisibleOn then
		SetEntityVisible(ped, false, false)
	else
		SetEntityVisible(ped, true, false)
	end

	ESX.ShowNotification(invisibleOn and Config.Notifications.InvisibleOn or Config.Notifications.InvisibleOff)
	cb({ active = invisibleOn })
end)

RegisterNUICallback("heal", function(_, cb)
	local ped = PlayerPedId()
	SetEntityHealth(ped, Config.HealHealth)
	SetPedArmour(ped, Config.HealArmour)
	ESX.ShowNotification(Config.Notifications.Healed)
	cb({ success = true })
end)

RegisterCommand(Config.Command, function()
	if menuOpen then
		CloseMenu()
	else
		OpenMenu()
	end
end, false)

RegisterKeyMapping(Config.Command, "Ped Menu öffnen", "keyboard", Config.Key)

AddEventHandler("onResourceStop", function(resource)
	if resource ~= GetCurrentResourceName() then
		return
	end

	if godmodeOn then
		SetEntityInvincible(PlayerPedId(), false)
	end
	if invisibleOn then
		SetEntityVisible(PlayerPedId(), true, false)
	end
	if menuOpen then
		SetNuiFocus(false, false)
	end
end)
