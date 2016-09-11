function Out = DownloadOneStockPublishDate(obj, Ticker, ReportDateList)
% 获取财报的发布日
% 有如下变量可以选择：
%   Ticker: 标的代码, 6位数字组成的字符串
%   ReportDateList: 一个数列，表示财报报告日，返回报告日和对应的发布日


Url0 = ['http://money.finance.sina.com.cn/corp/view/vCB_BulletinYi.php?stockid=', Ticker, '&type=list&page_type='];
Out.ReportDateList  = ReportDateList;
Out.PublishDateList = zeros(length(ReportDateList), 1);

Suffix = {'yjdbg', 'zqbg', 'sjdbg', 'ndbg'};

for i = 1:4
    Url = [Url0, Suffix{i}];
    pause(rand() * 0.3);
    [Source, Status] = urlread(Url);
    if ~Status
        error('网页读取错误！');
    end
    PublishDateList = obj.PublishDateParser(Source);
    Index0 = find(month(ReportDateList) == 3 * i);
    Y1 =  year(ReportDateList(Index0));
    Y2 = year(PublishDateList);
    [~, Index1, Index2] = intersect(Y1, Y2);
    Out.PublishDateList(Index0(Index1)) = PublishDateList(Index2);
end

end