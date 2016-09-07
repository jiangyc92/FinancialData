classdef DataCrawler < handle
    properties
        FieldName = {'Date', 'Open', 'High', 'Close', 'Low', 'Volume', 'Amount'};
        FinancialField = {
                          'DilutedEPS', ...                 % 摊薄每股收益
                          'WeightedEPS', ...                % 加权每股收益
                          'AdjustedEPS', ...                % 每股收益_调整后
                          'ExEPS', ...                      % 扣除非经常性损益后的每股收益
                          'BPS', ...                        % 每股净资产_调整前
                          'AdjustedBPS', ...                % 每股净资产_调整后
                          'CashFlowOperPS', ...             % 每股经营性现金流
                          'CapitalReservePS', ...           % 每股资本公积金
                          'UndistributedProfitPS', ...      % 每股未分配利润
                          'TAReturnRate', ...               % 总资产利润率
                          'TANetReturnRate', ...            % 总资产净利润率
                          'ProfitToCostRatio', ...          % 成本费用利润率
                          'GrossMargin', ...                % 销售毛利率
                          'ROE', ...                        % 净资产收益率
                          'WeightedROE', ...                % 加权净资产收益率
                          'IncomeFromMainOper', ...         % 主营业务利润
                          'NetProfitAfterNonRecurring', ... % 扣除非经常性损益后净利润
                          'DebtToAsset', ...                % 资产负债率
                          'TotalAsset'                      % 总资产
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