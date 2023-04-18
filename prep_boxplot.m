

%% Prepare boxplot sensor saturation
data = fa_all(:,6);

num_tests=length(data);
quartile_idx = floor(num_tests/4);

min_val     = min(data);
max_val     = max(data);
median_val  = median(data);
data_sorted = sort(data);
first_quart = data_sorted( quartile_idx);
last_quart  = data_sorted(3*quartile_idx);

out = sprintf("--min= %d\n--low_quartile = %d\n--median = %d\n--up_quartile = %d\n--max = %d", ...
             min_val, first_quart, median_val, last_quart, max_val);
disp(out)