%This m-file will solve the ODE using a shooting method with ODE 45
clc;

%constants
f_p_inf = 1;
f2_prime_exact = 0.3321;    %this will be used to check rel error of f''(0) 
nmax = 10;
n = [0 nmax];

%x will be used in place of n because this file was previously used to
%solve computer lab 1
x = n;          


%initially we have two guesses
x01 = [0 0 1];        %intial guess #1 guess f''(0) = 1
x02 = [0 0 0.1];        %intial guess #2 guess f''(0) = 4

%need to solve each ODE

%solve for the initial guess #1
%note that U = F it was left this way after using this mfile to solve
%comuter lab 1

[X1,U1] = ode45(@blasius,x,x01);     

%solve for the initial guess #2
[X2,U2] = ode45(@blasius,x,x02);

% %plot the functions f'(n) to check if the solved equations bracket the
% %solution f'(infinitiy) = 1
% plot(X1,U1(:,2),'r')        %for first guess soln.
% hold on;
% plot(X2,U2(:,2))        %for the second guess
% 
% %put the exact solution in to see if it is bracketed by the numerical
% %solutions
% plot([0;nmax],[1;1],'--g')
% legend('x01','x02','f_prime(infinity)')


%check the relative errors for each at f'(infinity)
a1 = size(U1);   %need to evaluate f' at its last value
B = a1(1);       %need the number of rows in U1 to evaluate the last value
%need to find the size of U2 as well since it could be different
a2 = size(U2);
B2 = a2(1)

rel1 = abs((U1(B,2)-f_p_inf)/f_p_inf);
rel2 = abs((U2(B2,2)-f_p_inf)/f_p_inf);




%we need to classify each as either positive or negative so we can decide
%which point to discard after converging we assume each guess gives us
%opposite signs around the root
if (U1(B,2)-f_p_inf)>0
   Upos = U1;
   Uneg = U2;
   %need to keep track of the size of each matrix
   Bpos = B;
   Bneg = B2;
   
else
    Uneg = U1;
    Upos = U2;
    %need to keep track of the size of each matrix
    Bpos = B2;
    Bneg = B;
    
end

rel_error = min(rel1,rel2);

%create a while loop to converge the solution

while rel_error> 10^-3      %we want the soln. to 3 sig figs
    
    %converge the soln. using false position method
    f_2prime_new = -Upos(Bpos,2)* (Uneg(1,3)- Upos(1,3))/(Uneg(Bneg,2)-f_p_inf - Upos(Bpos,2)-f_p_inf) + Upos(1,3);
    
    %new intial conditions
    x03 = [0 0 f_2prime_new];
    
    %solve with new intial conditions
    [X3,U3] = ode45(@blasius,x,x03);
    
    %need to find the size of this matrix
    a3 = size(U3);
    B3 = a3(1);
    
    %classify U3(B) as a positive or negative root
    if (U3(B3,2)-f_p_inf)>0
       Upos = U3;
       
       %keep track of the size of the matrix
       Bpos = B3
       
    else
        Uneg = U3
        Bneg = B3;
        
    end
    
    %find new relative error store it as a vector so it can be plotted
    rel_error = abs((U3(B3,2)-f_p_inf)/f_p_inf);


end

%plot the final solution as a black line
plot(X3,U3(:,2),'k')
hold on

%plot it against the exact solution with green *'s
 plot(BlasiusExactSoln(:,1),BlasiusExactSoln(:,3),'*g')
 
%add labels 
title('Numerical Solution and Exact solution of the Blasius Problem With nmax = 10 ')
xlabel('n');
ylabel('fprime(n)')
legend('Numerical Solution', 'Analytical Solution')

%now in a new figure plot the numerical solution and the exact solution
%with f'(0) on the x axis and n on the y axis
figure;
plot(U3(:,2),X3,'k')
hold on
plot(BlasiusExactSoln(:,3),BlasiusExactSoln(:,1),'*g')

%add labels 
title('Numerical Solution and Exact solution of the Blasius Problem With nmax = 10 ')
xlabel('fprime(n)');
ylabel('n')
legend('Numerical Solution', 'Analytical Solution')

%now display the relative error at f''(0)
relative_error_f2prime = (U3(1,3)-f2_prime_exact)/ f2_prime_exact

%and display the value of f''(0)
f_double_prime = U3(1,3)