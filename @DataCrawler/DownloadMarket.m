function varargout = DownloadMarket(varargin)
% 下载若干股票（或指数）的行情数据，必须给定至少三个参数: Universe, BeginDate, EndDate
% Universe：表示下载的股票池，可以是cell组合，比如Universe = {'000001', '600000'}
%           也可以是一个指数，比如Universe = '000050'，如果Universe是指数ticker，则
%           表示待下载股票为该指数成分股（现在只能下载最新成分股指数）
% BeginDate: 起始日，格式为'yyyy-mm-dd'
% EndDate：终止日，格式为'yyyy-mm-dd'
% 以下参数为可选
% StoreDir：存储文件夹，所有下载行情数据会被存储至该文件加下，命名规则为ticker.xlsx
% Type：如果需要下载的为指数行情，比如若干行业指数，则除了Universe中的ticker为指数ticker外，
%       Type还需指定为'I'

obj = varargin{1};
if mod(nargin, 1)
    error('参数输入格式错误!');
end

Universe = [];
FuQuan = false;
BeginDate = [];
EndDate = [];
StoreDir = [];
Type = 'S';
for i = 2:2:nargin-1
    if strcmp(varargin{i}, 'Universe')
        Universe = varargin{i+1};
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
    if strcmp(varargin{i}, 'StoreDir')
        StoreDir = varargin{i+1};
    end
    if strcmp(varargin{i}, 'Type')
        Type = varargin{i+1};
    end
end

UniverseFlag = 0;

if ischar(Universe)
    UniverseFlag = 1;
elseif iscell(Universe)
    UniverseFlag = 2;
end

if ~UniverseFlag
    error('Universe格式错误！');
end

% 如果是字符串的形式，则默认Universe表示某个指数
% 选股池为该指数成分，此时Universe是指数6位数的
% ticker
if UniverseFlag == 1
    IndexCons = obj.DownloadIndexCons('Ticker', Universe);
    Universe = IndexCons.Ticker;
end
N = length(Universe);

% 初始化
if nargout == 1
    DateNum = EndDate - BeginDate;
    varargout{1}.Ticker = cell((DateNum + 1) * N, 1);
    for i = 1:7
        varargout{1}.(obj.FieldName{i}) = zeros((DateNum + 1) * N, 1);
    end
    if FuQuan
        varargout{1}.AdjFactor = zeros((DateNum + 1) * N, 1);
    end
end

Row = 0;
for i = 1:N
    Ticker = Universe{i};
    
    if isempty(StoreDir)
        StoreFile = [];
    else
        if ~exist(StoreDir, 'dir')
            mkdir(StoreDir);
        end
        StoreFile = [StoreDir, '/', Ticker, '.xlsx'];
    end
    if nargout == 1
        Data = obj.DownloadOneStockMarketQuotes('Ticker', Ticker, 'BeginDate', BeginDate, ...
            'EndDate', EndDate, 'FuQuan', FuQuan, 'StoreFile', StoreFile, 'Type', Type);
        M = length(Data.Date);
        FieldName0 = fieldnames(Data);
        for j = 1:length(FieldName0)
            varargout{1}.(FieldName0{j})(Row+1:Row+M) = Data.(FieldName0{j});
        end
        varargout{1}.Ticker(Row+1:Row+M) = repmat({Ticker}, M, 1);
        Row = Row + M;
    else
        obj.DownloadOneStockMarketQuotes('Ticker', Ticker, 'BeginDate', BeginDate, ...
            'EndDate', EndDate, 'FuQuan', FuQuan, 'StoreFile', StoreFile, 'Type', Type);
    end    
end

if nargout == 1
    FieldName0 = fieldnames(varargout{1});
    for i = 1:length(FieldName0)
        varargout{1}.(FieldName0{i}) = varargout{1}.(FieldName0{i})(1:Row);
    end
end
end