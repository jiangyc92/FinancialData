function varargout = DownloadOneStockFinancials(varargin)
% 获取股票的基本面数据
% 有如下变量可以选择：
%   Ticker: 标的代码, 6位数字组成的字符串
%   BeginDate: 报告起始日期，格式为'yyyy-mm-dd'
%   EndDate: 报告终止日期，格式为'yyyy-mm-dd'
%   StoreFile: 如需要存储到文件的话这里写上文件名
%   Field: cell, 需要提取的基本面名称, 可选项及其对应之含义如下:
%     'DilutedEPS',                   摊薄每股收益
%     'WeightedEPS',                  加权每股收益
%     'AdjustedEPS',                  每股收益_调整后
%     'ExEPS',                        扣除非经常性损益后的每股收益
%     'BPS',                          每股净资产_调整前
%     'AdjustedBPS',                  每股净资产_调整后
%     'CashFlowOperPS',               每股经营性现金流
%     'CapitalReservePS',             每股资本公积金
%     'UndistributedProfitPS',        每股未分配利润
%     'TAReturnRate',                 总资产利润率
%     'TANetReturnRate',              总资产净利润率
%     'ProfitToCostRatio',            成本费用利润率
%     'GrossMargin',                  销售毛利率
%     'ROE',                          净资产收益率
%     'WeightedROE',                  加权净资产收益率
%     'IncomeFromMainOper',           主营业务利润
%     'NetProfitAfterNonRecurring',   扣除非经常性损益后净利润
%     'DebtToAsset',                  资产负债率
%     'TotalAsset',                   总资产

obj = varargin{1};
if mod(nargin, 1)
    error('参数输入格式错误!');
end

StoreFile = [];
Field = [];
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
    if strcmp(varargin{i}, 'StoreFile')
        StoreFile = varargin{i+1};
    end
    if strcmp(varargin{i}, 'Field')
        Field = varargin{i+1};
    end
end

if isempty(Field)
    error('需要指出Field');
end


Url0 = ['http://money.finance.sina.com.cn/corp/view/vFD_FinancialGuideLineHistory.php?stockid=', Ticker, '&typecode=financialratios'];
if iscell(Field)
    Field = unique(Field);
    DiffFields = setdiff(Field, obj.FinancialField);
    [~, Index] = intersect(obj.FinancialField, Field);
    SINAFinancialRatioIDTmp = obj.SINAFinancialRatioID(Index);
    if ~isempty(DiffFields)
        fprintf('下面的Field并不支持：');
        for i = 1:length(DiffField)
            fprintf('%s,\t', DiffFields{i});
        end
        fprintf('\n');
        error('请再检查一遍!');
    end
    
    ReportDateList = obj.GetReportDate(BeginDate, EndDate);
    FieldN = length(Field);
    ReportN = length(ReportDateList);
    Data = zeros(ReportN, FieldN);
    
    % 依次下载每个指标
    for i = 1:FieldN
        pause(rand() * 0.3);
        Url = [Url0, num2str(SINAFinancialRatioIDTmp(i))];
        [Source, Status] = urlread(Url);
        if ~Status
            error('获取数据失败!');
        end
        Financials = obj.FinancialDataParser(Source, ReportDateList);
        Data(:, i) = Financials;
    end
    
    if nargout == 1
        for i = 1:FieldN
            varargout{1}.(Field{i}) = Data(:, i);
        end
        varargout{1}.ReportPeriod = ReportDateList;
    end
    
    if ~isempty(StoreFile)
        DataToStore = cell(length(ReportDateList), FieldN + 1);
        DataToStore(:, 1) = mat2cell(datestr(ReportDateList, 'yyyy-mm-dd'), ones(ReportN, 1), 10);
        for i = 1:FieldN
            DataToStore(:, i + 1) = num2cell(Data(:, i));
        end
        ColName = cell(1, FieldN + 1);
        ColName{1} = 'Period';
        ColName(2:end) = Field;
        obj.StoreDataToFile(DataToStore, StoreFile, ColName);
    end
    
else
    error('Field必须是cell结构!');
end
end