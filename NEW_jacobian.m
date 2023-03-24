%%
clear
xls = readmatrix('utk.xlsx');

% initial_params = [220 50 10 0.2];
initial_params = [1 0.5 10 0.5];

res = initial_params(1);
ch = initial_params(2);
tau = initial_params(3);
fre_exp = initial_params(4);

I0 = 0.02;
n = 50e3;
t = [0.02 0.02 0.04 0.06 0.08 0.1 0.14 0.18 0.26 0.4 0.6 0.88 1.2];
t = unique(t);


fmodel_results0 = fwd_model(res,ch,tau,fre_exp,I0,t,n);

delta = 0.1;
actual_data = xls(1, 1:12)./12.4;
jacob = zeros(12,4);
sq_sum_err = 1e7;
all_sq_sum_err = [];
 all_m = [];
while sq_sum_err > 1e-3
    disp(sq_sum_err)
    for i=1:4
        initial_params(i) = initial_params(i) + delta;
        res = initial_params(1);
        ch = initial_params(2);
        tau = initial_params(3);
        fre_exp = initial_params(4);
    
    
        fmodel_results = fwd_model(res,ch,tau,fre_exp,I0,t,n);
        jacob(:,i) = transpose(fmodel_results);
    
    end

    delta_m = pinv(transpose(jacob)*jacob)*transpose(jacob)*transpose(actual_data - fmodel_results0);

    initial_params = (initial_params - [delta delta delta delta]) + transpose(delta_m);
%     err_vec = abs(actual_data - fmodel_results0);
    err_vec = sqrt(mean((actual_data - fmodel_results0).^2))
    sq_sum_err = sum(err_vec.^2)/12;
    all_sq_sum_err = [all_sq_sum_err sq_sum_err];
    all_m = [all_m delta_m];
end
