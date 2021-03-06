function runPercentage = solarEst(sunnyDaysPercentage, solarPerDay, powerUsage, ...
                batterySize, solarSize)

% Days to simulate. 
days = 100000;

% Create a list of days that if sunny are a 0 and if cloudy are a 1. 

temp = rand(days,1);
weather = temp < sunnyDaysPercentage;

% Setup daily power usage !!!TODO interpolate montly to daily!!!
daysPerMonth = [31 28 31 30 31 30 31 31 30 31 30 31];
temp = cumsum(daysPerMonth);

powerUsageDaily = powerUsage./daysPerMonth;

powerUsage = zeros(1,365);
powerCharge = zeros(1,365);

powerUsage(1:temp(1)) = powerUsageDaily(1);
powerCharge(1:temp(1)) = solarPerDay(1)*solarSize;
for i = 1:length(daysPerMonth)-1
    powerUsage(temp(i):temp(i+1)) = powerUsageDaily(i+1);
    powerCharge(temp(i):temp(i+1)) = solarPerDay(i+1)*solarSize;
end

% Power usage per day.
temp = repmat(powerUsage,1,ceil(days/365));
batDischarge = -temp(1:days);

% How much the batteries get charged per day.
temp = repmat(powerCharge,1,ceil(days/365))';
batCharge(weather) = temp(weather);
batCharge(~weather) = temp(~weather)*.15;

batCharge = batCharge + batDischarge;

for i = 1:days-1
    batCharge(i+1) = batCharge(i)+batCharge(i+1);
    if batCharge(i+1) > batterySize
        batCharge(i+1) = batterySize;
    elseif batCharge(i+1) < 0
        batCharge(i+1) = 0;
    end
end

runPercentage = sum(sign(batCharge))/days;
end