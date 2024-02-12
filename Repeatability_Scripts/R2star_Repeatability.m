%%R2star_Repeatability.m

clc
clearvars

%% 3 T
usp_3T = csvread('USPIO_R2star_3T.csv',1,3);
fer_3T = csvread('Ferritin_R2star_3T.csv',1,3);
chl_3T = csvread('CaCl2_R2star_3T.csv',1,3);
crb_3T = csvread('CaCO3_R2star_3T.csv',1,3);

%% Test-retest (within-session rep)
y3_usp_test = usp_3T(:,1);
y3_fer_test = fer_3T(:,1);
y3_chl_test = chl_3T(:,1);
y3_crb_test = crb_3T(:,1);

y3_usp_retest = usp_3T(:,3);
y3_fer_retest = fer_3T(:,3);
y3_chl_retest = chl_3T(:,3);
y3_crb_retest = crb_3T(:,3);

data1 = y3_fer_test;
data2 = y3_fer_retest;
data = [transpose(data1); transpose(data2)];

% a_cv_pairs = std(data) ./ mean(data) .* 100; % in units percentage
% a_median_cv = median(a_cv_pairs);
% a_min_cv = min(a_cv_pairs);
% a_max_cv = max(a_cv_pairs);
% a_RC_per = rms(a_cv_pairs)*sqrt(2)*1.96; % Percentage coefficient of repeatability

% a_std_pairs = std(data); % in units s$^{-1}$
% a_median_std = median(a_std_pairs);
% a_min_std = min(a_std_pairs);
% a_max_std = max(a_std_pairs);
% a_RC_abs = rms(a_std_pairs)*sqrt(2)*1.96; % Absolute coefficient of repeatability

type = 'A-1';
alpha = 0.05;
r0 = 0.9;
[a, a_lb, a_ub, F, df1, df2, p] = ICC([data1 data2], type, alpha, r0);


%% Time-point stability (between-session rep)

y3_usp_bl = mean([y3_usp_test y3_usp_retest],2);
y3_fer_bl = mean([y3_fer_test y3_fer_retest],2);
y3_chl_bl = mean([y3_chl_test y3_chl_retest],2);
y3_crb_bl = mean([y3_crb_test y3_crb_retest],2);

y3_usp_9m = usp_3T(:,5);
y3_fer_9m = fer_3T(:,5);
y3_chl_15m = chl_3T(:,5); 
y3_crb_15m = crb_3T(:,5);

y3_usp_24m_test = usp_3T(:,7);
y3_fer_24m_test = fer_3T(:,7);
y3_usp_24m_retest = usp_3T(:,9);
y3_fer_24m_retest = fer_3T(:,9);
y3_usp_24m = mean([y3_usp_24m_test y3_usp_24m_retest],2);
y3_fer_24m = mean([y3_fer_24m_test y3_fer_24m_retest],2);

data1 = y3_fer_bl;
data2 = y3_fer_9m;
data = [transpose(data1); transpose(data2)];

% a_cv_pairs = std(data) ./ mean(data) .* 100; % in units percentage
% a_median_cv = median(a_cv_pairs);
% a_min_cv = min(a_cv_pairs);
% a_max_cv = max(a_cv_pairs);
% a_RC_per = rms(a_cv_pairs)*sqrt(2)*1.96; % Percentage coefficient of repeatability

% a_std_pairs = std(data); % in units s$^{-1}$
% a_median_std = median(a_std_pairs);
% a_min_std = min(a_std_pairs);
% a_max_std = max(a_std_pairs);
% a_RC_abs = rms(a_std_pairs)*sqrt(2)*1.96; % Absolute coefficient of repeatability

type = 'A-1';
alpha = 0.05;
r0 = 0.9;
[a, a_lb, a_ub, F, df1, df2, p] = ICC([data1 data2], type, alpha, r0);

% %%
% clc
% clearvars

%% 7 T 
usp_7T = csvread('USPIO_R2star_7T.csv',1,3);
fer_7T = csvread('Ferritin_R2star_7T.csv',1,3);
chl_7T = csvread('CaCl2_R2star_7T.csv',1,3);
crb_7T = csvread('CaCO3_R2star_7T.csv',1,3);


%% Test-retest (within-session rep)

