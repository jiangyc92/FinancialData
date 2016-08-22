function [Years, Seasons] = GetSeasons(obj, BeginDate, EndDate)
Y0 = year(BeginDate);
Y1 = year(EndDate);
M0 = month(BeginDate);
M1 = month(EndDate);

S0 = ceil(M0 / 3);
S1 = ceil(M1 / 3);

N1 = 4 - S0 + 1;
N2 = 4 * (Y1 - Y0 - 1);
N = N1 + N2 + S1;

Years = zeros(N, 1);
Seasons = zeros(N,1);


for i = 1:N1
    Years(i) = Y0;
    Seasons(i) = S0 + i - 1;
end

for i = N1+1:N1+N2
    Years(i) = Y0 + ceil((i - N1)/4);
    Seasons(i) = mod(i - N1 - 1, 4) + 1;
end

for i = N1+N2+1:N
    Years(i) = Y1;
    Seasons(i) = i - N1 - N2;
end
end