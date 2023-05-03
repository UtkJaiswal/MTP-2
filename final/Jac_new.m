function [dIP]=Jac_new(res,ch,tau,fre_exp,I0,t,n)%,mod)
dIP=zeros(12,4);
cal_ref=fwd_model(res,ch,tau,fre_exp,I0,t,n);
% mVprV = fwd_model(res,ch,tau,fre_exp,I0,t,n)
dp1=res*.01;
res=res+dp1;
cal_jac=fwd_model(res,ch,tau,fre_exp,I0,t,n);
for j=1:12
    dIP(j,1)=(cal_jac(j)-cal_ref(j))/dp1;
end
res=res-dp1;

dp2=ch*.01;
ch=ch+dp2;
cal_jac=fwd_model(res,ch,tau,fre_exp,I0,t,n);
for j=1:12
    dIP(j,2)=(cal_jac(j)-cal_ref(j))/dp2;
end
ch=ch-dp2;

dp3=tau*.01;
tau=tau+dp3;
cal_jac=fwd_model(res,ch,tau,fre_exp,I0,t,n);
for j=1:12
    dIP(j,3)=(cal_jac(j)-cal_ref(j))/dp3;
end
tau=tau-dp3;

dp4=fre_exp*.01;
fre_exp=fre_exp+dp4;
cal_jac=fwd_model(res,ch,tau,fre_exp,I0,t,n);
for j=1:12
    dIP(j,4)=(cal_jac(j)-cal_ref(j))/dp4;
end
fre_exp=fre_exp-dp4;

end