clc
clear

% changable, minimum days i 350
symbol1 = 'BTC-USD'; %'ETH-USD'
symbol2 = 'BTC-USD'; %'BTC-USD'
days = 5000;
useLog = 0;
showAll = 1;
interval = '1wk';
% supported intervals are '60m', '1d', '5d', '1wk', '1mo', '3mo'
% max value of days for 60m is 74 

main(days, useLog, showAll, interval, symbol1);