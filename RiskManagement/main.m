function main(days, useLog, showAll, interval, symbol1, symbol2)
    is60m = 0;
    if(contains(interval, "m") && ~contains(interval, "mo"))
        is60m = 1;
        initDate = '05-May-2020';
        days = days * 24;
    else
        initDate = '05-May-1991';
    end
    is1wk = 0;
    if (contains(interval, '1wk'))
        is1wk = 1;
    end
    switch nargin
        case 5
            cData = yahooData(symbol1, initDate, datetime('today'), interval);
            
            disp(append('Request historical YTD price for ', symbol1));
            max = size(cData, 1);
            if (days > max-1)
                days = max-1;
            end
            cData = cData(~any(ismissing(cData),2),:);
            UseData(cData, is60m, cData.Close, round(days), useLog, showAll, symbol1, -1, is1wk);
            
        case 6
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
            UseData(cData1, is60m, cData, round(days), useLog, showAll, symbol1, symbol2, is1wk);
    end
    
    disp('Done.');
end

function UseData(data, is60m, closeData, n, useLog, showAll, symbol1, symbol2, is1wk)
% data, how many data points and if to use log (1 is yes, 0 is no)

    [pr, r50O20W, r50d50w, pO50W, pO200W, lnp20w, risk] = RiskCalc(data.Close, is60m, is1wk);
    dates = data.Date;
    
    inData = closeData;
    if(useLog == 1)
        inData = log10(closeData);
    end
%     if(showAll == 1)
%         tiledlayout(2,8)
%     else
%         tiledlayout(2,1)
%     end
    
    if(pr ~= -1)
        plotData(n, useLog, pr, dates, inData, symbol1, symbol2);
        title('Combinations', 'Color', 'w')
    end
   
    figure
    if (showAll == 1)
        if(r50O20W ~= -1)
            plotData(n, useLog, r50O20W, dates, inData, symbol1, symbol2);
            title('50 days / 20 weeks', 'Color', 'w')
        end
        if(r50d50w ~= -1)
            plotData(n, useLog, r50d50w, dates, inData, symbol1, symbol2);
            title('50 day / 50 week average', 'Color', 'w')
        end
        if(risk ~= -1)
            plotData(n, useLog, risk, dates, inData, symbol1, symbol2);
            title('20 day MA / 50 week MA (350 days)', 'Color', 'w')
        end
        if(pO50W ~= -1)
            figure
            plotData(n, useLog, pO50W, dates, inData, symbol1, symbol2);
            title('price / 50 weeks', 'Color', 'w')
        end
        if (pO200W ~= -1)
            plotData(n, useLog, pO200W, dates, inData, symbol1, symbol2);
            title('price / 200 weeks', 'Color', 'w')
        end
        if (lnp20w ~= -1)
            figure
            lnp20w(lnp20w > 0) = 1;
            lnp20w(lnp20w < 0) = 0;
            plotData(n, useLog, lnp20w, dates, inData, symbol1, symbol2);
            title('log10(price / 50 weeks)', 'Color', 'w')
            %coltab = zeros(length(lnp20w), 3);

        %     
        %     
        %     rowsToSetBlue = lnp20w == 1;
        %     rowsToSetRed = lnp20w == -1;
        %     
        %     coltab(rowsToSetBlue, :) = ones(sum(rowsToSetBlue), 3).*[0,0,0];
        %     coltab(rowsToSetRed, :) = ones(sum(rowsToSetRed), 3).*[0,0,0];
    
%             plotData(n, useLog, coltab, dates, inData, symbol1, symbol2);
%             title('log10(price / 20 weeks)', 'Color', 'w')
        end
    end
    
%     if(priceRisk ~= -1)
%         plotData(n, useLog, risk, dates, inData, symbol1, symbol2);
%         title('50 day / 20 week moving average (140 days)', 'Color', 'w')
%     end
end

function plotData(n, useLog, data1, data2, data3, symbol1, symbol2)
    if (n > size(data1, 1))
        n = size(data1, 1);
    end
nexttile
    data1 = data1(end-n+1:end);
    data2 = data2(end-n+1:end);
    data3 = data3(end-n+1:end);
    if(useLog == 1)
        minValue = min(data3);
        ylim([0 abs(minValue)*1.25])
    else
        maxValue = max(data3);
        ylim([0 maxValue*1.25])
    end
%     nexttile
    Plots(useLog, symbol1, symbol2, data2, data3, data1);
    hold on;
end