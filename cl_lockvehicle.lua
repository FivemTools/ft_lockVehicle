-- @Project: FiveM Tools
-- @License: GNU General Public License v3.0

local vehicle = 0

function GetCurrentTargetCar()
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)
   
    local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 0.0)
    local rayHandle = Citizen.InvokeNative(0x28579D1B8F8AAC80, coords.x, coords.y, coords.z, entityWorld.x, entityWorld.y, entityWorld.z, 10.0, 2, ped, 0)
    local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)

    return vehicleHandle
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
    if IsControlJustPressed(1,303) then
      local vehcar = GetVehiclePedIsIn(GetPlayerPed(-1), false)
      local veh = GetCurrentTargetCar()
      if vehcar ~= 0 then
        local plate = GetVehicleNumberPlateText(vehcar)
        TriggerServerEvent("ft_lockvehicle:SvLockStatus", vehcar, plate)
      elseif veh ~= 0 then
        local plate = GetVehicleNumberPlateText(veh)
        TriggerServerEvent("ft_lockvehicle:SvLockStatus", veh, plate)
      end
    end 
  end
end)

RegisterNetEvent('ft_lockvehicle:ClLockStatus')
AddEventHandler('ft_lockvehicle:ClLockStatus', function(vehicle)
  if vehicle ~= 0 then
    local lockStatus = GetVehicleDoorLockStatus(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    if lockStatus == 1 or lockStatus == 0 then 
      SetVehicleDoorsLocked(vehicle, 2)
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "lock", 1.0) 
      exports.ft_ui:Notification("Véhicule verrouiller")
    else
      SetVehicleDoorsLocked(vehicle, 0)
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "unlock", 1.0) 
      exports.ft_ui:Notification("Véhicule déverrouiller")
    end
  end
end)