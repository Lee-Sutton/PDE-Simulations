function f = poise_flow(t,x)

%constants
G = -2;

%initialize f as a column vecotr
f = zeros(2,1);

f(1) = x(2);
f(2) = G;
