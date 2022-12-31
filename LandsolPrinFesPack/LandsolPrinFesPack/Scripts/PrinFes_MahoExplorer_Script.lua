-- Maho Explorer Trait. Written by Konomi and edited by UzukiShimamura
-- ===========================================================================
include("GameCapabilities");

function MahoExplorerFreeSettler(playerID, cityID, iX, iY)
	if HasTrait("TRAIT_LEADER_FAIRYTALE_EXPLORATION", playerID) then
		local pCity = CityManager.GetCity(playerID, cityID)
		if pCity and pCity:GetOriginalOwner() == playerID then
			local pPlayer = Players[playerID]
			local pPlot = Map.GetPlot(iX, iY)
			local continentType = pPlot:GetContinentType()
			local pCapitalCity = pPlayer:GetCities():GetOriginalCapitalCity()
			if pCapitalCity then
				local capitalContinentType = Map.GetPlot(pCapitalCity:GetX(), pCapitalCity:GetY()):GetContinentType()
				if capitalContinentType ~= continentType then
					local continent = 'continent' .. tostring(continentType)
					local property = pPlayer:GetProperty(continent)
					if property == nil then
						pCity:AttachModifierByID("MAHO_EXPLORER_FREE_SETTLER");
						pPlayer:SetProperty(continent, 1)
					end
				end
			end
		end
    end
end
-- ===========================================================================
function Initialize()
	local flag = false
	for _, playerId in ipairs(PlayerManager.GetWasEverAliveMajorIDs()) do
		if HasTrait("TRAIT_LEADER_FAIRYTALE_EXPLORATION", playerId) then
			local pPlayer = Players[playerId]
			--[[
			if m_DramaPoetryCivicInfo and not pPlayer:GetCulture():HasBoostBeenTriggered(m_DramaPoetryCivicInfo.Index) then
				pPlayer:GetCulture():TriggerBoost(m_DramaPoetryCivicInfo.Index)
			end
			]]
			if not flag then
				Events.CityAddedToMap.Add(MahoExplorerFreeSettler)
				flag = true
			end
		end
	end
end
-- ===========================================================================
Events.LoadGameViewStateDone.Add(Initialize)
