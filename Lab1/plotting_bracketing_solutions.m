%This m-file will solve the ODE using a shooting method with ODE 45
clear;
clc;
%constants
V=1.5;      % y(1)=1.5 call this V
x = [0 1]; 


%initially we have two guesses
x01 = [0 7];     %intial guess #1 u(-b)=1 & u'(-b)=1
x02 = [0 4];     %intial guess #1 u(-b)=1 & u'(-b)=4

%need to solve each ODE

%solve for the initial guess #1
%note that U = Y it was left this way after using this mfile to solve
%problem 1
[X1,U1] = ode45(@yprime,x,x01);     

%solve for the initial guess #2
[X2,U2] = ode45(@yprime,x,x02);

%plot the functions to check if the solved equations bracket the solution
plot(X1,U1(:,1),'r')        %for first guess soln.
hold on;
plot(X2,U2(:,1))        %for the second guess

%add in a plot for y(1)=1.5 so we can see clearly that the solutions
%bracket y(1)
xbracket = linspace(0,1);
ybracket = 1.5;
plot(xbracket,ybracket,'.k')

%Label the plot
xlabel('x')
ylabel('y')
title('Plot of Solutions with 2 Initial Guesses that Bracket the Solution')
legend('Guess #1', 'Guess #2','y(1) = 1.5')
