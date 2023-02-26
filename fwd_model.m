function mVprV = fwd_model(res,ch,tau,fre_exp,I0,t,n)
% i = 1:length(t);
H = 0;
for i = 1:n
G = ((-1).^i).*(((t(i)./abs(tau)).^(i.*abs(fre_exp)))./(gamma((i.*abs(fre_exp))+1)));
H = H+G;
mVperV1 = I0.*ch.*res.*H;
mVprV =(mVperV1*1000)/12.4; %using 12.4 because of normalizing with field data
end
end