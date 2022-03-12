function [pr, r50O20W, r50d50w, pO50W, pO200W, pO20W, lnp20w, risk, movingAverage, ROI, fitdata] = RiskCalc(data, datalog, is60m, is1wk)
%returns risk, the average over 50 days divided by 350 days (normalizd by
%timeframe). returns priceRisk, the current price divided by the 20 week
%average, normalized by timeframe. Data needs to be >= 350
    r50O20W = 0;
    r50d50w = 0;
    risk = 0;
    pO200W = 0;
    pO50W = 0;
    lnp20w = 0;
    pO20W = 0;
    ROI.Y1 = 0;
    ROI.Y2 = 0;
    ROI.Y3 = 0;
    ROI.Y4 = 0;
    ROI.Y5 = 0;
    dataSize = size(data, 1);
    x = linspace(1,dataSize, dataSize)';
    fitdata.f.a = NaN;
    windowSize20 = 20;
    
    delta = 365;
    if dataSize > delta
        ROI.Y1 = log10(CalcROI(data, delta));
    end
    if dataSize > delta
    end
    if dataSize > 2*delta
        ROI.Y2 = log10(CalcROI(data, delta*2));
    end
    if dataSize > 3*delta
        ROI.Y3 = log10(CalcROI(data, delta*3));
    end
    if dataSize > 4*delta
        ROI.Y4 = log10(CalcROI(data, delta*4));
    end
    if dataSize > 5*delta
        ROI.Y5 = log10(CalcROI(data, delta*5));
    end
    
    %

%     y = data;
%     myfit = fittype('a + b*log(x)',...
%     'dependent',{'y'},'independent',{'x'},...
%     'coefficients',{'a','b'});
%     fitdata.f = fit(x, log(y), myfit);
%     fitdata.x = x;
%     fitdata.y = fitdata.f.a + fitdata.f.b * log(x);
    
    %
    
    P = 1/3;
    
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
        ma50Day = movmean(datalog, windowSize50Day);
    else
        ma50Day = 0;
    end
    if dataSize > windowSize350Day
        ma20WeeksInDays = movmean(datalog, windowSize20Weeks);
    else
        ma20WeeksInDays = 0;
    end
    if dataSize > windowSize350Day
        ma350Day = movmean(datalog, windowSize350Day);
    else
        ma350Day = 0;
    end
    if dataSize > windowSize1400Day
        ma1400Day = movmean(datalog, windowSize1400Day); % 200 weeks
    else
        ma1400Day = 0;
    end
    if dataSize > windowSize20
        movingAverage.ma20 = movmean(datalog, windowSize20);
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
    % price over 200 week average
    
    if dataSize > windowSize350Day
        pO20W = data ./ ma20WeeksInDays;
        lnp20w = log10(pO20W);
    end
    
    if dataSize > 20
        movingAverage.std = movstd(datalog, 20); 
        movingAverage.ma20std = movingAverage.ma20 + 1.5.*movingAverage.std;
        movingAverage.ma20mstd = movingAverage.ma20 - 1.5.*movingAverage.std;
    else
        movingAverage.std = 0;
        movingAverage.ma20mstd = 0;
        movingAverage.ma20std = 0;
    end
    %
    
    % combining these
    pr = r50O20W .* (P) + risk .*(P) + (r50d50w .*(1 - 2*P - 0.1*P - 0.15*P)) + pO200W.*(P*0.1) + pO50W.*(P*0.15);
    %pr =  r50d50w.* (2*P) + risk .*(P) +  r50O20W.*(1 -2*P -P);
    %pr =  r50d50w %.* (2*P) + risk .*(1-2*P);

    
    % this is also pretty good
%     P = 3/4;
%     pr = risk .*( P) + pO50W * (1-P);

    if r50O20W == 0
        r50O20W = -1;
    end
    if r50d50w == 0
        r50d50w = -1;
    end
    if risk == 0
        risk = -1;
    end
    if pO200W == 0
        pO200W = -1;
    end
    if pO50W == 0
        pO50W = -1;
    end
    if lnp20w == 0
        lnp20w = -1;
    end
    if pO20W == 0
        pO20W = -1;
    end
    
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

function ROI = CalcROI(data, delta)
    ROI = data(delta+1:end) ./ data(1:end-delta) ;
end