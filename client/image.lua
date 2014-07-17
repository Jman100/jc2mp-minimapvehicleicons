Images = {}

function gameImage(string)
	return Image.Create(AssetLocation.Game, string)
end

function createImages()
	-- The white icons present below aren't used in the script, but are available
	-- for your use. While the texture path says green, they are actually white.
	Images.Sea = {
		Unoccupied 	= gameImage("hud_icon_boat_yellow_dif.dds"),
		Occupied 	= gameImage("hud_icon_boat_orange_dif.dds"),
		Destroyed 	= gameImage("hud_icon_boat_red_dif.dds"),
		White 		= gameImage("hud_icon_boat_green_dif.dds"),
	}

	Images.Land = {
		Unoccupied 	= gameImage("hud_icon_car_yellow_dif.dds"),
		Occupied 	= gameImage("hud_icon_car_orange_dif.dds"),
		Destroyed 	= gameImage("hud_icon_car_red_dif.dds"),
		White 		= gameImage("hud_icon_car_green_dif.dds"),
	}

	Images.Air = {
		Unoccupied 	= gameImage("hud_icon_heli_yellow_dif.dds"),
		Occupied 	= gameImage("hud_icon_heli_orange_dif.dds"),
		Destroyed 	= gameImage("hud_icon_heli_red_dif.dds"),
		White 		= gameImage("hud_icon_heli_green_dif.dds"),
	}
end

function getVehicleType(vehicle)
	boats = { 5,6,16,19,25,27,28,38,45,50,53,69,80,88 }
	planes = { 3,14,24,30,34,37,39,51,57,59,62,64,65,67,81,85 }

	local vehicleId = vehicle:GetModelId()

	-- If we can find it in the boats array, it's a sea vehicle
	if table.find(boats, vehicleId) then 
		return "Sea"
	-- Otherwise, if we can find it in the planes array, it's an air vehicle
	elseif table.find(planes, vehicleId) then 
		return "Air"
	else
	-- If we're here, it must be a land vehicle.
		return "Land"
	end
end

function getVehicleState(vehicle)
	if vehicle:GetHealth() < 0.1 then
		return "Destroyed"
	elseif vehicle:GetDriver() ~= nil then
		return "Occupied"
	else
		return "Unoccupied"
	end
end

IconSize = Vector2(18, 18)
IconOffset = -IconSize/2

function drawVehicle(v)
	if not IsValid(v) then return end

	local pos, inRange = Render:WorldToMinimap(v:GetPosition())
	-- Don't show an icon if its the v local player is driving
	if inRange and v:GetDriver() ~= LocalPlayer then 
		local typeImages = Images[getVehicleType(v)]
		local image = typeImages[getVehicleState(v)]
		image:Draw(pos + IconOffset, IconSize, Vector2.Zero, Vector2.One)
	end
end

function render()
	for vehicle in Client:GetVehicles() do
		drawVehicle(vehicle)
	end
end

Events:Subscribe("Render", render)
Events:Subscribe("ModuleLoad", createImages)