% R2star_scatter.m
% Least squares linear regression between iron concentration and R2star

clc
clearvars
close all

%%
cd C:\vnm\Data
filename = 'R2star';
output_dir = 'C:\Users\s4601543\Downloads\';

x_usp = 1.25.*[10:5:30]./ 55.485;% umol/mL
uncert_usp = [3.44 3.80 4.26 4.78 5.34] ./ 55.485;
x_usp_plt = [0,43.75] ./ 55.485;
x_fer = [210:90:570]./ 55.845;% Molarity (umol/mL)
uncert_fer = [20.7 29.5 38.3 47.1 56.0]./ 55.845;  %umol/mL
x_fer_plt = [0,650] ./ 55.845;
x_chl = [0.1:0.1:0.4]./110.98.*1000; % mM
x_chl_plt = [0,0.45]./110.98.*1000; % mM
x_crb = [0.1:0.1:0.5]./100.0869.*1000; % mM
x_crb_plt = [0,0.55]./100.0869.*1000; % mM

labels = {'3 T','7 T'};  

%% USPIO

data_3T = csvread('USPIO_R2star_3T.csv',1,9);
data_7T = csvread('USPIO_R2star_7T.csv',1,9);

y3_usp_mean = data_3T(:,1);
y3_usp_SD = data_3T(:,2);
y7_usp_mean = data_7T(:,1);
y7_usp_SD = data_7T(:,2);

y3_usp_mdl = fitlm(x_usp,y3_usp_mean);
y7_usp_mdl = fitlm(x_usp,y7_usp_mean);
y3_usp_line = y3_usp_mdl.Coefficients{2,1}.*x_usp_plt + y3_usp_mdl.Coefficients{1,1};
y7_usp_line = y7_usp_mdl.Coefficients{2,1}.*x_usp_plt + y7_usp_mdl.Coefficients{1,1};
f = fittype('a*x+b');
c_algo1 = fit(transpose(x_usp),(y3_usp_mean),f);
algo1_PI95 = predint(c_algo1,x_usp); 
c_algo2 = fit(transpose(x_usp),(y7_usp_mean),f);
algo2_PI95 = predint(c_algo2,x_usp);

s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);

err1 = errorbar(x_usp,y3_usp_mean,y3_usp_SD,y3_usp_SD,uncert_usp,uncert_usp,'o');
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_usp,y7_usp_mean,y7_usp_SD,y7_usp_SD,uncert_usp,uncert_usp,'o');
err2.Color = "r";
err2.CapSize = 30;
hold on

p_main = plot(x_usp,y3_usp_mean,x_usp,y7_usp_mean);
p_main(1).Marker = '.';
p_main(1).MarkerSize = 30;
p_main(2).Marker = '.';
p_main(2).MarkerSize = 30;
p_main(1).MarkerEdgeColor = 'b';
p_main(2).MarkerEdgeColor = 'r';
p_main(1).MarkerFaceColor = 'b';
p_main(2).MarkerFaceColor = 'r';
p_main(1).LineStyle = 'none';
p_main(2).LineStyle = 'none';
hold on

p_regression = plot(x_usp_plt,y3_usp_line,x_usp_plt,y7_usp_line);
p_regression(1).LineStyle = '--';
p_regression(1).Color = "b";
p_regression(2).LineStyle = '--';
p_regression(2).Color = "r";
pbaspect([1 1 1])
hold on

p_CI = plot(x_usp,algo1_PI95,x_usp,algo2_PI95);
p_CI(1,1).Color = "b";
p_CI(2,1).Color = "b";
p_CI(3,1).Color = "r";
p_CI(4,1).Color = "r";
 
legend(labels,'Location','northwest','interpreter','latex','FontSize',32);
xlim([0 0.8])
ylim([0 75]);

xlabel('[cFe] ($\mu$M)','interpreter','latex','fontsize',32);
ylabel('R$_2^*$ ($s^{-1}$)','interpreter','latex','FontSize', 32)

xticks([0, 0.1 0.2 0.3 0.4 0.5 0.6 0.7])
xticklabels({'0', '0.1', '0.2', '0.3', '0.4', '0.5', '0.6','0.7'})
yticks([0, 20, 40, 60]);
yticklabels({'0', '20', '40', '60'});

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 32;
% Save data
saveas(gcf,strcat(output_dir,filename,'_USPIO_scatter.png'));

%% FERRITIN

data_3T = csvread('Ferritin_R2star_3T.csv',1,9);
data_7T = csvread('Ferritin_R2star_7T.csv',1,9);

y3_fer_mean = data_3T(:,1);
y3_fer_SD = data_3T(:,2);
y7_fer_mean = data_7T(:,1);
y7_fer_SD = data_7T(:,2);

