include("GameCapabilities");

-- Grant an ability when an unit is qualified for a reviving.
function OnUnitPromoted_GrantRifarePiuma(iPlayerID,iUnitID)
	if HasTrait("TRAIT_LEADER_RIFARE_PIUMA",iPlayerID) then
		local unitLevel = Players[iPlayerID]:GetUnits():FindID(iUnitID):GetExperience():GetLevel();
		ExposedMembers.PRINFES.GrantRifarePiuma(iPlayerID, iUnitID, unitLevel)
	end
end

Events.UnitPromoted.Add(OnUnitPromoted_GrantRifarePiuma);