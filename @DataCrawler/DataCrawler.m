classdef DataCrawler < handle
  
    methods
        [Years, Seasons] = GetSeasons(obj, BeginDate, EndDate);
        [Date, Data] = MarketDataParser(obj, Source, FuQuan);
        [Tickers, InDate] = IndexConsParser(obj, Source);
        StoreDataToFile(obj, DataToStore, StoreFile, ColName);
        DownloadMarket(varargin);
        DownloadFundamentals(varargin);
        DownloadOneStockMarketQuotes(varargin);
        DownladOneStockFundamentals(varargin);
        DownloadIndexCons(varargin);
    end
end