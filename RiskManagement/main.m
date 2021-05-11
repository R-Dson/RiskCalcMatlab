function main(days, useLog, interval, symbol1, symbol2)

    if(contains(interval, "m") && ~contains(interval, "mo"))
        initDate = '05-May-2020';
        days = days * 24;
    else
        initDate = '05-May-2001';
    end
    
    switch nargin
        
        case 4
            cData = yahooData(symbol1, initDate, datetime('today'), interval);
            
            disp(append('Request historical YTD price for ', symbol1));
            max = size(cData, 1);
            if (days > max-1)
                days = max-1;
            end
            cData = cData(~any(ismissing(cData),2),:);
            UseData(cData, cData.Close, round(days), useLog, symbol1, -1);
            
        case 5
            cData1 = yahooData(symbol1, initDate, datetime('today'), interval);
            disp(append('Request historical YTD price for ', symbol1));
            cData2 = yahooData(symbol2, initDate, datetime('today'), interval);
            disp(append('Request historical YTD price for ', symbol2));

            cData1 = cData1(~any(ismissing(cData1),2),:);
            max = min([size(cData1, 1) size(cData2, 1)]);
            if (days > max)
                days = max;
            end
            d1 = cData1.Close(end-max+1:end);
            d2 = cData2.Close(end-max+1:end);
            cData =  d1./ d2;
            UseData(cData1, cData, round(days), useLog, symbol1, symbol2);
    end
    
    disp('Done.');
end

function UseData(data, closeData, n, useLog, symbol1, symbol2)
% data, how many data points and if to use log (1 is yes, 0 is no)

    [risk, priceRisk] = RiskCalc(data.Close);
    dates = data.Date;
    
    inData = closeData;
    if(useLog == 1)
        inData = log10(closeData);
    end
    
    if(risk ~= -1)
        plotData(n, useLog, risk, dates, inData, symbol1, symbol2);
        title('50 day MA / 50 week MA (350 days)', 'Color', 'w')
    end
    
%     if(priceRisk ~= -1)
%         plotData(n, useLog, risk, dates, inData, symbol1, symbol2);
%         title('50 day / 20 week moving average (140 days)', 'Color', 'w')
%     end
end

function plotData(n, useLog, data1, data2, data3, symbol1, symbol2)
    data1 = data1(end-n+1:end);
    data2 = data2(end-n+1:end);
    data3 = data3(end-n+1:end);
    if(useLog == 1)
        minValue = min(data3);
        %ylim([0 abs(minValue)*1.25])
    else
        maxValue = max(data3);
        %ylim([0 maxValue*1.25])
    end
    nexttile
    Plots(useLog, symbol1, symbol2, data2, data3, data1);
    hold on;
end