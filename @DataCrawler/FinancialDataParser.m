function FinancialData = FinancialDataParser(obj, Source, ReportDateList)

Expr = '<td style="text-align:center">(\d\d\d\d-\d\d-\d\d)</td>\s*<td style="text-align:center">(([-]*\d*\.*\d*)|(&nbsp;))</td>';
[~, Tokens]= regexp(Source, Expr, 'match', 'tokens');
N0 = length(Tokens);
N1 = length(ReportDateList);

BeginReportDate = ReportDateList(1);
EndReportDate = ReportDateList(end);

Date = zeros(N0, 1);
Data = zeros(N0, 1);

Row = 0;
for i = 1:N0
   DateTmp = datenum(Tokens{i}{1});
   DataTmp = Tokens{i}{2};
   if DateTmp >= BeginReportDate && DateTmp <= EndReportDate
       Row = Row + 1;
       Date(Row) = DateTmp;
       if strcmp(DataTmp, '&nbsp;')
           Data(Row) = nan;
       else
           DataTmp = str2double(DataTmp);
           if isnan(DataTmp)
               error('ÍøÒ³½âÎö´íÎó£¡');
           end
           Data(Row) = DataTmp;
       end
   end
end

Date = Date(1:Row);
Data = Data(1:Row);
if Date ~= ReportDateList
    error('ÍøÒ³½âÎö´íÎó£¡');
end

FinancialData = Data;

end