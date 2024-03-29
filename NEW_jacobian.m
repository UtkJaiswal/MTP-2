%%
clc
clear
xls = readmatrix('IP data project 3.xlsx');

initial_params = [220 50 10 1];
% initial_params = [220 0.5 10 0.5];

res = initial_params(1);
ch = initial_params(2);
tau = initial_params(3);
fre_exp = initial_params(4);

I0 = 0.02;
n = 5;
t = [0.02 0.02 0.04 0.06 0.08 0.1 0.14 0.18 0.26 0.4 0.6 0.88 1.2];
t = unique(t);


fmodel_results0 = fwd_model(res,ch,tau,fre_exp,I0,t,n);
fmodel_results0_inverse = fmodel_results0.^(-1);

delta = 0.1;
actual_data = xls(1, 1:12);
jacob = zeros(12,4);
sq_sum_err = 1e7;
all_sq_sum_err = [];
 all_m = [];
while sq_sum_err > 1e-3
%     disp(sq_sum_err)
    for i=1:4
        dm = initial_params(i)*0.01;
        original_param_not_added = initial_params(i);

        

        initial_params(i) = initial_params(i) + dm;
        

        res = initial_params(1);
        ch = initial_params(2);
        tau = initial_params(3);
        fre_exp = initial_params(4);
    
    
        fmodel_results = fwd_model(res,ch,tau,fre_exp,I0,t,n);
        
        
        fmodel_results_inverse = fmodel_results.^(-1);
        
     

        diff_fmodel_minus_model0 = transpose(fmodel_results_inverse) - transpose(fmodel_results0_inverse);
        
        
        
%         diff_fmodel_minus_model0 = diff_fmodel_minus_model0./(dm);
        diff_fmodel_minus_model0 = diff_fmodel_minus_model0;
        
        
        
        initial_params(i) = original_param_not_added;
        jacob(:,i) = (diff_fmodel_minus_model0.*original_param_not_added)./transpose(actual_data);
        
    end
    disp('jacob')
    disp(jacob)
    pause(3)
    delta_m = pinv(transpose(jacob)*jacob)*transpose(jacob)*transpose(actual_data - fmodel_results0);
    
    
    initial_params = initial_params + transpose(delta_m);
%     err_vec = abs(actual_data - fmodel_results0);
    err_vec = sqrt(mean((actual_data - fmodel_results0).^2));
    sq_sum_err = sum(err_vec.^2)/12;
    all_sq_sum_err = [all_sq_sum_err sq_sum_err];
    all_m = [all_m delta_m];
end
