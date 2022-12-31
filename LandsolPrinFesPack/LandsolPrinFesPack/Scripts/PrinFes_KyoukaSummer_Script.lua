--[[ Kyouka (Summer) Leader Script - GamePlay Conetext
* @Author: Kevin Liu
* Section 1 - Aqua Crest Ability Extra Yields on Costal Plots
* Section 2 - Aqua Flock City Yield Percentage Bonus Trigger
* Section 3 - Aqua Flock Ranged Unit Combat Debuff Ability
*
* Global Variables and Helper Functions
]]
local AQUA_CREST_ENABLE     :string = "PROPERTY_AQUA_CREST";
local AQUA_CREST_SCIENCE    :string = "PROPERTY_AQUA_CREST_SCIENCE";
local AQUA_CREST_CULTURE    :string = "PROPERTY_AQUA_CREST_CULTURE";
local AQUA_CREST_PRODUCTION :string = "PROPERTY_AQUA_CREST_PRODUCTION";
local AQUA_FLOCK_CITY_STACK :string = "PROPERTY_AQUA_FLOCK_STACK";

local AQUA_CREST_RESOURCE_LIMIT        = 3;						--# of Bonus Yield Points in Total to Plance on one Tile
local AQUA_FLOCK_STACK_PER_DISTRICT    = 3;						--# of Modifier Stacks per District
local AQUA_FLOCK_STACK_PER_BUILDING    = 1;						--# of Modifier Stacks per Building
local AQUA_FLOCK_STACK_PER_IMPROVEMENT = 1;						--# of Modifier Stacks per Improvement
local AQUA_FLOCK_UNIT_DEBUFF_TURNS     = 2;						--# of Turns in Effect of Aqua Flock Unit Debuff (min = 1)


local function PlayerIsKyoukaSummer(iPlayerID :number)
	if (not iPlayerID or iPlayerID<0) then return nil end;
	local pPlayerConfig :table = PlayerConfigurations[iPlayerID];
	if (not pPlayerConfig or pPlayerConfig:GetLeaderTypeName() ~= "LEADER_HIKAWA_KYOUKA_SUMMER") then return nil end;
	return pPlayerConfig;
end


--[[ Section 1 : Aqua Crest Bonus Yield ]]
--==============================================================================================================================
local aquaCrestPlots :table = {};
local aquaCrestLastUpdated :number = -1;

local function SetAquaCrestOnPlot(iPlotID :number, pPlot :table, eImprovementType :number, eOwner :number)
	if (not pPlot or not pPlot:IsCoastalLand()) then return end;

	if (PlayerIsKyoukaSummer(eOwner) and eImprovementType >= 0 and not pPlot:IsImprovementPillaged()) then
		if (not aquaCrestPlots[iPlotID] or not pPlot:GetProperty(AQUA_CREST_ENABLE)) then
			pPlot:SetProperty(AQUA_CREST_ENABLE, true);			--Add Aqua Crest Property to Kyouka's Improvements
			table.insert(aquaCrestPlots, iPlotID, pPlot);
			if (pPlot:GetProperty(AQUA_CREST_SCIENCE)) then return end;

			local amount :table = { [0]=0, 0, 0 };				--If Plot acquire Aqua Crest First Time, Gen Random Yields
			for _=0, 2, 1 do
				local rand = Game.GetRandNum(AQUA_CREST_RESOURCE_LIMIT, AQUA_CREST_ENABLE);
				amount[rand] = amount[rand] + 1;				--/// CAUTION: Random ///--
			end
			pPlot:SetProperty(AQUA_CREST_SCIENCE,    amount[0]);
			pPlot:SetProperty(AQUA_CREST_CULTURE,    amount[1]);
			pPlot:SetProperty(AQUA_CREST_PRODUCTION, amount[2]);
		end
	else
		if (aquaCrestPlots[iPlotID] or pPlot:GetProperty(AQUA_CREST_ENABLE)) then
			pPlot:SetProperty(AQUA_CREST_ENABLE, false);		--Remove Aqua Crest Property if Not Valid anymore
			table.remove(aquaCrestPlots, iPlotID);
		end
	end
