function mVprV = fwd_model(res,ch,tau,fre_exp,I0,t,n)
mVprV = zeros(size(t));
for j = 1:length(t)
%     H = zeros(size(t));
%     for i = 0:n
%         G = ((-1)^i)*(((t(j)/abs(tau))^(i*abs(fre_exp)))/(gamma((i*abs(fre_exp))+1)));
% %         G = ((-1)^i)*(((t(j)/abs(tau))^(i*abs(fre_exp)))/(factorial((i*abs(fre_exp)))));
%         a=gamma((i*abs(fre_exp))+1);
%         disp("a is "+a);
%         H = H + G;
%     end
      H=sin(pi*fre_exp)*(gamma(fre_exp)*((tau./t).^(fre_exp))...
          -2*(gamma(2*fre_exp)*cos(pi*fre_exp)*((tau./t).^(2*fre_exp)))...
          +(4*(cos(pi*fre_exp).^(2))-1)*gamma(3*fre_exp)*(tau./t).^(3*fre_exp));
      H=(I0*res*ch/pi).*H;
%     mVperV1 = I0.*ch.*res*H;
%     mVprV(j) = (mVperV1*1000)/12.4; %using 12.4 because of normalizing with field data
    
end
mVprV = H;
% figure
% % loglog(t,actual_data,'*')
% % hold on
% loglog(t,mVprV,'.') 
end