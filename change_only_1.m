xls = readmatrix('utk.xlsx');
% For Solving using lsqnonlin
phi0 = [220 50 10 0.2];
%  lb =[0;0;0;0];
%  ub =[Inf;Inf;5;0.5];
% t = xlsread('syn.xlsx','B1:B11'); %sec
t = [0.02 0.02 0.04 0.06 0.08 0.1 0.14 0.18 0.26 0.4 0.6 0.88 1.2];
t = unique(t);
final_data = zeros(471,6);
x = cell(471,1);
for r=1:471
        options = optimoptions('lsqnonlin','Display','off','Algorithm','trust-region-reflective'...
    ,'FunctionTolerance',5e-05,'StepTolerance',5e-05,'OptimalityTolerance',5e-05,...
    'MaxIterations',5e+05,'MaxFunctionEvaluations',5e+05);
[phi,resnorm,residual,exitflag,output] = lsqnonlin(@(p) Utk_lsqFun(p,xls(r,1:12)), phi0,[],[],options);
disp(r)

R1=phi(1);
R2=phi(2);
R3=phi(3);
R4=phi(4);


xi=linspace(min(t), max(t), 50);
 smoothedY = spline(t, abs(residual), xi);
yydata = smooth(abs(residual(:,1)));
RMSE = sqrt(mean((xls(r,1:12) - yydata).^2));




final_data(r,1) = R1;
final_data(r,2) = R2;
final_data(r,3) = R3;
final_data(r,4) = R4;
final_data(r,5) = mean(xls(r,1:12));
final_data(r,6) = RMSE;
x{r,1} = yydata;

end


