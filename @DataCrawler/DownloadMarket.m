function varargout = DownloadMarket(varargin)
% �������ɹ�Ʊ����ָ�������������ݣ��������������������: Universe, BeginDate, EndDate
% Universe����ʾ���صĹ�Ʊ�أ�������cell��ϣ�����Universe = {'000001', '600000'}
%           Ҳ������һ��ָ��������Universe = '000050'�����Universe��ָ��ticker����
%           ��ʾ�����ع�ƱΪ��ָ���ɷֹɣ�����ֻ���������³ɷֹ�ָ����
% BeginDate: ��ʼ�գ���ʽΪ'yyyy-mm-dd'
% EndDate����ֹ�գ���ʽΪ'yyyy-mm-dd'
% ���²���Ϊ��ѡ
% StoreDir���洢�ļ��У����������������ݻᱻ�洢�����ļ����£���������Ϊticker.xlsx
% Type�������Ҫ���ص�Ϊָ�����飬����������ҵָ���������Universe�е�tickerΪָ��ticker�⣬
%       Type����ָ��Ϊ'I'

obj = varargin{1};
if mod(nargin, 1)
    error('���������ʽ����!');
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
    error('Universe��ʽ����');
end

% ������ַ�������ʽ����Ĭ��Universe��ʾĳ��ָ��
% ѡ�ɳ�Ϊ��ָ���ɷ֣���ʱUniverse��ָ��6λ����
% ticker
if UniverseFlag == 1
    IndexCons = obj.DownloadIndexCons('Ticker', Universe);
    Universe = IndexCons.Ticker;
end
N = length(Universe);

% ��ʼ��
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