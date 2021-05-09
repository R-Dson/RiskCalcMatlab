function [pr, r50O20W] = RiskCalc(data)
%returns risk, the average over 50 days divided by 350 days (normalizd by
%timeframe). returns priceRisk, the current price divided by the 20 week
%average, normalized by timeframe. Data needs to be >= 350

    if(size(data) < 350)
        pr = -1;
        r50O20W = -1;
        B=arrayfun(@num2str,size(data, 1),'un',0);
        disp(append('Not enough data. Data size: ', B{1,1}, '. Needs to be atleast 350.' ));
        return
    end
    
    P = 0.1250;
    
    windowSize20Weeks = 140;
    windowSize50Day = 50;
    windowSize350Day = 350;
    
    ma50Day = movmean(data, windowSize50Day);
    ma20WeeksInDays = movmean(data, windowSize20Weeks);
    ma350Day = movmean(data, windowSize350Day);
    
    % 50 days over 20 week average
    r50O20W = ma50Day ./ ma20WeeksInDays;
    r50O20W = normalizes(r50O20W);
    
    % 50 day over 50 week average
    r50d50w = ma50Day ./ ma350Day;
    r50d50w = normalizes(r50d50w);
    
    % 20 day over 50 week average
    risk = ma20WeeksInDays./ma350Day;
    risk = normalizes(risk);
    
    % combining these
    pr = r50O20W .* P + risk .* P + (r50d50w .* (1-2*P));
    pr = normalizes(pr);
    
    pr = normalize(pr, 'range');
    r50O20W = normalize(r50O20W, 'range');
end

function normal = normalizes(data)
    value = 0;
    l = size(data, 1);
    c = 1;
    for i = 1:l
        rv = data(i);
        if rv > value
            value = rv;
            c = 1;
        end
        data(i) = data(i)/value;
        c = c - (2)*10^(-9);
        value = value * c;
    end
    normal = data;
end