function FinancialData1 = TransformToSeason(obj, FinancialData0, TransformFields)
FinancialData1 = FinancialData0;

ReportN = length(FinancialData0.ReportPeriod);
for i = 1:ReportN - 1
    Y0 = year(FinancialData0.ReportPeriod(i));
    M0 = month(FinancialData0.ReportPeriod(i));
    Y1 = year(FinancialData0.ReportPeriod(i+1));
    M1 = month(FinancialData0.ReportPeriod(i+1));
    
    if Y0 == Y1 && M0 - M1 == 3
        for j = 1:length(TransformFields)
            Field = TransformFields{j};
            FinancialData1.(Field)(i) = FinancialData0.(Field)(i) - FinancialData0.(Field)(i+1); 
        end
    else
        FinancialData1.(Field)(i) = NaN;
    end
end
Fields = fieldnames(FinancialData1);
for i = 1:length(Fields)
    FinancialData1.(Fields{i})(end) = [];
end

end