end

local function CheckPlotStatus()								--Vaidate Plot Status and Remove Invalid Properties
	local currentTurn = Game.GetCurrentGameTurn();
	if (currentTurn <= aquaCrestLastUpdated) then return end;	--Run Once per Turn at Turn Start
	aquaCrestLastUpdated = currentTurn;

	for iPlotID, pPlot in pairs(aquaCrestPlots) do
		SetAquaCrestOnPlot(iPlotID, pPlot, pPlot:GetImprovementType(), pPlot:GetImprovementOwner());
	end
end

--------------------------------------------------------------------------------------------------------------------------------
local function OnImprovementChanged(locX :number, locY :number, eImprovementType :number, eOwner :number)
	local iPlotID = Map.GetPlotIndex(locX, locY);
	SetAquaCrestOnPlot(iPlotID, Map.GetPlotByIndex(iPlotID), eImprovementType, eOwner);
end

local function OnImprovementRemovedFromMap(locX :number, locY :number, eOwner :number)
	local iPlotID = Map.GetPlotIndex(locX, locY);
	SetAquaCrestOnPlot(iPlotID, Map.GetPlotByIndex(iPlotID), -1, eOwner);
end

local function OnPlayerTurnStarted(iPlayerID :number)
	CheckPlotStatus();											--Check Kyouka's Improvements at Turn Start
	if (not PlayerIsKyoukaSummer(eOwner)) then return end;		--  to cover Unexpected Improvement Acquirement cases

	local pPlayerImprovements :table = Players[iPlayerID]:GetImprovements();
	if (not pPlayerImprovements) then return end;

	for _, iPlotID in pairs(pPlayerImprovements:GetImprovementPlots()) do
		local pPlot = Map.GetPlotByIndex(iPlotID);

		if (pPlot and pPlot:IsCoastalLand()) then
			local eImprovement = pPlot:GetImprovementType();
			OnImprovementChanged(pPlot:GetX(), pPlot:GetY(), eImprovement, iPlayerID);
		end
	end
end

Events.ImprovementAddedToMap	.Add(OnImprovementChanged);
Events.ImprovementRemovedFromMap.Add(OnImprovementRemovedFromMap);
Events.ImprovementChanged		.Add(OnImprovementChanged);
GameEvents.PlayerTurnStarted	.Add(OnPlayerTurnStarted);


