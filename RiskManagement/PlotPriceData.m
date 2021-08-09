function PlotPriceData(AllData, ShowMA, ShowPriceDiv, ShowLogOver20Week, useLog)
% data, how many data points and if to use log (1 is yes, 0 is no)
    n = round(AllData{3});
    closeData = AllData{2};
    data = AllData{1};
    symbol1 = AllData{4};
    symbol2 = AllData{5};
    interval = AllData{6};
    is60m = 0;
    if(contains(interval, "m") && ~contains(interval, "mo"))
        is60m = 1;
    end
    
    is1wk = 0;
    if (contains(interval, '1wk'))
        is1wk = 1;
    end

    [pr, r50O20W, r50d50w, pO50W, pO200W, lnp20w, risk] = RiskCalc(closeData, is60m, is1wk);
    dates = data.Date;
    
    inData = closeData;
    if(useLog == 1)
        inData = log10(closeData);
    end
    
    if(pr ~= -1)
        plotData(n, useLog, pr, dates, inData, symbol1, symbol2, 'Combinations');
    end
    
    if(ShowMA == 1)
        if(r50O20W ~= -1)
            plotData(n, useLog, r50O20W, dates, inData, symbol1, symbol2, '50 days / 20 weeks');
        end
        
        if(r50d50w ~= -1)
            plotData(n, useLog, r50d50w, dates, inData, symbol1, symbol2, '50 day / 50 week average');
        end
        
        if(risk ~= -1)
            plotData(n, useLog, risk, dates, inData, symbol1, symbol2, '20 day MA / 50 week MA (350 days)');
        end
    end
    
    if(ShowPriceDiv == 1)
        figure
        if(pO50W ~= -1)
            plotData(n, useLog, pO50W, dates, inData, symbol1, symbol2, 'price / 50 weeks');
        end
        
        if (pO200W ~= -1)
            plotData(n, useLog, pO200W, dates, inData, symbol1, symbol2, 'price / 200 weeks');
        end
    end
    
    if (ShowLogOver20Week == 1)
        if (lnp20w ~= -1)
            figure
            lnp20w(lnp20w > 0) = 1;
            lnp20w(lnp20w < 0) = 0;
            plotData(n, useLog, lnp20w, dates, inData, symbol1, symbol2, 'log10(price / 50 weeks)');
        end
    end
end

function plotData(n, useLog, data1, data2, data3, symbol1, symbol2, PlotTitle)
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
    
    Plots(useLog, symbol1, symbol2, data2, data3, data1);
    hold on;
    title(PlotTitle, 'Color', 'w')
end