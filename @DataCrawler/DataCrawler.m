classdef DataCrawler < handle
    properties
        FieldName = {'Date', 'Open', 'High', 'Close', 'Low', 'Volume', 'Amount'};
        FinancialField = {
                          'DilutedEPS', ...                 % ̯��ÿ������
                          'WeightedEPS', ...                % ��Ȩÿ������
                          'AdjustedEPS', ...                % ÿ������_������
                          'ExEPS', ...                      % �۳��Ǿ�����������ÿ������
                          'BPS', ...                        % ÿ�ɾ��ʲ�_����ǰ
                          'AdjustedBPS', ...                % ÿ�ɾ��ʲ�_������
                          'CashFlowOperPS', ...             % ÿ�ɾ�Ӫ���ֽ���
                          'CapitalReservePS', ...           % ÿ���ʱ�������
                          'UndistributedProfitPS', ...      % ÿ��δ��������
                          'TAReturnRate', ...               % ���ʲ�������
                          'TANetReturnRate', ...            % ���ʲ���������
                          'ProfitToCostRatio', ...          % �ɱ�����������
                          'GrossMargin', ...                % ����ë����
                          'ROE', ...                        % ���ʲ�������
                          'WeightedROE', ...                % ��Ȩ���ʲ�������
                          'IncomeFromMainOper', ...         % ��Ӫҵ������
                          'NetProfitAfterNonRecurring', ... % �۳��Ǿ��������������
                          'DebtToAsset', ...                % �ʲ���ծ��
                          'TotalAsset'                      % ���ʲ�
                          };
        SINAFinancialRatioID = [
                                40, ...
                                61, ...
                                53, ...
                                64, ...
                                85, ...
                                54, ...
                                55, ...
                                63, ...
                                66, ...
                                26, ...
                                28, ...
                                29, ...
                                36, ...
                                59, ...
                                62, ...
                                57, ...
                                65, ...
                                56, ...
                                58
                               ];
    end
    methods
        [Years, Seasons] = GetSeasons(obj, BeginDate, EndDate);
        ReportDateList = GetReportDate(obj, BeginDate, EndDate);
        [Date, Data] = MarketDataParser(obj, Source, FuQuan);
        [Tickers, InDate] = IndexConsParser(obj, Source);
        StoreDataToFile(obj, DataToStore, StoreFile, ColName);
        varargout = DownloadMarket(varargin);
        varargout = DownloadFundamentals(varargin);
        varargout = DownloadOneStockMarketQuotes(varargin);
        varargout = DownladOneStockFundamentals(varargin);
        varargout = DownloadIndexCons(varargin);
        varargout = DownloadOneStockFinancials(varargin);
    end
end