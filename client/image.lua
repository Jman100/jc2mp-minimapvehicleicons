function doit()
	boatunoccupied = Image.Create(AssetLocation.Game, "hud_icon_boat_yellow_dif.dds")
	boatoccupied = Image.Create(AssetLocation.Game, "hud_icon_boat_orange_dif.dds")
	boatdestroyed = Image.Create(AssetLocation.Game, "hud_icon_boat_red_dif.dds")
	carunoccupied = Image.Create(AssetLocation.Game, "hud_icon_car_yellow_dif.dds")
	caroccupied = Image.Create(AssetLocation.Game, "hud_icon_car_orange_dif.dds")
	cardestroyed = Image.Create(AssetLocation.Game, "hud_icon_car_red_dif.dds")
	planeunoccupied = Image.Create(AssetLocation.Game, "hud_icon_heli_yellow_dif.dds")
	planeoccupied = Image.Create(AssetLocation.Game, "hud_icon_heli_orange_dif.dds")
	planedestroyed = Image.Create(AssetLocation.Game, "hud_icon_heli_red_dif.dds")
	 -- The 3 white icons below arent used in this script, but exist. They are white, despite the name saying green.
	boatwhite = Image.Create(AssetLocation.Game, "hud_icon_boat_green_dif.dds")
	carwhite = Image.Create(AssetLocation.Game, "hud_icon_car_green_dif.dds")
	planewhite = Image.Create(AssetLocation.Game, "hud_icon_heli_dif.dds")
end
function getVehType(vehicleid)
	boats = { 5,6,16,19,25,27,28,38,45,50,53,69,80,88 }
	planes = { 3,14,24,30,34,37,39,51,57,59,62,64,65,67,81,85 }
	for a, b in ipairs(boats) do
		if b == vehicleid then return "sea" end
	end
	for c, d in ipairs(planes) do
		if d == vehicleid then return "air" end
	end
	return "land"
end
function tick()
	for x in Client:GetVehicles() do
		if IsValid(LocalPlayer) and IsValid(x) then
			local pos, inrange = Render:WorldToMinimap(x:GetPosition())
			if inrange and x:GetDriver() ~= LocalPlayer then -- Don't show an icon if its the vehicle local player is driving
				if getVehType(x:GetModelId()) == "land" then
					if x:GetHealth() < .1 then -- Draw Red icon if the vehicle is destroyed
						cardestroyed:Draw(pos - Vector2(9,9), Vector2(18,18), Vector2(0, 0), Vector2(1,1))
					elseif x:GetDriver() ~= nil then -- Draw Orange icon if vehicle is occupied
						caroccupied:Draw(pos - Vector2(9,9), Vector2(18,18), Vector2(0, 0), Vector2(1,1))
					else -- Draw Yellow icon if vehicle is unoccupied
						carunoccupied:Draw(pos - Vector2(9,9), Vector2(18,18), Vector2(0, 0), Vector2(1,1))
					end
				elseif getVehType(x:GetModelId()) == "air" then
					if x:GetHealth() < .1 then
						planedestroyed:Draw(pos - Vector2(9,9), Vector2(18,18), Vector2(0, 0), Vector2(1,1))
					elseif x:GetDriver() ~= nil then
						planeoccupied:Draw(pos - Vector2(9,9), Vector2(18,18), Vector2(0, 0), Vector2(1,1))
					else
						planeunoccupied:Draw(pos - Vector2(9,9), Vector2(18,18), Vector2(0, 0), Vector2(1,1))
					end
				elseif getVehType(x:GetModelId()) == "sea" then
					if x:GetHealth() < .1 then
						boatdestroyed:Draw(pos - Vector2(9,9), Vector2(18,18), Vector2(0, 0), Vector2(1,1))
					elseif x:GetDriver() ~= nil then
						boatoccupied:Draw(pos - Vector2(9,9), Vector2(18,18), Vector2(0, 0), Vector2(1,1))
					else
						boatunoccupied:Draw(pos - Vector2(9,9), Vector2(18,18), Vector2(0, 0), Vector2(1,1))
					end
				end
			end
		end
	end
end
function delete()

end

Events:Subscribe("Render", tick)
Events:Subscribe("ModuleLoad", doit)
--Events:Subscribe("ModuleUnload", delete) 174.99.89.97