y3_fer_mdl = fitlm(x_fer,y3_fer_mean);
y7_fer_mdl = fitlm(x_fer,y7_fer_mean);
y3_fer_line = y3_fer_mdl.Coefficients{2,1}.*x_fer_plt + y3_fer_mdl.Coefficients{1,1};
y7_fer_line = y7_fer_mdl.Coefficients{2,1}.*x_fer_plt + y7_fer_mdl.Coefficients{1,1};
f = fittype('a*x+b');
c_algo3 = fit(transpose(x_fer),(y3_fer_mean),f);
algo3_PI95 = predint(c_algo3,x_fer); 
c_algo4 = fit(transpose(x_fer),(y7_fer_mean),f);
algo4_PI95 = predint(c_algo4,x_fer);

s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);

err1 = errorbar(x_fer,y3_fer_mean,y3_fer_SD,y3_fer_SD,uncert_fer,uncert_fer,'o');
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_fer,y7_fer_mean,y7_fer_SD,y7_fer_SD,uncert_fer,uncert_fer,'o');
err2.Color = "r";
err2.CapSize = 30;
hold on

p_main = plot(x_fer,y3_fer_mean,x_fer,y7_fer_mean);
p_main(1).Marker = '.';
p_main(1).MarkerSize = 30;
p_main(2).Marker = '.';
p_main(2).MarkerSize = 30;
p_main(1).MarkerEdgeColor = 'b';
p_main(2).MarkerEdgeColor = 'r';
p_main(1).MarkerFaceColor = 'b';
p_main(2).MarkerFaceColor = 'r';
p_main(1).LineStyle = 'none';
p_main(2).LineStyle = 'none';
hold on

p_regression = plot(x_fer_plt,y3_fer_line,x_fer_plt,y7_fer_line);
p_regression(1).LineStyle = '--';
p_regression(1).Color = "b";
p_regression(2).LineStyle = '--';
p_regression(2).Color = "r";
pbaspect([1 1 1])
hold on

p_CI = plot(x_fer,algo3_PI95,x_fer,algo4_PI95);
p_CI(1,1).Color = "b";
p_CI(2,1).Color = "b";
p_CI(3,1).Color = "r";
p_CI(4,1).Color = "r";
 
legend(labels,'Location','northwest','FontSize', 32,'interpreter','latex');
xlim([0 12]);
ylim([0 45]);

xlabel('[cFe] ($\mu$M)','interpreter','latex','fontsize',32);
ylabel('R$_2^*$ ($s^{-1}$)','interpreter','latex','FontSize', 32);

xticks = ([0 2 4 6 8 10]);
xticklabels = ({'0', '2', '4', '6', '8', '10'});
yticks([0 10 20 30 40])
yticklabels({'0','10','20','30','40'});

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 32;

saveas(gcf,strcat(output_dir,filename,'_Ferritin_scatter.png'));

%% CALCIUM CHLORIDE

data_3T = csvread('CaCl2_R2star_3T.csv',1,9);
data_7T = csvread('CaCl2_R2star_7T.csv',1,9);

y3_chl_mean = data_3T(:,1);
y3_chl_SD = data_3T(:,2);
y7_chl_mean = data_7T(:,1);
y7_chl_SD = data_7T(:,2);

ratio_FS = (y7_chl_mean-y3_chl_mean);

y3_chl_M_avg = mean(y3_chl_mean);
y3_chl_SD_avg = std(y3_chl_mean);
y7_chl_M_avg = mean(y7_chl_mean);
y7_chl_SD_avg = std(y7_chl_mean);

y3_chl_mdl = fitlm(x_chl,y3_chl_mean);
y7_chl_mdl = fitlm(x_chl,y7_chl_mean);
y3_chl_line = y3_chl_mdl.Coefficients{2,1}.*x_chl_plt + y3_chl_mdl.Coefficients{1,1};
y7_chl_line = y7_chl_mdl.Coefficients{2,1}.*x_chl_plt + y7_chl_mdl.Coefficients{1,1};
f = fittype('a*x+b');
c_algo5 = fit(transpose(x_chl),(y3_chl_mean),f);
algo5_PI95 = predint(c_algo5,x_chl); 
c_algo6 = fit(transpose(x_chl),(y7_chl_mean),f);
algo6_PI95 = predint(c_algo6,x_chl);

s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);

err1 = errorbar(x_chl,y3_chl_mean,y3_chl_SD,y3_chl_SD,'o');
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_chl,y7_chl_mean,y7_chl_SD,y7_chl_SD,'o');
err2.Color = "r";
err2.CapSize = 30;
hold on

