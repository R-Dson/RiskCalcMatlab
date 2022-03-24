% Used https://github.com/Lenskiy/Yahoo-Quandl-Market-Data-Donwloader/blob/master/getMarketDataViaYahoo.m
% and https://stackoverflow.com/questions/50813539/user-agent-cookie-workaround-to-web-scraping-in-matlab
function data = yahooData(symbol, startdate, enddate, interval)
    if(nargin() == 1)
            startdate = posixtime(datetime('1-Jan-2018'));
            enddate = posixtime(datetime()); % now
            interval = '1d';
        elseif (nargin() == 2)
            startdate = posixtime(datetime(startdate));
            enddate = posixtime(datetime()); % now
            interval = '1d';
        elseif (nargin() == 3)
            startdate = posixtime(datetime(startdate));
            enddate = posixtime(datetime(enddate));        
            interval = '1d';
        elseif(nargin() == 4)
            startdate = posixtime(datetime(startdate));
            enddate = posixtime(datetime(enddate));
    end
    
    url = 'https://query1.finance.yahoo.com/v8/finance/chart/';
    opts = weboptions('RequestMethod','get', 'MediaType','application/json', 'ContentType','json', 'UserAgent', 'Mozilla/5.0', 'CertificateFilename','');
    url = strcat(url, symbol, '?symbol=', symbol);

    %Construct url, add time intervals. The following url is for last month worth of data.
    url = strcat(url,'&period1=',num2str(startdate,'%.10g'),'&period2=',num2str(enddate,'%.10g'),'&interval=', interval);

    %Execute HTTP request.
    data = webread(url, opts);
    data = data.chart.result;
    Date = datetime(data.timestamp,"ConvertFrom","posixtime");
    Close = data.indicators.quote.close;
    Open = data.indicators.quote.open;
    High = data.indicators.quote.high;
    Low = data.indicators.quote.low;
    AdjClose = zeros(size(Open, 1), 1);
    Volume = data.indicators.quote.volume;
    data = table(Date, Open, High, Low, Close, AdjClose, Volume);
    data = data(1:end-1,1:end);
end

