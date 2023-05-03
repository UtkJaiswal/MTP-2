% FIELD 1 obs_data = xls(1, 29:40);

clc
close all
clear
xls = readmatrix('IP data project 3.xlsx');
%initial param
% mod = [220 5 0.010 0.3];
mod = [5 1.5 0.013 0.25];
res = mod(1);
ch = mod(2);
tau = mod(3);
fre_exp = mod(4);
%converted to log
mod=log(mod);
I0 = 0.02;
n=50;
t = [0.02 0.02 0.04 0.06 0.08 0.1 0.14 0.18 0.26 0.4 0.6 0.88 1.2];
t = unique(t);
%data given
obs_data = xls(1, 29:40);

%log of data given
d=log(obs_data);
cal_data = fwd_model(res,ch,tau,fre_exp,I0,t,n);
f=log(cal_data);
jacob = zeros(12,4);
count=1;
rms_IP(count)=(((sum((f-d).^2))/length(f))^0.5)*100;
count=2;
% vv=0.7
vv=0.5
x=1;
xy=zeros(168,4);
while x<=168

while count<=50
%     jacobi for each param
    
    
%     for i=1:4
%         cal_data_ref = fwd_model(res,ch,tau,fre_exp,I0,t,n);
%         dp = mod(i)*0.01;
%         jac_mod=mod;
%         jac_mod(i)=jac_mod(i)+dp;
%         res = exp(jac_mod(1));
%         ch = exp(jac_mod(2));
%         tau = exp(jac_mod(3));
%         fre_exp = exp(jac_mod(4));
%         cal_data_jac = fwd_model(res,ch,tau,fre_exp,I0,t,n);
%         
%         dIP = ((cal_data_jac)' - (cal_data_ref)')./dp;   % linear Jac calculated
%         tmp=exp(mod(i))
       
[dIP]=Jac_new(res,ch,tau,fre_exp,I0,t,n);%,mod)
DIPlin=dIP;
% %% converting the Jacobian to log domain
    for dNum = 1:length(t)
%            dIP(dNum,1) = TransformRhoADeriv(cal_data(dNum),dIP(dNum,1),res);   
           %(rhoA, rhoAderiv, p)
% calculated resistivity(dnum), linear jacobian(dnum,lnum) , linear model(lnum) , 
%     rhoAderivT = rhoAderiv * p / rhoA;
% tmp1=dIP(dNum,1); tmp2=cal_data(dNum);
dIPP(dNum,1)=dIP(dNum,1).*res./cal_data(dNum)
%     dIPP(dNum,1)=(tmp1.*res)./tmp2
    end
 J1=dIP(:,1);
 
     for dNum = 1:length(t)
%            dIP(dNum,2) = TransformRhoADeriv(cal_data(dNum),dIP(dNum,2),ch);   
    dIPP(dNum,2)=dIP(dNum,2).*ch./cal_data(dNum)
     end
 J2=dIP(:,2);
 %
     for dNum = 1:length(t)
%            dIP(dNum,3) = TransformRhoADeriv(cal_data(dNum),dIP(dNum,3),tau);   
    dIPP(dNum,3)=dIP(dNum,3).*tau./cal_data(dNum)
     end
 J3=dIP(:,3);
 %
     for dNum = 1:length(t)
%            dIP(dNum,4) = TransformRhoADeriv(cal_data(dNum),dIP(dNum,4),fre_exp);   
    dIPP(dNum,4)=dIP(dNum,4).*fre_exp./cal_data(dNum)
     end
 J4=dIP(:,4);
 
 jacob=[J1 J2 J3 J4];
  J=   jacob;
%     dm = pinv((jacob)'*jacob)*(jacob)'*...
%                (d - f)';
%     mod=mod+dm';
    
%%%%%%%%%%%%%%%%%%%%
   [J_M ,J_N] = size(J);
if J_M >= J_N                                                   % when no of data points >  no. of mdel parameters
[Ju,Js,Jv] = svd(J,0);                                     % our case
else
[Jv,Js,Ju] = svd(J,'econ');
end
Jsd = diag(Js);     

for i = 1 : length(Jsd)
if Jsd(i) == 0
% Splus=zeros(size(m));
Splus(i) = 0;
else
Splus(i) = 1/Jsd(i);
end
% J_k=ones(1,length(m));
J_k(i) = Jsd(i)./Jsd(1);    %precession of thickness is very small
end
Splus = diag(Splus);

err_level=vv/Jsd(1);
% T=zeros(size(5));
for i = 1 : J_N
if J_k(i) >= err_level^(2)
T(i) = J_k(i)^(4)/(J_k(i)^(4)+err_level^4);                         
else
T(i) = 0;
end
end
T = diag(T);
lamda=T;
Bplus = Jv*T*Splus*Ju';
% data_residual = log(dBzObs)-log(dBz);
data_residual = d-f;
data_residual=data_residual';
if J_M >= J_N
    dm = Bplus*data_residual;
else
dm = Bplus'*data_residual;           
 disp '2'
end

mod = mod + dm';  

%%%%%%%%%%%%%%%%%%

    res = exp((mod(1)));
    ch = exp((mod(2)));
    tau = exp((mod(3)));
    fre_exp = exp((mod(4)));
    cal_data=fwd_model(res,ch,tau,fre_exp,I0,t,n);
    f=log(cal_data);
    rms_IP(count)=(((sum((f-d).^2))/length(f))^0.5)*100;
%     if rms_IP(count-1)>rms_IP(count)
%         break;
%     end
%   figure
% loglog(t,actual_data,'*')
% hold on
% loglog(t,fmodel_results0,'.')  
count=count+1;
clear T
clear Splus
end

xy(x,1)=exp(mod(1));
xy(x,2)=exp(mod(2));
xy(x,3)=exp(mod(3));
xy(x,4)=exp(mod(4));
x=x+1;
A=xls(:,5);
B=xls(:,8);
M=xls(:,11);
N=xls(:,14);
end

A = A';
B = B';
M = M';
N = N';

f11 = (N + M) ./ 2;
f22 = (B - A)./3;
f33 = xy(:,1)';

i=1;
j=1;
while i<=168
    f1(j)=f11(i);
    f2(j)=f22(i);
    f3(j)=f33(i);

    i=i+5;
    j=j+1;
end

% [f1m, f2m] = meshgrid(f1,f2);
% figure
%     contour(f1m,f2m, f3);

% Create the scatter plot with interpolated colors based on f3 values
% scatter(f1, f2, 30, f3, 'filled');
% 
% % Add colorbar and labels
% colorbar;
% xlabel('f1');
% ylabel('f2');
% title('Scatter plot with interpolated colors based on f3 values');
% F = scatteredInterpolant(f1',f2',f3');
% vq=F(f1',f2');
% plot3(f1,f2,f3,'.',f1,f2,vq,'.'), grid on
% title('Linear Interpolation')
% xlabel('x'), ylabel('y'), zlabel('Values')
% legend('Sample data','Interpolated query data','Location','Best')
xx=union(f1,f1);
yy=union(f2,f2);

tmp_x=xx(2)-xx(1);
tmp_y=yy(2)-yy(1);

[mesh.X1,mesh.Y1]=meshgrid(xx,yy);

xnew=[min(f1):tmp_x/2:max(f1)];
ynew=[min(f2),tmp_y/2:max(f2)];
[xxx,yyy]=meshgrid(xnew,ynew);
Z1=scatteredInterpolant(f1',f2',f3');

Z11=Z1(xxx,yyy);

contourf(xxx,yyy,Z11);
