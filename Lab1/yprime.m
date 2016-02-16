function f = yprime(t,y)

%intialize as a column vector
f = zeros(2,1);

f(1) = y(2);
f(2) = -4*y(1)*y(2);