--[[ Section 2 : Aqua Flock Yield Bonus ]]
--==============================================================================================================================
local function OnTurnEnd(iPlayerID :number)
	if (not PlayerIsKyoukaSummer(iPlayerID)) then return end;
	local stack = 0;

	for _, pCity in Players[iPlayerID]:GetCities():Members() do
		local pCityCenter = Map.GetPlot(pCity:GetX(), pCity:GetY());
		local stack = 0;
		for _, pPlot in pairs(pCity:GetOwnedPlots()) do			--Improvements Increase Stack by 1
			if (pPlot:GetProperty(AQUA_CREST_ENABLE)) then
				stack = stack + AQUA_FLOCK_STACK_PER_IMPROVEMENT;

			else												--Districts Increase Stack by 3
				if (pPlot:GetDistrictType()>=0 and (pPlot:IsCoastalLand() or pPlot:IsWater())) then
					if (not pPlot:IsCity()) then stack = stack + AQUA_FLOCK_STACK_PER_DISTRICT end;
					
					local iPlotID :number = pPlot:GetIndex();	--Buildings Increase Stack by 1
					local iCityID :number = pCity:GetID();
					local pBuildingTypes :table = ExposedMembers.AquaFlock.GetBuildingsOnPlot(iPlayerID, iCityID, iPlotID);

					if (pPlot:IsCity()) then
						for _, iBuildingType in ipairs(pBuildingTypes) do
							local buildingType :string = GameInfo.Buildings[iBuildingType].BuildingType;
							-- if (buildingType ~= "BUILDING_WALLS" and buildingType ~= "BUILDING_CASTLE" and buildingType ~= "BUILDING_STAR_FORT" and
							--		buildingType ~= "BUILDING_TSIKHE" and buildingType ~= "BUILDING_FLOOD_BARRIER") then
								stack = stack + AQUA_FLOCK_STACK_PER_BUILDING;
							--end
						end
					else
						stack = stack + (#pBuildingTypes) * AQUA_FLOCK_STACK_PER_BUILDING;
					end
				end
			end
		end														--Apply Property Stack Number
		pCityCenter:SetProperty(AQUA_FLOCK_CITY_STACK, stack);
	end
end

Events.LocalPlayerTurnEnd.Add(function() OnTurnEnd(Game.GetLocalPlayer()) end);
Events.RemotePlayerTurnEnd.Add(OnTurnEnd);


--[[ Section 3 : Aqua Flock Unit Ability ]]
--==============================================================================================================================
local aquaFlockActivatedUnits :table = {};

local function OnCombatOccurred(attackerPlayerID :number, attackerUnitID :number, defenderPlayerID :number, defenderUnitID :number, attackerDistrictID :number, defenderDistrictID :number)
	if (not attackerUnitID or not defenderPlayerID or not Players[attackerPlayerID] or not Players[defenderPlayerID]) then return end;
	
	local pUnit :table = Players[attackerPlayerID]:GetUnits():FindID(attackerUnitID);
	if (not pUnit or pUnit:GetAbility():GetAbilityCount("ABILITY_AQUA_FLOCK")<=0) then return end;
	pUnit = Players[defenderPlayerID]:GetUnits():FindID(defenderUnitID);
	if (not pUnit or pUnit:GetAbility():GetAbilityCount("ABILITY_AQUA_FLOCK_COUNTER")<=0) then return end;

	local turnCounter :number = pUnit:GetAbility():GetAbilityCount("ABILITY_AQUA_FLOCK_COUNTER") - 1;
	local activation  :number = pUnit:GetAbility():GetAbilityCount("ABILITY_AQUA_FLOCK_DEBUFF");

	if (activation == 0) then
		if (not aquaFlockActivatedUnits[attackerPlayerID]) then	--Grant Aqua Flock if Not in effect
			aquaFlockActivatedUnits[attackerPlayerID] = {};
		end
		table.insert(aquaFlockActivatedUnits[attackerPlayerID], { [0]=defenderPlayerID, defenderUnitID });
		Game.AddWorldViewText(0, "{LOC_TOOLTIP_AQUA_FLOCK_DEBUFF}", pUnit:GetX(), pUnit:GetY());
	end															--Otherwise Refresh turn counter
	
	pUnit:GetAbility():ChangeAbilityCount("ABILITY_AQUA_FLOCK_DEBUFF", 1-activation);
	pUnit:GetAbility():ChangeAbilityCount("ABILITY_AQUA_FLOCK_COUNTER", AQUA_FLOCK_UNIT_DEBUFF_TURNS-turnCounter);
end

--------------------------------------------------------------------------------------------------------------------------------
local function OnPlayerTurnActivated(iPlayerID :number)
	if (not aquaFlockActivatedUnits[iPlayerID]) then return end;
	local activatedUnits_new :table = {};

	for _,v in pairs(aquaFlockActivatedUnits[iPlayerID]) do		--Reduce Aqua Flock turn counter, and Deactivate effect
		local pUnit :table = Players[v[0]]:GetUnits():FindID(v[1]);
		if (pUnit) then
			pUnit:GetAbility():ChangeAbilityCount("ABILITY_AQUA_FLOCK_COUNTER", -1);

			if (pUnit:GetAbility():GetAbilityCount("ABILITY_AQUA_FLOCK_COUNTER")>1) then
				table.insert(activatedUnits_new, v);
			else
				pUnit:GetAbility():ChangeAbilityCount("ABILITY_AQUA_FLOCK_DEBUFF", -1);
			end
		end
	end
	aquaFlockActivatedUnits[iPlayerID] = activatedUnits_new;
end

GameEvents.OnCombatOccurred.Add(OnCombatOccurred);
GameEvents.PlayerTurnStarted.Add(OnPlayerTurnActivated);