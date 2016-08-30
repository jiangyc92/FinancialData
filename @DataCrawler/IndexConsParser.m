function [Tickers, InDate] = IndexConsParser(obj, Source)
% ����ָ���ɷֹ���ҳ

DateExpr = '<div align="center">(\d\d\d\d-\d\d-\d\d)</div>';
[~, DateTokens]= regexp(Source, DateExpr, 'match', 'tokens');
DateNum = length(DateTokens);
InDate = cell(DateNum, 1);
for i = 1:DateNum
    InDate{i} = DateTokens{i}{1};
end

TickerExpr = '<div align="center">(\d{6})</div>';
[~, TickerTokens] = regexp(Source, TickerExpr, 'match', 'tokens');
Tickers = cell(length(TickerTokens),1);
for i = 1:length(TickerTokens)
    Tickers{i} = TickerTokens{i}{1};
end

if length(TickerTokens) ~= DateNum
    error('��ҳ��������!');
end
end
