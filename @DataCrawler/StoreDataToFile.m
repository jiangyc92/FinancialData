function StoreDataToFile(obj, DataToStore, StoreFile, ColName)
% 存储数据,只能识别xls,xlsx,txt

ExcelFormat = false;
TxtFormat = false;

Expr = '((xls)|(xlsx))$';
if ~isempty(regexp(StoreFile, Expr, 'once'))
    ExcelFormat = true;
end
Expr = '(txt)$';
if ~isempty(regexp(StoreFile, Expr, 'once'))
    TxtFormat = true;
end

ColN = length(ColName);
if ExcelFormat
    RangeCol = sprintf('A1:%s1', char(double('A')+ColN-1));
    xlswrite(StoreFile, ColName, RangeCol);
    RangeData = sprintf('A2:%s%d', char(double('A')+ColN-1), size(DataToStore,1)+1);
    xlswrite(StoreFile, DataToStore, RangeData);
end

if TxtFormat
    File = fopen(StoreFile);
    for i = 1:ColN - 1
        fprintf(File, '%s\t', ColName{i}); 
    end
    fprintf(File, '%s\n', ColName{ColN});
    
    for i = 1:size(DataToStore, 1)
        fprintf(File, '%s\t', DataToStore{i, 1});
        for j = 2:ColN-1
            fprintf(File, '%f\t', DataToStore{i, j});
        end
        fprintf(File, '%f\n', DataToStore{i, ColN});
    end
    close(File);
end