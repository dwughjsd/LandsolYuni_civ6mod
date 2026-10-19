include("GameCapabilities");

function OnPantheonFounded_PureWhiteRevelation(ePlayer:number)
	if HasTrait("TRAIT_LEADER_PURE_WHITE_REVELATION",ePlayer) then
    	local player = Players[ePlayer]
		player:AttachModifierByID("REVELATION_GREATPROPHETPOINTS");
    end
end

Events.PantheonFounded.Add( OnPantheonFounded_PureWhiteRevelation );
