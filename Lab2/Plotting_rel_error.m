%this m file will plot the error
h = [1;.5;.1;.05]

rel_error = [.094;.0215;0.00091979;0.00029024]

loglog(h,rel_error)

%add labels
xlabel('log(h)')
ylabel('log(relative error)')
title('Log Log Plot of the Mesh Size h Versus the Relative Error at T(1)')