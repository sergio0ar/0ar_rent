
-- FUNCIONES ESX

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)





-- MARKER Y INTERACCION
 
Citizen.CreateThread(function()
    while true do
        
        local pedCoords = GetEntityCoords(PlayerPedId())
        local distance = GetDistanceBetweenCoords(pedCoords.x,pedCoords.y,pedCoords.z,Config.Spawner.x,Config.Spawner.y,Config.Spawner.z)
        
        Citizen.Wait(0)

        if distance < Config.DrawMarker then      
            if Config.Marker == true  then
                sleep = 0
             DrawMarker(Config.Type, Config.Spawner.x, Config.Spawner.y, Config.Spawner.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z,Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, nil, nil, false)
            end
        end
 
        if Config.HelpNotification == true then
            if distance < Config.Size.x then
                sleep = 0
                ESX.ShowHelpNotification(Config.MessageHelp)
            end
        end

        if Config.FloatingInteraction == true then
            if distance < Config.Size.x then
                sleep = 0
                ESX.ShowFloatingHelpNotification(Config.MessageFloating2, vector3(Config.Spawner.x, Config.Spawner.y, Config.Spawner.z + 2))
            elseif distance < Config.Size.x + 4 then
                sleep = 0
				ESX.ShowFloatingHelpNotification(Config.MessageFloating1, vector3(Config.Spawner.x, Config.Spawner.y, Config.Spawner.z + 2))
            end
        end

        if Config.Text3dNotification == true then
            if distance < Config.Size.x then
                sleep = 0
                DrawText3D(Config.Spawner.x, Config.Spawner.y, Config.Spawner.z + 2, Config.MessageText3d2)
            elseif distance < Config.Size.x + 4 then
                sleep = 0
                DrawText3D(Config.Spawner.x, Config.Spawner.y, Config.Spawner.z + 2, Config.MessageText3d1)
            end
        end

        if distance < Config.Size.x then
            if IsControlJustReleased(1, 38) then
                spawnmenu()  
			end
        end
    end
end)
       



-- FUNCION DE SPAWNEO DE COCHE

function spawn_vehicle(veh, spawnx, spawny, spawnz)
    Citizen.Wait(0)

    local myPed = GetPlayerPed(-1)
    local vehicle = GetHashKey(veh)

    RequestModel(vehicle)

    while not HasModelLoaded(vehicle) do
        Wait(1)
    end
    SetVehicleModKit(vehicle, 0)
	SetVehicleLivery(vehicel, 1)
	local spawned_car = CreateVehicle(vehicle, spawnx, spawny, spawnz, 431.436, -996.786, 25.1887, true, false)
    local plate = "CTZN" ..math.random(100, 900)
    SetVehicleNumberPlateText(spawned_car, plate)
    SetVehicleOnGroundProperly(spawned_car)
    SetVehicleLivery(spawned_car, 2)
    SetPedIntoVehicle(myPed, spawned_car, -1)
    SetEntityHeading(spawned_car, Config.SpawnVehicle.h)
    SetModelAsNoLongerNeeded(vehicle)
    TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(spawned_car), GetDisplayNameFromVehicleModel(GetEntityModel(spawned_car)))
end




-- FUNCION MENU 

function spawnmenu()
	
	local elements = {} 
	
    if Config.NumberCars == 1 then
		table.insert(elements, {label = Config.CarName1, value = Config.CarSpawn1}) 
    end

    if Config.NumberCars == 2 then
        table.insert(elements, {label = Config.CarName1, value = Config.CarSpawne1})
        table.insert(elements, {label = Config.CarName2, value = Config.CarSpawn2}) 
    end

    if Config.NumberCars == 3 then
        table.insert(elements, {label = Config.CarName1, value = Config.CarSpawn1})
        table.insert(elements, {label = Config.CarName2, value = Config.CarSpawn2,}) 
        table.insert(elements, {label = Config.CarName3, value = Config.CarSpawn3,})
    end

        table.insert(elements, {label = Config.CarName1, value = Config.CarSpawn1,})
        table.insert(elements, {label = Config.CarName2, value = Config.CarSpawn2,}) 
        table.insert(elements, {label = Config.CarName3, value = Config.CarSpawn3,})
        table.insert(elements, {label = Config.CarName4, value = Config.CarSpawn4,})
	
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'client',
    {
		title    = Config.MenuName,
		align    = Config.PosicionMenu,
		elements = elements,
    },
	
	
	function(data, menu)
	if data.current.value == Config.CarSpawn1 then
        TriggerServerEvent("esx_rent:server:removeMoney")
        spawn_vehicle(Config.CarSpawn1, Config.SpawnVehicle.x, Config.SpawnVehicle.y, Config.SpawnVehicle.z)
        menu.close()
	end
	
	if data.current.value == Config.CarSpawn2 then
        TriggerServerEvent("esx_rent:server:removeMoney")
        spawn_vehicle(Config.CarSpawn2, Config.SpawnVehicle.x, Config.SpawnVehicle.y, Config.SpawnVehicle.z)
        menu.close()
	end

    if data.current.value == Config.CarSpawn3 then
        TriggerServerEvent("esx_rent:server:removeMoney")
        spawn_vehicle(Config.CarSpawn3, Config.SpawnVehicle.x, Config.SpawnVehicle.y, Config.SpawnVehicle.z)
        menu.close()
	end

    if data.current.value == Config.CarSpawn4 then
        TriggerServerEvent("esx_rent:server:removeMoney")
        spawn_vehicle(Config.CarSpawn4, Config.SpawnVehicle.x, Config.SpawnVehicle.y, Config.SpawnVehicle.z)
        menu.close()
	end

	ESX.UI.Menu.CloseAll()

    end,
	function(data, menu)
		menu.close()
		end
	)
end




-- CONSOLA

AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
    return
end
    print(resourceName..' -> Started')
end)
  

AddEventHandler('onClientResourceStop', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
    return
end
    print(resourceName..'esx_rent -> Stopped')
end)




-- PED

Citizen.CreateThread(function()

    local hash = GetHashKey(Config.ModelNpc)
    local pedCoords = GetEntityCoords(PlayerPedId())
    local distance = GetDistanceBetweenCoords(pedCoords.x,pedCoords.y,pedCoords.z,Config.Spawner.x,Config.Spawner.y,Config.Spawner.z)

    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(0)
    end

    if Config.Ped == true then
        ped = CreatePed("PED_TYPE_CIVFEMALE", Config.ModelNpc, Config.Spawner.x,  Config.Spawner.y , Config.Spawner.z, Config.Spawner.h, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskStartScenarioInPlace(ped, Config.AnimNpc, 0, true)
    end
end)




-- TEXT 3D

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = ((1/dist)*2)*(1/GetGameplayCamFov())*100

    if onScreen then

        -- Formalize the text
        SetTextColour(Config.Text3dColor.r, Config.Text3dColor.g, Config.Text3dColor.b, Config.Text3dColor.alpha)
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(Config.Font)
        SetTextProportional(1)
        SetTextCentre(true)
        if dropShadow then
            SetTextDropshadow(10, 100, 100, 100, 255)
        end

        -- Calculate width and height
        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55*scale, Config.Fontfont)
        local width = EndTextCommandGetWidth(Config.Font)

        -- Diplay the text
        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)

        if Config.Backround == true then
            DrawRect(_x, _y+scale/45, width, height, Config.BackroundColor.r, Config.BackroundColor.g, Config.BackroundColor.b , Config.BackroundColor.alpha)
        end
    end
end