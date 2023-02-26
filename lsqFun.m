function fErr = lsqFun(phi)
%Data
I0 = 0.02 ; %ampere
t = xlsread('syn.xlsx','B1:B11'); %sec
Syn_Noise = xlsread('syn.xlsx','C1:C11');
n = length(t);
% Syn_Noise = [133.643353665135 115.984563167952 99.4560771287416 95.2095131120584 101.248557471780 103.503354692123 104.493737196130 89.1790523085754 95.9080958113386 93.6173351771680 85.5154595541626]';

%Get parameters
res = phi(1);
ch = phi(2);
tau = phi(3);
fre_exp = phi(4);

%function calling for forward model
mVperV=fwd_model(res,ch,tau,fre_exp,I0,t,n);

%compute error
fErr = Syn_Noise-mVperV;

