clc
clear

% changable, minimum days i 350
symbol1 = 'BTC-USD'; %'ETH-USD'
symbol2 = 'BTC-USD'; %'BTC-USD'

interval = '1wk';
useLog = 0;
ShowRisk = 0;
ShowMA = 0;
ShowPriceDiv = 0;
ShowLogOver50Week = 1;

% supported intervals are '60m', '1d', '5d', '1wk', '1mo', '3mo'
% max value of days for 60m is 74 

%gather data
data = main(interval, symbol1);
%plot data
PlotPriceData(data, ShowRisk, ShowMA, ShowPriceDiv, ShowLogOver50Week, useLog);