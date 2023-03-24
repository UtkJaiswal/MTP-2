xls = readmatrix('utk.xlsx');
% For Solving using lsqnonlin
phi0 = [220 50 10 0.2];
%  lb =[0;0;0;0];
%  ub =[Inf;Inf;5;0.5];
% t = xlsread('syn.xlsx','B1:B11'); %sec
t = [0.02 0.02 0.04 0.06 0.08 0.1 0.14 0.18 0.26 0.4 0.6 0.88 1.2];
t = unique(t);
final_data = zeros(471,6);
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





end
%% plots
figure
    scatter(final_data(:,1), final_data(:,5))
    title('mean IP - rho')

    figure
    scatter(final_data(:,2), final_data(:,5))
    title('mean IP - m')

    figure
    scatter(final_data(:,3), final_data(:,5))
    title('mean IP - tau')

    figure
    scatter(final_data(:,4), final_data(:,5))
    title('mean IP - c')

%%
figure
    scatter(final_data(:,1), log(final_data(:,5)))
    title('mean IP - rho')

    figure
    scatter(final_data(:,2), log(final_data(:,5)))
    title('mean IP - m')

    figure
    scatter(final_data(:,3), log(final_data(:,5)))
    title('mean IP - tau')

    figure
    scatter(final_data(:,4), log(final_data(:,5)))
    title('mean IP - c')

%%  less than10
less_than_10 = find(final_data(:,6) < 5);
figure
    scatter(final_data(less_than_10,1), final_data(less_than_10,5))
    title('mean IP - rho')

    figure
    scatter(final_data(less_than_10,2), final_data(less_than_10,5))
    title('mean IP - m')

    figure
    scatter(final_data(less_than_10,3), final_data(less_than_10,5))
    title('mean IP - tau')

    figure
    scatter(final_data(less_than_10,4), final_data(less_than_10,5))
    title('mean IP - c')
%%

m = mean(xls(:, 1:12));
e = std(xls(:,1:12))/sqrt(472);
figure
    errorbar(t,m,e)

x_mad = mad(xls(:,1:12),1);
    figure
        plot(median(xls(:,1:12)))
%%
