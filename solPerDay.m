function powerPerDay = solPerDay(sunnyDaysPercentage, ...
    PVWattsPowerPerMonth, CloudyDayRadiationPercentage)

daysPerMonth = [31 28 31 30 31 30 31 31 30 31 30 31];

powerPerDay = PVWattsPowerPerMonth./(daysPerMonth.*(sunnyDaysPercentage ...
    +(1-sunnyDaysPercentage).*CloudyDayRadiationPercentage));

%powerPerMonth = powerPerDay.*daysPerMonth;

% days = rand(31,1);
% l = days < .48;
% days(l) = powerPerMonth(1);
% days(~l) = powerPerMonth(1)*CloudyDayRadiationPercentage;
% 
% sum(days)

end