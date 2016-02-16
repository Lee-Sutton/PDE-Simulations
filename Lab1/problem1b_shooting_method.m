%This m-file will solve the ODE using a shooting method with ODE 45
clear;
clc;
%constants
b=1;
G=-2;
V=1;
y = [-b b]; 


%initially we have two guesses
x01 = [0 1];     %intial guess #1 u(-b)=1 & u'(-b)=1
x02 = [0 4];     %intial guess #1 u(-b)=1 & u'(-b)=4

%need to solve each ODE

%solve for the initial guess #1
[Y1,U1] = ode45(@poise_flow,y,x01);     

%solve for the initial guess #2
[Y2,U2] = ode45(@poise_flow,y,x02);

% %plot velocity vs. y
% plot(U1(:,1),Y1)        %for first guess soln.
% hold on;
% plot(U2(:,1),Y2)   


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

rel_error = min(rel1,rel2)

%create a while loop to converge the solution

while rel_error> 10^-4      %we want the soln. to 4 sig figs
    
    %converge the soln. using false position method
    U3_prime = -Upos(B)*(Uneg(1,2)- Upos(1,2))/(Uneg(B)-V - Upos(B)-V) + Upos(1,2)
    
    %new intial conditions
    x03 = [0 U3_prime];
    
    %solve with new intial conditions
    [Y3,U3] = ode45(@poise_flow,y,x03);
    
    %classify U3(B) as a positive or negative root
    if (U3(B)-V)>0
       Upos = U3;
       
    else
        Uneg = U3;
        
    end
    
    %find new relative error
    rel_error = abs((U3(B)-V)/V);

end

%plot the final solution with the initial guesses
plot(U3(:,1),Y3,'*r')
hold on

%plot it against the actual solution
y = linspace(-b,b);
u = -1*y.^2+0.5*y+1.5;
plot(u,y,'g');

%add labels
xlabel('u')
ylabel('y')
title('Numerical and Analytical Solution for Flow in a Channel')
legend('Numerical Solution', 'Analytical Solution')


