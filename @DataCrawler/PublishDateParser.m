function PublishDateList = PublishDateParser(obj, Source)

Expr = '(\d\d\d\d-\d\d-\d\d)&nbsp;\s*<a';
[~, Tokens] = regexp(Source, Expr, 'match', 'tokens');
PublishDateList = zeros(length(Tokens), 1);
for i = 1:length(PublishDateList)
    PublishDateList(i) = datenum(Tokens{i});
end
end