include("GameCapabilities");

function GetUnitType( playerID: number, unitID : number )
	if( playerID == Game.GetLocalPlayer() ) then
		local pPlayer	:table = Players[playerID];
		local pUnit		:table = pPlayer:GetUnits():FindID(unitID);
		if pUnit ~= nil then
			return GameInfo.Units[pUnit:GetType()].UnitType;
		end
	end
	return nil;
end

function OnReligionFounded_RifarePiumaKokkoro(ePlayer:number)
	if HasTrait("TRAIT_LEADER_RIFARE_PIUMA",ePlayer) then
    	local player = Players[ePlayer]
        local capitalCity = player:GetCities():GetCapitalCity()
        if capitalCity ~= nil then
        local plotX = capitalCity:GetX()
        local plotY = capitalCity:GetY()
    	    UnitManager.InitUnit(ePlayer, "UNIT_LANDSOL_KOKKORO_AMES", plotX, plotY);
    	end
    end
end

function OnUnitKilledInCombat_RifarePiumaRiviveUnit(killedPlayerID:number, killedUnitID:number)
	if HasTrait("TRAIT_LEADER_RIFARE_PIUMA",killedPlayerID) then
		local pPlayer = Players[killedPlayerID];
		local pKilledUnit = pPlayer:GetUnits():FindID(killedUnitID);
        if pKilledUnit:GetAbility():GetAbilityCount("ABILITY_AMES_RIFARE_PIUMA") > 0 then 
            local unitType = GetUnitType(killedPlayerID,killedUnitID);
            local militaryFormation = pKilledUnit:GetMilitaryFormation();
            local capitalCity = pPlayer:GetCities():GetCapitalCity()
            if capitalCity ~= nil then
                local plotX = capitalCity:GetX()
                local plotY = capitalCity:GetY()
                pRevivedUnit = UnitManager.InitUnit(killedPlayerID, unitType, plotX, plotY);
                pRevivedUnit:SetMilitaryFormation(militaryFormation);
            end
        end
	end
end

-- need more test to see if a unit with retreating will produce duplicate units.
function GrantRifarePiuma(iPlayerID, iUnitID, unitLevel)
		local pUnit = Players[iPlayerID]:GetUnits():FindID(iUnitID);
		if (unitLevel >= 2) and (pUnit:GetAbility():GetAbilityCount("ABILITY_AMES_RIFARE_PIUMA") == 0) then
			pUnit:GetAbility():ChangeAbilityCount("ABILITY_AMES_RIFARE_PIUMA", 1);
		end
end

--Granting Guild Member Great People randomly. Originally written by Handsome Kai (PiPiKai). Thanks for his contribution!
local tGreatPeoplePool = nil;
local bGreatPeopleAvailable = true; -- A local variable to save query time.

function GenerateGreatPeopleTable(sGreatPersonClassType)
	tGreatPeoplePool = {}
    local tGreatPerson = GameInfo.GreatPersonIndividuals();
    local iGreatPersonPointer, iGreatPersonMax = 1, 24; -- Let it be 24 cuz we are going to make 24 memory pieces. If we need to have only a subset of it, truncate them later to get a more random result 
	
	for row in tGreatPerson do
		if row.GreatPersonClassType == sGreatPersonClassType then
			tGreatPeoplePool[iGreatPersonPointer] = row.GreatPersonIndividualType;
			iGreatPersonPointer = iGreatPersonPointer + 1;
		end
	end
	
	if (iGreatPersonMax) < iGreatPersonPointer then --Truncate the table if we need only part of it
		tGreatPeoplePool = ShuffleTable(tGreatPeoplePool); -- So that they are randomly removed
		for i = (iGreatPersonMax + 1), iGreatPersonPointer do
			tGreatPeoplePool[i] = nil
		end
    else
        tGreatPeoplePool = ShuffleTable(tGreatPeoplePool); -- Or Let's just use the table
	end
    Game:SetProperty("AMES_GUILD_MEMBER_TABLE", tGreatPeoplePool);
end


function ShuffleTable(tTable)
    if type(tTable) ~= "table" then return end
    local tShuffledtable = {}
    local index = 1
    while #tTable ~= 0 do
        local n = Game.GetRandNum(#tTable) +1;
        if tTable[n] ~= nil then -- we don't need nil
            tShuffledtable[index] =tTable[n]
            table.remove(tTable,n)
            index = index + 1
        end
    end
    return tShuffledtable
end

function OnLoadGameViewStateDone_InitGuildMemberTable()
    if Game:GetProperty("AMES_GUILD_MEMBER_TABLE") ~= nil then
        tGreatPeoplePool = Game:GetProperty("AMES_GUILD_MEMBER_TABLE")
    end
    if tGreatPeoplePool == nil then -- If a great people pool is never been built and not depletion is indicated, that's a new game. Generate the table for later use.
		GenerateGreatPeopleTable("GREAT_PERSON_CLASS_GUILD_MEMBER")
	end
end

function AlternateGrantFaith(playerID, amount)
    Players[playerID]:GetReligion():ChangeFaithBalance(amount);
end

function GrantGreatPersonAmes(playerID, iX, iY)
		if not bGreatPeopleAvailable then --When we know it's depleted, short-circuit it
            AlternateGrantFaith(playerID,300);--Grant some Faith
            return
		end 
		local iGreatPeopleRemaining = #tGreatPeoplePool
		if iGreatPeopleRemaining == 0 then -- Or it's depleted for the first time
			bGreatPeopleAvailable = false;
            AlternateGrantFaith(playerID,300);--Grant some Faith
			return
		end
		local iGreatPersonRand = Game.GetRandNum(iGreatPeopleRemaining) +1;
		local pGreatPersonIndividual = tGreatPeoplePool[iGreatPersonRand]
		Game.GetGreatPeople():CreatePerson(pPlayer, GameInfo.GreatPersonIndividuals[pGreatPersonIndividual].Hash, iX, iY);
		table.remove(tGreatPeoplePool, iGreatPersonRand);
		Game:SetProperty("AMES_GUILD_MEMBER_TABLE", tGreatPeoplePool);
end

function OnCityProjectCompleted_EnterDreamWorld(playerID, cityID, projectID)
	if projectID == GameInfo.Projects["PROJECT_ENTER_DREAM_WORLD"].Index then
		local pPlayer = Players[playerID];
		local pCity = pPlayer:GetCities():FindID(cityID);
		local iX = pCity:GetX();
		local iY = pCity:GetY();
		GrantGreatPersonAmes(playerID, iX, iY);
	end
end
--[[
function OnBuildingAddedToMap_GrantGuildMember( plotX:number, plotY:number, buildingId:number, playerId:number)
	if HasTrait("TRAIT_LEADER_RIFARE_PIUMA",playerId) then
		if buildingId == GameInfo.Buildings["BUILDING_GUILDHOUSE"].Index then
		    GrantGreatPersonAmes(playerID, plotX, plotY);
		end
	end
end
]]

Events.ReligionFounded.Add(OnReligionFounded_RifarePiumaKokkoro);
Events.UnitKilledInCombat.Add(OnUnitKilledInCombat_RifarePiumaRiviveUnit);
Events.CityProjectCompleted.Add(OnCityProjectCompleted_EnterDreamWorld);
Events.LoadGameViewStateDone.Add(OnLoadGameViewStateDone_InitGuildMemberTable);
--Events.BuildingAddedToMap.Add(OnBuildingAddedToMap_GrantGuildMember);



ExposedMembers.PRINFES = ExposedMembers.PRINFES or {}
ExposedMembers.PRINFES.GrantRifarePiuma = GrantRifarePiuma