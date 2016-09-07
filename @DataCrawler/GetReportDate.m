function ReportDateList = GetReportDate(obj, BeginDate, EndDate)
[Years, Seasons] = obj.GetSeasons(BeginDate, EndDate);

N = length(Years);
ReportDateList = zeros(N, 1);
for i = 1:N
    switch Seasons(i)
        case 1
            M = '03';
            D = '31';
        case 2
            M = '06';
            D = '30';
        case 3
            M = '09';
            D = '30';
        case 4
            M = '12';
            D = '31';
        otherwise
            error('ÈÕÆÚ´íÎó£¡')';
    end
    ReportDateList(i) = datenum([num2str(Years(i)), '-', M, '-', D]);
end

end