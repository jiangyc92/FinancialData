classdef DataCrawler < handle
    properties
        Universe
    end
    
    methods
        [Years, Seasons] = GetSeasons(obj, BeginDate, EndDate);
        [Date, Data] = MarketDataParser(obj, Source, FuQuan);
        DownloadMarket(varargin);
        DownloadFundamental(varargin);
        DownloadOneStockMarket(varargin);
        DownladOneStockFundamental(varargin);
    end
end