p_main = plot(x_chl,y3_chl_mean,x_chl,y7_chl_mean);
p_main(1).Marker = '.';
p_main(1).MarkerSize = 30;
p_main(2).Marker = '.';
p_main(2).MarkerSize = 30;
p_main(1).MarkerEdgeColor = 'b';
p_main(2).MarkerEdgeColor = 'r';
p_main(1).MarkerFaceColor = 'b';
p_main(2).MarkerFaceColor = 'r';
p_main(1).LineStyle = 'none';
p_main(2).LineStyle = 'none';
hold on

p_regression = plot(x_chl_plt,y3_chl_line,x_chl_plt,y7_chl_line);
p_regression(1).LineStyle = '--';
p_regression(1).Color = "b";
p_regression(2).LineStyle = '--';
p_regression(2).Color = "r";
pbaspect([1 1 1])
hold on

p_CI = plot(x_chl,algo5_PI95,x_chl,algo6_PI95);
p_CI(1,1).Color = "b";
p_CI(2,1).Color = "b";
p_CI(3,1).Color = "r";
p_CI(4,1).Color = "r";

legend(labels,'Location','northwest','FontSize', 32,'interpreter','latex');
xlim([0 4]);
ylim([0 20]);

xticks([0 0.9 1.8 2.7 3.6])
xticklabels({'0', '0.9', '1.8', '2.7', '3.6'})

xlabel('CaCl$_{2}$ (mM)','interpreter','latex','FontSize', 32);
ylabel('R$_2^*$ ($s^{-1}$)','interpreter','latex','FontSize', 32);

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 32;

saveas(gcf,strcat(output_dir,filename,'_CaCl2_scatter.png'));

%% CALCIUM CARBONATE

data_3T = csvread('CaCO3_R2star_3T.csv',1,9);
data_7T = csvread('CaCO3_R2star_7T.csv',1,9);

y3_crb_mean = data_3T(:,1);
y3_crb_SD = data_3T(:,2);
y7_crb_mean = data_7T(:,1);
y7_crb_SD = data_7T(:,2);
y3_crb_mdl = fitlm(x_crb,y3_crb_mean);
y7_crb_mdl = fitlm(x_crb,y7_crb_mean);
y3_crb_line = y3_crb_mdl.Coefficients{2,1}.*x_crb_plt + y3_crb_mdl.Coefficients{1,1};
y7_crb_line = y7_crb_mdl.Coefficients{2,1}.*x_crb_plt + y7_crb_mdl.Coefficients{1,1};
f = fittype('a*x+b');
c_algo7 = fit(transpose(x_crb),(y3_crb_mean),f);
algo7_PI95 = predint(c_algo7,x_crb); 
c_algo8 = fit(transpose(x_crb),(y7_crb_mean),f);
algo8_PI95 = predint(c_algo8,x_crb);

s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);

err1 = errorbar(x_crb,y3_crb_mean,y3_crb_SD,y3_crb_SD,'o');
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_crb,y7_crb_mean,y7_crb_SD,y7_crb_SD,'o');
err2.Color = "r";
err2.CapSize = 30;
hold on

p_main = plot(x_crb,y3_crb_mean,x_crb,y7_crb_mean);
p_main(1).Marker = '.';
p_main(1).MarkerSize = 30;
p_main(2).Marker = '.';
p_main(2).MarkerSize = 30;
p_main(1).MarkerEdgeColor = 'b';
p_main(2).MarkerEdgeColor = 'r';
p_main(1).MarkerFaceColor = 'b';
p_main(2).MarkerFaceColor = 'r';
p_main(1).LineStyle = 'none';
p_main(2).LineStyle = 'none';
hold on

p_regression = plot(x_crb_plt,y3_crb_line,x_crb_plt,y7_crb_line);
p_regression(1).LineStyle = '--';
p_regression(1).Color = "b";
p_regression(2).LineStyle = '--';
p_regression(2).Color = "r";
pbaspect([1 1 1])
hold on

p_CI = plot(x_crb,algo7_PI95,x_crb,algo8_PI95);
p_CI(1,1).Color = "b";
p_CI(2,1).Color = "b";
p_CI(3,1).Color = "r";
p_CI(4,1).Color = "r";

legend(labels,'Location','northwest','FontSize', 32,'interpreter','latex');
xlim([0 6]);
ylim([-50 550]);

xticks([0 1 2 3 4 5])
xticklabels({'0', '1', '2', '3', '4', '5'})
yticks([0 100 200 300 400 500])
yticklabels({'0', '100', '200', '300', '400', '500'});

xlabel('CaCO$_{3}$ (mM)','interpreter','latex','FontSize', 32);
ylabel('R$_2^*$ ($s^{-1}$)','interpreter','latex','FontSize', 32);

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 32;

% Save data
saveas(gcf,strcat(output_dir,filename,'_CaCO3_scatter.png'));