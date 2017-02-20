% Percentage of sunny days in your area between 0-100. Check out
% https://www1.ncdc.noaa.gov/pub/data/ccd-data/pctposrank.txt
sunnyDaysPercentage = 57;

% This is peak sun hours Jan-Dec. Check out 
% http://rredc.nrel.gov/solar/old_data/nsrdb/1961-1990/redbook/sum2/state.html
PSH = [3.6, 4.5, 5.0, 5.1, 5.3, 5.5, 5.6, 5.5, 5.1, 4.3, 3.1, 3.0];

% This is kWH per month, Jan-Dec. Enter in what you use at your house.
powerUsage = [434 604 406 523 292 246 276 351 403 485 450 443];

% Battery size (kWH) and price per kWH
batterySize = 100;
batteryPrice = 450;

% Solar panel array size (kW)
solarSize = 12;
solarPrice = 2500;

% For optimal setup calculation what is the min run time percentage you
% want. 0 is the setup never has to run and 1 is the setup has to never go
% out for the 100,000 simulated days.
minRunPercentage = .95;


% Start some code, You dont need to concern yourself with anything past
% this

solFun = @(bat,sol) solarEst(sunnyDaysPercentage, PSH, powerUsage, bat, sol);

runPercentage = solFun(batterySize, solarSize)*100;

fprintf('The runtime with your proposed battery and solar size is %2.3f%%\n', ...
    runPercentage);

run2 = zeros(200*50 + 50,1);
price = run2;

for batterySize = 1:200
    for solarSize = 1:50
        temp = solFun(batterySize, solarSize);
        run2(batterySize*50 + solarSize) = temp;
        price(batterySize*50 + solarSize) = batterySize*batteryPrice ...
            + solarSize*solarPrice;
        if(temp > minRunPercentage)
            run2(batterySize*50 + solarSize+1:batterySize*50+50)=0;
            break;
        end
    end
end

l = run2 > minRunPercentage;
[cost,I] = min(price(l));
a = find(run2 > minRunPercentage);
optimalBatterySize = floor(a(I)/50);
optimalSolarSize = mod(a(I),50);

fprintf(['The optimal battery size is: %dkWH \n'  ...
         'The optimal solar size is: %dkW \n'   ...
         'With price of: $%d \n'], ...
         optimalBatterySize, optimalSolarSize, cost);



