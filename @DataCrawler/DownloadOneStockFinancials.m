function varargout = DownloadOneStockFinancials(varargin)
% ��ȡ��Ʊ�Ļ���������
% �����±�������ѡ��
%   Ticker: ��Ĵ���, 6λ������ɵ��ַ���
%   BeginDate: ������ʼ���ڣ���ʽΪ'yyyy-mm-dd'
%   EndDate: ������ֹ���ڣ���ʽΪ'yyyy-mm-dd'
%   StoreFile: ����Ҫ�洢���ļ��Ļ�����д���ļ���
%   Field: cell, ��Ҫ��ȡ�Ļ���������, ��ѡ����Ӧ֮��������:
%     'DilutedEPS',                   ̯��ÿ������
%     'WeightedEPS',                  ��Ȩÿ������
%     'AdjustedEPS',                  ÿ������_������
%     'ExEPS',                        �۳��Ǿ�����������ÿ������
%     'BPS',                          ÿ�ɾ��ʲ�_����ǰ
%     'AdjustedBPS',                  ÿ�ɾ��ʲ�_������
%     'CashFlowOperPS',               ÿ�ɾ�Ӫ���ֽ���
%     'CapitalReservePS',             ÿ���ʱ�������
%     'UndistributedProfitPS',        ÿ��δ��������
%     'TAReturnRate',                 ���ʲ�������
%     'TANetReturnRate',              ���ʲ���������
%     'ProfitToCostRatio',            �ɱ�����������
%     'GrossMargin',                  ����ë����
%     'ROE',                          ���ʲ�������
%     'WeightedROE',                  ��Ȩ���ʲ�������
%     'IncomeFromMainOper',           ��Ӫҵ������
%     'NetProfitAfterNonRecurring',   �۳��Ǿ��������������
%     'DebtToAsset',                  �ʲ���ծ��
%     'TotalAsset',                   ���ʲ�

obj = varargin{1};
if mod(nargin, 1)
    error('���������ʽ����!');
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
    error('��Ҫָ��Field');
end


Url0 = ['http://money.finance.sina.com.cn/corp/view/vFD_FinancialGuideLineHistory.php?stockid=', Ticker, '&typecode=financialratios'];
if iscell(Field)
    Field = unique(Field);
    DiffFields = setdiff(Field, obj.FinancialField);
    [~, Index] = intersect(obj.FinancialField, Field);
    SINAFinancialRatioIDTmp = obj.SINAFinancialRatioID(Index);
    if ~isempty(DiffFields)
        fprintf('�����Field����֧�֣�');
        for i = 1:length(DiffField)
            fprintf('%s,\t', DiffFields{i});
        end
        fprintf('\n');
        error('���ټ��һ��!');
    end
    
    ReportDateList = obj.GetReportDate(BeginDate, EndDate);
    FieldN = length(Field);
    ReportN = length(ReportDateList);
    Data = zeros(ReportN, FieldN);
    
    % ��������ÿ��ָ��
    for i = 1:FieldN
        pause(rand() * 0.3);
        Url = [Url0, num2str(SINAFinancialRatioIDTmp(i))];
        [Source, Status] = urlread(Url);
        if ~Status
            error('��ȡ����ʧ��!');
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
    error('Field������cell�ṹ!');
end
end