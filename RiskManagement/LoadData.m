clc
clear

% changable, minimum days i 350
symbol1 = 'AMD'; %'ETH-USD'
symbol2 = 'BTC-USD'; %'BTC-USD'
days = 30*3;
useLog = 0;
interval = '1d';
% supported intervals are '60m', '1d', '5d', '1wk', '1mo', '3mo'
% max value of days for 60m is 74 

main(days, useLog, interval, symbol1);