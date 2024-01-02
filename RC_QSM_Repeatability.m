%%RPC_R2star.m

clc
clearvars
close all

%% 3 T

%% Test-retest (within-session rep)
y3_usp_test = [0.663 0.893 1.179 1.273 1.460];
y3_fer_test = [0.506 0.584 0.886 1.040 1.109];
y3_chl_test = [-0.230 -0.638 -0.985 -1.152]; 
y3_crb_test = [0.118 -0.077 -0.116 -0.292];

y3_usp_retest = [0.657 0.894 1.180 1.272 1.457];
y3_fer_retest = [0.505 0.581 0.878 1.038 1.116];
y3_chl_retest = [-0.232 -0.642 -0.979 -1.147]; 
y3_crb_retest = [0.118 -0.076 -0.115 -0.290];

data1 = y3_usp_test;
data2 = y3_usp_retest;

std_pairs = std([data1; data2]) .* 1000; %(in units ppb)
median_cv = median(std_pairs);
min_cv = min(std_pairs);
max_cv = max(std_pairs);
RC = rms(std_pairs)*sqrt(2)*1.96; % Absolute coefficient of repeatability

%% Time-point stability (between-session rep)

y3_usp_bl = mean([y3_usp_test; y3_usp_retest]);
y3_fer_bl = mean([y3_fer_test; y3_fer_retest]);
y3_chl_bl = mean([y3_chl_test; y3_chl_retest]);
y3_crb_bl = mean([y3_crb_test; y3_crb_retest]);

y3_usp_8m = [0.650 0.904 1.180 1.274 1.454];
y3_fer_8m = [0.504 0.600 0.884 1.055 1.121];
y3_chl_8m = [-0.248 -0.660 -0.994 -1.179]; 
y3_crb_15m = [0.085 -0.058 -0.110 -0.279];

y3_usp_24m_test     = [0.621 0.855 1.135 1.225 1.369];
y3_usp_24m_retest   = [0.619 0.854 1.135 1.224 1.361];
y3_usp_24m          = mean([y3_usp_24m_test; y3_usp_24m_retest]);
y3_fer_24m_test     = [0.499 0.570 0.848 1.005 1.102];
y3_fer_24m_retest   = [0.496 0.568 0.848 1.007 1.107];
y3_fer_24m          = mean([y3_fer_24m_test; y3_fer_24m_retest]);

data1 = y3_crb_bl;
data2 = y3_crb_15m;

std_pairs = std([data1; data2]) .* 1000; %(in units ppb)
median_cv = median(std_pairs);
min_cv = min(std_pairs);
max_cv = max(std_pairs);
RC = rms(std_pairs)*sqrt(2)*1.96; % Absolute coefficient of repeatability

%% 7 T

%% Test-retest (within-session rep)

y7_usp_test = [0.392 0.499 0.596 0.644 0.724];
y7_fer_test = [0.460 0.518 0.789 0.947 1.018];
y7_chl_test = [-0.262 -0.659 -0.930 -1.017];
y7_crb_test = [0.080 -0.081 -0.110 -0.141];

y7_usp_retest = [0.395 0.497 0.593 0.640 0.722];
y7_fer_retest = [0.459 0.517 0.792 0.946 1.016];
y7_chl_retest = [-0.264 -0.652 -0.916 -1.013];
y7_crb_retest = [0.082 -0.078 -0.109 -0.142];

data1 = y7_crb_test;
data2 = y7_crb_retest;

std_pairs = std([data1; data2]) .* 1000; %(in units ppb)
median_cv = median(std_pairs);
min_cv = min(std_pairs);
max_cv = max(std_pairs);
RC = rms(std_pairs)*sqrt(2)*1.96; % Absolute coefficient of repeatability

%% Time-point stability (between-session rep)

y7_usp_bl = mean([y7_usp_test; y7_usp_retest]);
y7_fer_bl = mean([y7_fer_test; y7_fer_retest]);
y7_chl_bl = mean([y7_chl_test; y7_chl_retest]);
y7_crb_bl = mean([y7_crb_test; y7_crb_retest]);

y7_usp_8m = [0.369 0.477 0.596 0.634 0.709];
y7_fer_8m = [0.469 0.569 0.817 0.993 1.038];
y7_chl_8m = [-0.254 -0.645 -0.971 -1.155];
y7_crb_15m = [0.091 -0.072 -0.110 -0.266];

y7_usp_24m_test     = [0.343 0.448 0.560 0.600 0.681];
y7_usp_24m_retest   = [0.340 0.448 0.551 0.596 0.688];
y7_usp_24m          = mean([y7_usp_24m_test; y7_usp_24m_retest]);
y7_fer_24m_test     = [0.438 0.519 0.779 0.909 1.009];
y7_fer_24m_retest   = [0.432 0.514 0.769 0.902 1.013];
y7_fer_24m          = mean([y7_fer_24m_test; y7_fer_24m_retest]);

data1 = y7_fer_bl;
data2 = y7_fer_24m;

std_pairs = std([data1; data2]) .* 1000; %(in units ppb)
median_cv = median(std_pairs);
min_cv = min(std_pairs);
max_cv = max(std_pairs);
RC = rms(std_pairs)*sqrt(2)*1.96; % Absolute coefficient of repeatability

%% Between-magnet reproducibility

data1 = y3_crb_bl;
data2 = y7_crb_bl;

std_pairs = std([data1; data2]) .* 1000; %(in units ppb)
median_cv = median(std_pairs);
min_cv = min(std_pairs);
max_cv = max(std_pairs);
RC = rms(std_pairs)*sqrt(2)*1.96; % Absolute coefficient of reproducibility
