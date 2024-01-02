%%RPC_R2star.m

clc
clearvars
close all

%% 3 T

%% Test-retest (within-session rep)

y3_usp_test = [30.2 38.6 50.3 52.6 61.3]; 
y3_fer_test = [16.1 15.9 18.6 20.0 20.2];
y3_chl_test = [14.4 13.1 13.5 13.9];  
y3_crb_test = [39.3 100.1 110.9 151.1]; 

y3_usp_retest = [31.0 39.0 50.5 52.8 61.4]; 
y3_fer_retest = [15.9 16.2 19.0 20.1 20.6];
y3_chl_retest = [14.5 12.8 13.3 14.1];  
y3_crb_retest = [38.4 98.7 109.3 149.5];

data1 = y3_crb_test;
data2 = y3_crb_retest;

cv_pairs = std([data1; data2]) ./ mean([data1; data2]) .* 100; % in units percentage
median_cv = median(cv_pairs);
min_cv = min(cv_pairs);
max_cv = max(cv_pairs);
RC_per = rms(cv_pairs)*sqrt(2)*1.96; % Percentage coefficient of repeatability

%% Time-point stability (between-session rep)

y3_usp_bl = mean([y3_usp_test; y3_usp_retest]);
y3_fer_bl = mean([y3_fer_test; y3_fer_retest]);
y3_chl_bl = mean([y3_chl_test; y3_chl_retest]);
y3_crb_bl = mean([y3_crb_test; y3_crb_retest]);

y3_usp_8m = [30.9 40.3 49.7 53.9 62.7]; 
y3_fer_8m = [16.4 16.9 17.8 19.8 20.4];
y3_chl_8m = [9.9 9.7 10.2 10.4];  
y3_crb_15m = [42.5 102.9 111.4 148.8];

y3_usp_24m_test     = [29.5 39.0 48.4 51.9 58.8];
y3_usp_24m_retest   = [29.5 39.3 48.5 52.2 59.0];
y3_usp_24m          = mean([y3_usp_24m_test; y3_usp_24m_retest]);
y3_fer_24m_test     = [16.1 16.2 18.0 19.8 20.9];
y3_fer_24m_retest   = [16.3 16.3 18.3 20.0 21.1];
y3_fer_24m          = mean([y3_fer_24m_test; y3_fer_24m_retest]);

data1 = y3_usp_bl;
data2 = y3_usp_24m;

cv_pairs = std([data1; data2]) ./ mean([data1; data2]) .* 100; % in units percentage
median_cv = median(cv_pairs);
min_cv = min(cv_pairs);
max_cv = max(cv_pairs);
RC_per = rms(cv_pairs)*sqrt(2)*1.96; % Percentage coefficient of repeatability

%% 7 T 

%% Test-retest (within-session rep)

y7_usp_test = [29.4 39.5 47.9 51.0 62.1]; 
y7_fer_test = [18.2 19.1 28.1 31.6 34.0];
y7_chl_test = [15.8 14.4 15.2 15.8];
y7_crb_test = [96.6 229.1 255.1 344.5];

y7_usp_retest = [29.5 39.4 48.0 51.0 62.2]; 
y7_fer_retest = [18.1 19.3 28.1 31.8 34.0];
y7_chl_retest = [15.6 14.2 15.2 15.8]; 
y7_crb_retest = [95.5 230.7 264.1 349.5];

data1 = y7_crb_test;
data2 = y7_crb_retest;

cv_pairs = std([data1; data2]) ./ mean([data1; data2]) .* 100; % in units percentage
median_cv = median(cv_pairs);
min_cv = min(cv_pairs);
max_cv = max(cv_pairs);
RC_per = rms(cv_pairs)*sqrt(2)*1.96; % Percentage coefficient of repeatability

%% Time-point stability (between-session rep)

y7_usp_bl = mean([y7_usp_test; y7_usp_retest]);
y7_fer_bl = mean([y7_fer_test; y7_fer_retest]);
y7_chl_bl = mean([y7_chl_test; y7_chl_retest]);
y7_crb_bl = mean([y7_crb_test; y7_crb_retest]);

y7_usp_8m = [30.2 40.6 48.3 50.7 62.1]; 
y7_fer_8m = [18.5 21.2 28.1 32.7 35.1];
y7_chl_8m = [11.3 11.0 9.7 12.0]; 
y7_crb_15m = [144.7 225.1 252.8 337.1];

y7_usp_24m_test     = [29.3 38.9 41.9 50.6 60.4];
y7_usp_24m_retest   = [29.5 38.9 41.9 50.6 60.4];
y7_usp_24m          = mean([y7_usp_24m_test; y7_usp_24m_retest]);
y7_fer_24m_test     = [20.2 20.9 27.9 33.3 35.7];
y7_fer_24m_retest   = [20.3 21.0 27.8 32.9 35.6];
y7_fer_24m          = mean([y7_fer_24m_test; y7_fer_24m_retest]);

data1 = y7_fer_bl;
data2 = y7_fer_24m;

cv_pairs = std([data1; data2]) ./ mean([data1; data2]) .* 100; % in units percentage
median_cv = median(cv_pairs);
min_cv = min(cv_pairs);
max_cv = max(cv_pairs);
RC_per = rms(cv_pairs)*sqrt(2)*1.96; % Percentage coefficient of repeatability

%% Between-magnet reproducibility

data1 = y3_crb_bl;
data2 = y7_crb_bl;

cv_pairs = std([data1; data2]) ./ mean([data1; data2]) .* 100; % in units percentage
median_cv = median(cv_pairs);
min_cv = min(cv_pairs);
max_cv = max(cv_pairs);
RC_per = rms(cv_pairs)*sqrt(2)*1.96; % Percentage coefficient of reproducibility

