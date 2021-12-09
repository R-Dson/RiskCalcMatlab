function [pr, r50O20W, r50d50w, pO50W, pO200W, pO20W, lnp20w, risk, movingAverage] = RiskCalc(data, is60m, is1wk)
%returns risk, the average over 50 days divided by 350 days (normalizd by
%timeframe). returns priceRisk, the current price divided by the 20 week
%average, normalized by timeframe. Data needs to be >= 350
    r50O20W = -1;
    r50d50w = -1;
    risk = -1;
    pO200W = -1;
    pO50W = -1;
    lnp20w = -1;
    pO20W = -1;
    dataSize = size(data, 1);
%     if(size(data) < 350)
%         pr = -1;
%         r50O20W = -1;
%         r50d50w = -1;
%         risk = -1;
%         pO200W = -1;
%         pO50W = -1;
%         lnp20w = -1;
%         pO20W = -1;
%         movingAverage.ma20WeeksInDays = -1;
%         movingAverage.ma50Day = -1;
%         movingAverage.ma350Day = -1;
%         movingAverage.ma1400Day = -1;
%         B=arrayfun(@num2str,size(data, 1),'un',0);
%         disp(append('Not enough data. Data size: ', B{1,1}, '. Needs to be atleast 350.' ));
%         return
%     end
    
    P = 0.3450;
    
    if (is1wk == 0)
        windowSize20Weeks = 140;
        windowSize50Day = 50;
        windowSize350Day = 350;
        windowSize1400Day = 1400;
    end
    if (is1wk == 1)
        windowSize20Weeks = 140/7;
        windowSize50Day = 50/7;
        windowSize350Day = 350/7;
        windowSize1400Day = 1400/7;
    end
    if dataSize > windowSize50Day
        ma50Day = movmean(data, windowSize50Day);
    else
        ma50Day = 0;
    end
    if dataSize > windowSize350Day
        ma20WeeksInDays = movmean(data, windowSize20Weeks);
    else
        ma20WeeksInDays = 0;
    end
    if dataSize > windowSize350Day
        ma350Day = movmean(data, windowSize350Day);
    else
        ma350Day = 0;
    end
    if dataSize > windowSize1400Day
        ma1400Day = movmean(data, windowSize1400Day); % 200 weeks
    else
        ma1400Day = 0;
    end    
    
    % 50 days over 20 week average
    if dataSize > windowSize50Day && dataSize > windowSize350Day
        r50O20W = ma50Day ./ ma20WeeksInDays;
    end
    
    if dataSize > windowSize50Day && dataSize > windowSize350Day
        r50d50w = ma50Day ./ ma350Day;
    end
    % 50 day over 50 week average
    
    if dataSize > windowSize350Day && dataSize > windowSize350Day
        risk = ma20WeeksInDays ./ ma350Day;
    end
    % 20 day over 50 week average
    
    
    if dataSize > windowSize350Day
        pO50W = data ./ ma350Day;
    end
    % price over 50 week average
    
    if dataSize > windowSize1400Day
        pO200W = data ./ ma1400Day;
    end
    % prive over 200 week average
    
    if dataSize > windowSize350Day
        pO20W = data ./ ma20WeeksInDays;
        lnp20w = log10(pO20W);
    end
    %
    
    
    % combining these
    pr = r50O20W .* (P) + risk .*(P) + (r50d50w .*(1 - 2*P - 0.1*P - 0.15*P)) + pO200W.*(P*0.1) + pO50W.*(P*0.15);
    %pr =  r50d50w.* (2*P) + risk .*(P) +  r50O20W.*(1 -2*P -P);
    %pr =  r50d50w %.* (2*P) + risk .*(1-2*P);

    
    % this is also pretty good
    P = 3/4;
    pr = risk .*( P) + pO50W * (1-P);
    
    pr = normalizes(pr, is60m);
    pr = normalize(pr, 'range');
    r50O20W = normalize(r50O20W, 'range');
    r50d50w = normalize(r50d50w, 'range');
    risk = normalize(risk, 'range');
    
    movingAverage.ma20WeeksInDays = ma20WeeksInDays;
    movingAverage.ma50Day = ma50Day;
    movingAverage.ma350Day = ma350Day;
    movingAverage.ma1400Day = ma1400Day;
end

function normal = normalizes(data, is60m)
    value = 0;
    l = size(data, 1);
    c = 1;
    for i = 1:l
        rv = data(i);
        if rv > value
            value = rv;
            c = 1;
        end
        if (is60m == 1)
            c = c*(1-1e-7);
        else
            %c = c*(1-1.5*10^(-7));
            c = c - (2)*10^(-7.8);
        end
        value = value * c;
        data(i) = data(i)/value;
    end
    normal = data;
end