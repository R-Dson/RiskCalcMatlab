function [allData] = main(interval, symbol1, symbol2)
    days = 5000;
    if(contains(interval, "m") && ~contains(interval, "mo"))
        initDate = '05-May-2020';
        days = days * 24;
    else
        initDate = '05-May-1991';
    end
    
    switch nargin
        case 2
            cData = yahooData(symbol1, initDate, datetime('today'), interval);
            
            disp(append('Request historical YTD price for ', symbol1));
            max = size(cData, 1);
            if (days > max-1)
                days = max-1;
            end
            cData = cData(~any(ismissing(cData),2),:);
            close = cData.Close;
            symbol2 = -1;
        case 3
            cData = yahooData(symbol1, initDate, datetime('today'), interval);
            disp(append('Request historical YTD price for ', symbol1));
            cData2 = yahooData(symbol2, initDate, datetime('today'), interval);
            disp(append('Request historical YTD price for ', symbol2));

            cData = cData(~any(ismissing(cData),2),:);
            max = min([size(cData, 1) size(cData2, 1)]);
            
            if (days > max)
                days = max;
            end
            
            d1 = cData.Close(end-max+1:end);
            d2 = cData2.Close(end-max+1:end);
            cData =  d1./ d2;
    end
    allData = {cData, close, days, symbol1, symbol2, interval};
    disp('Done.');
end