y7_usp_test = usp_7T(:,1);
y7_fer_test = fer_7T(:,1); 
y7_chl_test = chl_7T(:,1);
y7_crb_test = crb_7T(:,1);

y7_usp_retest = usp_7T(:,3);
y7_fer_retest = fer_7T(:,3);
y7_chl_retest = chl_7T(:,3);
y7_crb_retest = crb_7T(:,3);

data1 = y7_fer_test;
data2 = y7_fer_retest;
data = [transpose(data1); transpose(data2)];

% a_cv_pairs = std(data) ./ mean(data) .* 100; % in units percentage
% a_median_cv = median(a_cv_pairs);
% a_min_cv = min(a_cv_pairs);
% a_max_cv = max(a_cv_pairs);
% a_RC_per = rms(a_cv_pairs)*sqrt(2)*1.96; % Percentage coefficient of repeatability

% a_std_pairs = std(data); % in units s$^{-1}$
% a_median_std = median(a_std_pairs);
% a_min_std = min(a_std_pairs);
% a_max_std = max(a_std_pairs);
% a_RC_abs = rms(a_std_pairs)*sqrt(2)*1.96; % Absolute coefficient of repeatability

type = 'A-1';
alpha = 0.05;
r0 = 0.9;
[a, a_lb, a_ub, F, df1, df2, p] = ICC([data1 data2], type, alpha, r0);

%% Time-point stability (between-session rep)

y7_usp_bl = mean([y7_usp_test y7_usp_retest],2);
y7_fer_bl = mean([y7_fer_test y7_fer_retest],2);
y7_chl_bl = mean([y7_chl_test y7_chl_retest],2);
y7_crb_bl = mean([y7_crb_test y7_crb_retest],2);

y7_usp_9m = usp_7T(:,5);
y7_fer_9m = fer_7T(:,5);
y7_chl_15m = chl_7T(:,5);
y7_crb_15m = crb_7T(:,5);

y7_usp_24m_test = usp_7T(:,7);
y7_fer_24m_test = fer_7T(:,7);
y7_usp_24m_retest = usp_7T(:,9);
y7_fer_24m_retest = fer_7T(:,9);
y7_usp_24m = mean([y7_usp_24m_test y7_usp_24m_retest],2);
y7_fer_24m = mean([y7_fer_24m_test y7_fer_24m_retest],2);


data1 = y7_fer_bl;
data2 = y7_fer_9m;
data = [transpose(data1); transpose(data2)];

% a_cv_pairs = std(data) ./ mean(data) .* 100; % in units percentage
% a_median_cv = median(a_cv_pairs);
% a_min_cv = min(a_cv_pairs);
% a_max_cv = max(a_cv_pairs);
% a_RC_per = rms(a_cv_pairs)*sqrt(2)*1.96; % Percentage coefficient of repeatability

% a_std_pairs = std(data); % in units s$^{-1}$
% a_median_std = median(a_std_pairs);
% a_min_std = min(a_std_pairs);
% a_max_std = max(a_std_pairs);
% a_RC_abs = rms(a_std_pairs)*sqrt(2)*1.96; % Absolute coefficient of repeatability

type = 'A-1';
alpha = 0.05;
r0 = 0.9;
[a, a_lb, a_ub, F, df1, df2, p] = ICC([data1 data2], type, alpha, r0);

%% Between-magnet reproducibility

y3_usp_avg = usp_3T(:,11);
y7_usp_avg = usp_7T(:,11);
y3_fer_avg = fer_3T(:,11);
y7_fer_avg = fer_7T(:,11);
y3_chl_avg = chl_3T(:,7);
y7_chl_avg = chl_7T(:,7);
y3_crb_avg = crb_3T(:,7);
y7_crb_avg = crb_7T(:,7);

data1 = y3_usp_avg;
data2 = y7_usp_avg;
data = [transpose(data1); transpose(data2)];

% a_cv_pairs = std(data) ./ mean(data) .* 100; % in units percentage
% a_median_cv = median(a_cv_pairs);
% a_min_cv = min(a_cv_pairs);
% a_max_cv = max(a_cv_pairs);
% a_RC_per = rms(a_cv_pairs)*sqrt(2)*1.96; % Percentage coefficient of repeatability

type = 'A-1';
alpha = 0.05;
r0 = 0.9;
[a, a_lb, a_ub, F, df1, df2, p] = ICC([data1 data2], type, alpha, r0);
