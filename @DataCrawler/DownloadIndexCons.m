function varargout = DownloadIndexCons(varargin)
% 获取指数的当前成分股
% 有如下变量可以选择：
%   Ticker: 指数代码, 6位数字组成的字符串
%   StoreFile: 如需要存储到文件的话这里写上文件名

obj = varargin{1};
if mod(nargin, 1)
    error('参数输入格式错误!');
end

Ticker = [];
StoreFile = [];
for i = 2:2:nargin-1
    if strcmp(varargin{i}, 'Ticker')
        Ticker = varargin{i+1};
    end
    if strcmp(varargin{i}, 'StoreFile')
        StoreFile = varargin{i+1};
    end
end


Url0 = 'http://vip.stock.finance.sina.com.cn/corp/go.php/vII_NewestComponent/indexid/';
Url = sprintf([Url0, '%s.phtml'], Ticker);
[Source, Status] = urlread(Url);
if ~Status
    error('获取数据失败!');
end

[Tickers, InDate] = obj.IndexConsParser(Source);


if ~isempty(StoreFile)
    DataToStore = cell(length(Tickers), 2);
    DataToStore(:,1) = Tickers;
    DataToStore(:,2) = InDate;
    ColName = {'Ticker', 'InDate'};
    obj.StoreDataToFile(DataToStore, StoreFile, ColName);
end

if nargout == 1
    IndexCons.Ticker = Ticker;
    IndexCons.Date = datenum(InDate);
    varargout{1} = StockData;
end
end