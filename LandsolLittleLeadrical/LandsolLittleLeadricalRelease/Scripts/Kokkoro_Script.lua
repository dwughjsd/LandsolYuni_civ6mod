include("GameCapabilities");

function OnPantheonFounded_PureWhiteRevelation(ePlayer:number)
	if HasTrait("TRAIT_LEADER_PURE_WHITE_REVELATION",ePlayer) then
    	local player = Players[ePlayer]
		local playerCulture = player:GetCulture();
		playerCulture:SetCulturalProgress(GameInfo.Civics["CIVIC_MYSTICISM"].Index, playerCulture:GetCultureCost(GameInfo.Civics["CIVIC_MYSTICISM"].Index));
		player:AttachModifierByID("REVELATION_GREATPROPHETPOINTS");
    end
end

Events.PantheonFounded.Add( OnPantheonFounded_PureWhiteRevelation );
