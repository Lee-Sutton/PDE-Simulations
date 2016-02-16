%This m-file will solve the ODE using a shooting method with ODE 45
clear;
clc;
%constants
V=1.5;      % y(1)=1.5 call this V
x = [0 1]; 
iteration_num = 1;       %this is a counter for relative error etc.

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

% %plot the functions to check if the solved equations bracket the solution
% plot(X1,U1(:,1),'r')        %for first guess soln.
% hold on;
% plot(X2,U2(:,1))        %for the second guess


%check the relative errors for each at u(b)
a = size(U1);   %need to evaluate U at its last value
B = a(1);       %need the number of rows in U1 to evaluate the last value
rel1 = abs((U1(B)-V)/V);
rel2 = abs((U2(B)-V)/V);

%we need to classify each as either positive or negative so we can decide
%which point to discard after converging we assume each guess gives us
%opposite signs around the root
if (U1(B)-V)>0
   Upos = U1;
   Uneg = U2;
else
    Uneg = U1;
    Upos = U2;
end

rel_error = min(rel1,rel2);

%create a while loop to converge the solution

while rel_error> 10^-3      %we want the soln. to 3 sig figs
    
    %converge the soln. using false position method
    U3_prime = -Upos(B)*(Uneg(1,2)- Upos(1,2))/(Uneg(B)-V - Upos(B)-V) + Upos(1,2);
    
    %new intial conditions
    x03 = [0 U3_prime];
    
    %solve with new intial conditions
    [X3,U3] = ode45(@yprime,x,x03);
    
    %classify U3(B) as a positive or negative root
    if (U3(B)-V)>0
       Upos = U3;
       
    else
        Uneg = U3;
        
    end
    
    %find new relative error store it as a vector so it can be plotted
    rel_error(iteration_num) = abs((U3(B)-V)/V);
    iteration_num = iteration_num + 1;
    
    %vectors to save y'(0) and y(1) vs the iteration number
    yprime0(iteration_num) = U3(1,2);
    y1(iteration_num) = U3(B);


end

%plot the final solution as a blue line
plot(X3,U3(:,1))
hold on

%add labels
xlabel('x')
ylabel('y')
title('Numerical Solution to the BVP in Problem 2')
legend('Numerical Solution')

%create a new figure to plot y'(0) and y(1) as a function of the iteration
%number
figure;

plot(1:iteration_num,yprime0);

%add labels
xlabel('Iteration Number')
ylabel('yprime')
legend('Yprime(0)')
title('dy/dx at x=0 Plotted Against the Iteration Number')

%make a new figure for y1
figure;
plot(1:iteration_num,y1);

%add labels
xlabel('Iteration Number')
ylabel('y')
legend('Y(1)')
title('y(1) Plotted Against the Iteration Number')

