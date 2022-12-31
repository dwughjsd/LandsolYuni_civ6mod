ExposedMembers.AquaFlock = {
	GetBuildingsOnPlot = function (iPlayerID :number, iCityID :number, iPlotID :number)
		return CityManager.GetCity(iPlayerID,iCityID):GetBuildings():GetBuildingsAtLocation(iPlotID);
	end
};