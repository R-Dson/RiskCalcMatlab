function [pr, r50O20W] = RiskCalc(data, is60m)
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
    
    P = 0.3450;
    
    windowSize20Weeks = 140;
    windowSize50Day = 50;
    windowSize350Day = 350;
    
    ma50Day = movmean(data, windowSize50Day);
    ma20WeeksInDays = movmean(data, windowSize20Weeks);
    ma350Day = movmean(data, windowSize350Day);
    
    % 50 days over 20 week average
    r50O20W = ma50Day ./ ma20WeeksInDays;
    
    % 50 day over 50 week average
    r50d50w = ma50Day ./ ma350Day;
    
    % 20 day over 50 week average
    risk = ma20WeeksInDays./ma350Day;
    
    % combining these
    pr = r50O20W .* (P) + risk .*(P) + (r50d50w .*(1-2*P) );
    %pr = r50d50w;
    
    pr = normalizes(pr, is60m);
    pr = normalize(pr, 'range');
    r50O20W = normalize(r50O20W, 'range');
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
            c = c*(1-5*10^(-6.8));
            %c = c - (5)*10^(-6.8);
        end
        value = value * c;
        data(i) = data(i)/value;
    end
    normal = data;
end