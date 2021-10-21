clc
clear

% changable, minimum days i 350
symbol1 = 'BTC-USD'; %'ETH-USD'
symbol2 = 'BTC-USD'; %'BTC-USD'
stocks = {'WISH'
'PINS'
'F'
'AAPL'
'FCEL'
'T'
'VALE'
'TLRY'
'BBD'
'BAC'
'AMD'
'ITUB'
'AAL'
'PYPL'
'AMC'
'VZ'
'NVAX'
'EDU'
'PBR'
'CCL'
'SOFI'
'NIO'
'PLTR'
'BKR'};

interval = '1d';
useLog = 1;
ShowRisk = 1;
ShowMA = 0;
ShowPriceDiv = 0;
ShowLogOver50Week = 0;
% supported intervals are '60m', '1d', '5d', '1wk', '1mo', '3mo'
% max value of days for 60m is 74 

%%
%gather data
data = main(interval, symbol1);
%plot data
PlotPriceData(data, ShowRisk, ShowMA, ShowPriceDiv, ShowLogOver50Week, useLog);

%% Find the stock with lowest risk in a given list
data = cell(length(stocks), 6);
min = 2;
ind = -1;
for i = 1:length(stocks)
    s = stocks{i};
    d = main(interval, s);
    data{i, 1} = d{1, 1};
    data{i, 2} = d{1, 2};
    data{i, 3} = d{1, 3};
    data{i, 4} = d{1, 4};
    data{i, 5} = d{1, 5};
    data{i, 6} = d{1, 6};
    temp = PlotPriceData(d, 0, 0, 0, 0, 0);
    val = temp(end,1);
    if val > 0 && min > val
        min = val;
        ind = i;
    end
end
if ind > 0
    PlotPriceData(data(ind,:), ShowRisk, ShowMA, ShowPriceDiv, ShowLogOver50Week, useLog);
end