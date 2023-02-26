close all 
clear all
clc

% For Solving using lsqnonlin
phi0 = [220 50 10 0.2];
%  lb =[0;0;0;0];
%  ub =[Inf;Inf;5;0.5];
t = xlsread('syn.xlsx','B1:B11'); %sec
options = optimoptions('lsqnonlin','Display','iter','Algorithm','trust-region-reflective'...
    ,'FunctionTolerance',5e-05,'StepTolerance',5e-05,'OptimalityTolerance',5e-05,...
    'MaxIterations',5e+05,'MaxFunctionEvaluations',5e+05);
[phi,resnorm,residual,exitflag,output] = lsqnonlin(@(p) lsqFun(p), phi0,[],[],options);


R1=phi(1);
R2=phi(2);
R3=phi(3);
R4=phi(4);
fprintf('rho = %.4f \nm = %.4f \ntau = %.4f \nc = %.4f \n', R1, R2, R3, R4)
yy = xlsread('syn.xlsx','C1:C11');

plot(t,yy,'o','MarkerFaceColor','b','LineWidth',7,'DisplayName','\fontname{Times New Roman} Syn+Noise data');
hold on
I0 = 0.02 ; %ampere
t = xlsread('syn.xlsx','B1:B11'); %sec
n = length(t);
qwe = fwd_model(R1,R2,R3,R4,I0,t,n);
% plot(t,abs(qwe),'*');

 xi=linspace(min(t), max(t), 50);
 smoothedY = spline(t, abs(residual(:,1)), xi);
 plot(xi,smoothedY,'-r','LineWidth',5,'DisplayName','\fontname{Times New Roman} Inverted Model');
set(gca,'FontSize',20,'FontWeight','bold')
 legend(gca,'show','FontSize',20,'FontWeight','bold')
 xlabel('\fontname{Times New Roman} Time [sec]', 'FontSize',22,'FontWeight','bold');
 ylabel('\fontname{Times New Roman} IP Values [mV/V]','FontSize',22,'FontWeight','bold');
% ylim([80 165]);
yydata = smooth(abs(residual(:,1)));
title('\fontname{Times New Roman} IP Decay curve','FontSize',25,'FontWeight','bold');
RMSE = sqrt(mean((yy - yydata).^2));
fprintf('\nRMS error = %.4f \n',RMSE)




% % plot(t,yy,'.k','MarkerSize',48,'LineWidth',7,'DisplayName','\fontname{Times New Roman} Syn+Noise data');plot(xi,smoothedY,'-k','LineWidth',5,'DisplayName','\fontname{Times New Roman} Inverted Model');