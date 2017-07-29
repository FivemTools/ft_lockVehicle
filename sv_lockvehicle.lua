-- @Project: FiveM Tools
-- @License: GNU General Public License v3.0

local VehicleDatabase = {}
local charset = {}

for i = 48,  57 do table.insert(charset, string.char(i)) end --123...
for i = 65,  90 do table.insert(charset, string.char(i)) end --ABC...

---------------------Little Function---------------------
function GenerateUniquePlate(length)
  if length > 0 then
    return GenerateUniquePlate(length - 1) .. charset[math.random(1, #charset)]
  else
    return ""
  end
end

---------------------Special event to generate a unique number plate---------------------
RegisterServerEvent("ft_lockvehicle:SvPlateGenerator")
AddEventHandler("ft_lockvehicle:SvPlateGenerator", function()
  
  local plate = GenerateUniquePlate(8)
  local platefound = false
  
  while not platefound do
    for _,vehicle in pairs(VehicleDatabase) do
      if vehicle.plate ~= plate then
        TriggerClientEvent('ft_lockvehicle:ClPlateGenerator', source, plate)
        platefound = true
        break
      else
        plate = GenerateUniquePlate(8)
      end
    end
  end
  
end)

---------------------Add and remove function---------------------
RegisterServerEvent("ft_lockvehicle:SvAddVehicle")
AddEventHandler("ft_lockvehicle:SvAddVehicle", function(plate)
  local steamId = GetPlayerIdentifiers(source)[1]
  local name = GetPlayerName(source)
  table.insert(VehicleDatabase, {plate=plate, ownername=name, owner=steamId})     
end)

RegisterServerEvent("ft_lockvehicle:SvAddVehicleTarget")
AddEventHandler("ft_lockvehicle:SvAddVehicleTarget" function(target, plate)
  local steamId = GetPlayerIdentifiers(target)[1]
  local name = GetPlayerName(target)
  table.insert(VehicleDatabase, {plate=plate, ownername=name, owner=steamId})     
end)

RegisterServerEvent("ft_lockvehicle:SvRemoveVehicle")
AddEventHandler("ft_lockvehicle:SvRemoveVehicle", function(plate)
  local steamId = GetPlayerIdentifiers(source)[1]
  for k,vehicle in pairs(VehicleDatabase) do
    if vehicle.plate == plate and vehicle.owner == steamId then
      table.remove(VehicleDatabase, k)
      break
    end
  end
end)

RegisterServerEvent("ft_lockvehicle:SvRemoveVehicleTarget")
AddEventHandler("ft_lockvehicle:SvRemoveVehicleTarget", function(target, plate)
  local steamId = GetPlayerIdentifiers(target)[1]
  for k,vehicle in pairs(VehicleDatabase) do
    if vehicle.plate == plate and vehicle.owner == steamId then
      table.remove(VehicleDatabase, k)
      break
    end
  end
end)
---------------------LSPD Functions---------------------
RegisterServerEvent("ft_lockvehicle:SvLSPDCheckVehicleOwner")
AddEventHandler("ft_lockvehicle:SvLSPDCheckVehicleOwner", function(plate)
  local result = false
  for _,vehicle in pairs(VehicleDatabase) do
    if vehicle.plate == plate then
      result = true
      TriggerClientEvent('ft_ui:ClNotification', source,  "~h~Police Département~nrt~~n~Plaque : ~b~"..vehicle.plate.."~s~~n~Propriétaire : ~g~"..vehicle.owner.."~s~")
      break
    end
  end
  if not result then
    TriggerClientEvent('ft_ui:ClNotification', source, "~h~Police Département~nrt~~n~Plaque : ~b~"..vehicle.plate.."~s~~n~Propriétaire : ~b~Inconnu~s~")
  end
end)

---------------------Check if the player is owner---------------------
RegisterServerEvent("ft_lockvehicle:SvLockStatus")
AddEventHandler("ft_lockvehicle:SvLockStatus", function(veh, plate)
  local steamId = GetPlayerIdentifiers(source)[1]
  
  for _,vehicle in pairs(VehicleDatabase) do
    if vehicle.plate == plate then
      if vehicle.owner == steamId then
        TriggerClientEvent('ft_lockvehicle:ClLockStatus', source, veh)
        break
      end
    end
  end
  
end)
