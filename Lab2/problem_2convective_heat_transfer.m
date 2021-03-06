%this m-file will create and solve the set of linear equations  to solve
%the convective heat transfer problem

clear;
clc;

%define constants
L = 10;         %domain length
h = 0.05;          %mesh spacing
N = L/h;        %number of mesh points
Pe = 1;

%boundary conditions
T0 = 1;
T_inf = 0;

%create an (N-2)x(N-2) matrix to hold all the equations to be solved
A = zeros(N-2);

%define row and column counters
i = 1;          %row counter
j = 1;          %column counter

%create the first row of the matrix
A(1,1) = -2/(Pe*h^2);
A(1,2) = 1/(2*h) + 1/(Pe*h^2);

%create the last row of the matrix
A(N-2,N-3) = -1/(2*h) + 1/(Pe*h^2);
A(N-2,N-2) = -2/(Pe*h^2);

%create a for loop to create the rest of the matrix
for i = 2:(N-3)
    
    
    A(i,j) = -1/(2*h) + 1/(Pe*h^2);
    A(i,j+1) = -2/(Pe*h^2);
    A(i,j+2) = 1/(2*h) + 1/(Pe*h^2);
    
    %add 1 to j to move over the column counter
    j= j + 1;
    
end


%form the right hand side of the eqn
%intially fill it all with zeros
b=zeros(N-2,1);

%form the first and last row
b(1) = -(-1/(2*h) + 1/(Pe*h^2))*T0;
b(N-2) = -(1/(2*h) + 1/(Pe*h^2))*T_inf;

%solve the equation for the temperature Profile
T = A\b

%now create the entire temperature profile including the boundary
%conditions
Temp = zeros(N,1)
Temp(1) = T0;
Temp(N) = T_inf;
Temp(2:N-1) = T;



% %plot the solution
% x_interval = 0:h:N-1;
% plot(x_interval,Temp,'--');
% hold on
% 
% %now for the analytical solution
% x_exact = 0:.1:N;
% T_exact = exp(-Pe*x_exact);
% 
% %plot the analytical solution with red stars
% plot(x_exact,T_exact,'r');


% %add labels
% title('Plot of the Numerical Solution and the Analytical Solution to the Convective Heat Transfer Problem')
% xlabel('x');
% ylabel('Temperature');
% legend('Numerical Solution','Analytical Solution')


%find the error at T(1)
%first we need the temperature at x = 1
T_x1 = Temp(N/10+1);

relative_error = abs((T_x1 - exp(-1))/exp(-1))





