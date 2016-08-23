function varargout = DownloadOneStockMarketQuotes(varargin)

obj = varargin{1};
if mod(nargin, 1)
    error('���������ʽ����!');
end

Ticker = [];
BeginDate = [];
EndDate = [];
FuQuan = false;
StoreFile = [];

for i = 2:2:nargin-1
    if strcmp(varargin{i}, 'Ticker')
        Ticker = varargin{i+1};
    end
    if strcmp(varargin{i}, 'BeginDate')
        BeginDate = datenum(varargin{i+1});
    end
    if strcmp(varargin{i}, 'EndDate')
        EndDate = datenum(varargin{i+1});
    end
    if strcmp(varargin{i}, 'FuQuan')
        FuQuan = varargin{i+1};
    end
    if strcmp(varargin{i}, 'StoreFile')
        StoreFile = varargin{i+1};
    end
end

if FuQuan
    FuncStr = 'vMS_FuQuanMarketHistory';
else
    FuncStr = 'vMS_MarketHistory';
end

Url0 = ['http://vip.stock.finance.sina.com.cn/corp/go.php/', FuncStr, '/stockid/', ...
        Ticker, '/all.phtml?'];

[Years, Seasons] = obj.GetSeasons(BeginDate, EndDate);
N0 = EndDate - BeginDate + 1;
N = length(Years);
RowN = 0;

Date = cell(N0, 1);
if FuQuan
    Data = zeros(N0, 7);
else
    Data = zeros(N0, 6);
end

for i = 1:N
    Url = sprintf([Url0, 'year=%d&jidu=%d'], Years(i), Seasons(i));
    pause(rand() * 0.3);
    [Source, Status] = urlread(Url);
    if ~Status
        error('��ȡ����ʧ��!');
    end
    [Date0, Data0] = obj.MarketDataParser(Source, FuQuan);
    if i == 1
        DateNumList = datenum(Date0);
        Index = DateNumList >= BeginDate;
        Date0 = Date0(Index);
        Data0 = Data0(Index, :);
    end
    
    if i == N
        DateNumList = datenum(Date0);
        Index = DateNumList <= EndDate;
        Date0 = Date0(Index);
        Data0 = Data0(Index, :);
    end
    
    Date0 = Date0(end:-1:1);
    Data0 = Data0(end:-1:1, :);
    N0 = length(Date0);
    Date(RowN+1:RowN+N0) = Date0;
    Data(RowN+1:RowN+N0, :) = Data0;
    RowN = RowN + N0;   
end

Data = Data(1:RowN, :);
Date = Date(1:RowN);


if ~isempty(StoreFile)
    DataToStore = cell(RowN, size(Data,2) + 1);
    DataToStore(:,1) = Date;
    DataToStore(:,2:end) = num2cell(Data);
    ColName = {'Date', 'Open', 'High', 'Close', 'Low', 'Volume', 'Amount', 'AdjFactor'};
    if ~FuQuan
        ColName = ColName(1:7);
    end
    obj.StoreDataToFile(DataToStore, StoreFile, ColName);
end

if nargout == 1
    StockData.Date = datenum(Date);
    StockData.Open = Data(:,1);
    StockData.High = Data(:,2);
    StockData.Close = Data(:,3);
    StockData.Low = Data(:,4);
    StockData.Volume = Data(:,5);
    StockData.Amount = Data(:,6);
    if FuQuan
        StockData.AdjFactor = Data(:,7);
    end
    varargout{1} = StockData;
end
end