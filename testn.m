close all
total_n = 10;
fvn = zeros(total_n,1);
for n=1:total_n
    mv12 = fwd_model(res,ch,tau,fre_exp,I0,t,n);.
    
    fvn(n) = mv12(1);
end
plot(fvn)