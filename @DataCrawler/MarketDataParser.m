function [Date, Data] = MarketDataParser(obj, Source, FuQuan)
% ½âÎöÍøÒ³

DateExpr = '\s+(\d\d\d\d-\d\d-\d\d)\s*';
[~, DateTokens]= regexp(Source, DateExpr, 'match', 'tokens');
DateNum = length(DateTokens);
Date = cell(DateNum, 1);
for j = 1:DateNum
    Date{j} = DateTokens{j}{1};
end

DataExpr = '<div align="center">(\d*\.?\d*)</div>';
[~, DataTokens] = regexp(Source, DataExpr, 'match', 'tokens');
Data = zeros(length(DataTokens), 1);
for i = 1:length(DataTokens)
    Data(i) = str2double(DataTokens{i}{1});
end

if FuQuan
    Data = reshape(Data, 7, length(Data)/7 )';
else
    Data = reshape(Data, 6, length(Data)/6)';
end

if size(Data, 1) ~= length(Date)
    error('ÍøÒ³½âÎö´íÎó!');
end
end
