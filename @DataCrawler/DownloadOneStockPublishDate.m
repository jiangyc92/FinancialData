function Out = DownloadOneStockPublishDate(obj, Ticker, ReportDateList)
% ��ȡ�Ʊ��ķ�����
% �����±�������ѡ��
%   Ticker: ��Ĵ���, 6λ������ɵ��ַ���
%   ReportDateList: һ�����У���ʾ�Ʊ������գ����ر����պͶ�Ӧ�ķ�����


Url0 = ['http://money.finance.sina.com.cn/corp/view/vCB_BulletinYi.php?stockid=', Ticker, '&type=list&page_type='];
Out.ReportDateList  = ReportDateList;
Out.PublishDateList = zeros(length(ReportDateList), 1);

Suffix = {'yjdbg', 'zqbg', 'sjdbg', 'ndbg'};

for i = 1:4
    Url = [Url0, Suffix{i}];
    pause(rand() * 0.3);
    [Source, Status] = urlread(Url);
    if ~Status
        error('��ҳ��ȡ����');
    end
    PublishDateList = obj.PublishDateParser(Source);
    Index0 = find(month(ReportDateList) == 3 * i);
    Y1 =  year(ReportDateList(Index0));
    Y2 = year(PublishDateList);
    [~, Index1, Index2] = intersect(Y1, Y2);
    Out.PublishDateList(Index0(Index1)) = PublishDateList(Index2);
end

end