dc = DataCrawler();
Ticker = '000001';
BeginDate = '2005-01-01';
EndDate = '2016-03-31';

%dc.DownloadOneStockMarketQuotes('Ticker', Ticker, 'BeginDate', BeginDate, 'EndDate', EndDate, 'StoreFile', 'test.xlsx');

%Universe = '000050';

%Data = dc.DownloadMarket('Universe', Universe, 'BeginDate', BeginDate, 'EndDate', EndDate);
%Data = dc.DownloadOneStockFinancials('BeginDate', BeginDate, 'EndDate', EndDate, 'Ticker', Ticker, 'Field', {'WeightedEPS'}, 'StoreFile', 'financials.xlsx');
ReportDateList = dc.GetReportDate(BeginDate, EndDate);

Out = dc.DownloadOneStockPublishDate(Ticker, ReportDateList);
% url = 'http://money.finance.sina.com.cn/corp/view/vFD_FinancialGuideLineHistory.php?stockid=000001&typecode=financialratios53';
% source = urlread(url);
% %expr = '\s+(\d\d\d\d-\d\d-\d\d)\s+((\d*\.*\d*)|(&nbsp))\s*';
% expr = '<td style="text-align:center">(\d\d\d\d-\d\d-\d\d)</td>\s*<td style="text-align:center">(([-]*\d*\.*\d*)|(&nbsp;))</td>';
% [~, tokens] = regexp(source, expr, 'match', 'tokens');
% 
% for i = 1:83
%     fprintf('%s\t%s\n',tokens{i}{1}, tokens{i}{2});
% end

