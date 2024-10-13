%% QSM_Scatter_USPIO.m
% Linear regression between iron concentration and Chi

clc
clearvars
close all
%%
cd C:\Users\rosly\Documents\L1\L1_Data
output_dir = 'C:\Users\rosly\Documents\L1\L1_Data\';
filename = 'USPIO';

x_usp = 1.25 .* (10 : 5 : 30) ./ 55.845; % mmol/L
uncert = [3.44 3.80 4.32 4.78 5.34] ./ 55.845;
x_usp_plt = (0:6.25:43.75) ./ 55.845;

USP_3T = csvread('USPIO_QSM_3T.csv',2,4,[2 4 6 9]);
USP_7T = csvread('USPIO_QSM_7T.csv',2,4,[2 4 6 9]);
USP_3T_OverL = mean(USP_3T(:,1:5:2),2);
USP_7T_OverL = mean(USP_7T(:,1:5:2),2);
USP_3T_SD    = mean(USP_3T(:,2:6:2),2);
USP_7T_SD    = mean(USP_7T(:,2:6:2),2);

%% Obtain coefficient
y3_mdl_lm = fitlm(x_usp,USP_3T_OverL);
y7_mdl_lm = fitlm(x_usp,USP_7T_OverL);

spu_3_plt = y3_mdl_lm.Coefficients{2,1}.* x_usp_plt + y3_mdl_lm.Coefficients{1,1};
spu_7_plt = y7_mdl_lm.Coefficients{2,1}.* x_usp_plt + y7_mdl_lm.Coefficients{1,1};

% Test for linearity
modelfun = @(b,x)(b(1)+b(2).*x+b(3).*x.^2);
beta0 = [0,1,0];
y3_mdl_nlm = fitnlm(x_usp,USP_3T_OverL,modelfun,beta0);
y7_mdl_nlm = fitnlm(x_usp,USP_7T_OverL,modelfun,beta0);

% Test for influential and outlying points
% Cook's D threshold (influential points): 50th percentile of the F-dist.
% For n = 5, p = 1; v1 = 2, v2 = 3
t_cookd = finv(0.5,2,3);
ind_y3_infl = find(y3_mdl_lm.Diagnostics.CooksDistance > t_cookd);
ind_y7_infl = find(y7_mdl_lm.Diagnostics.CooksDistance > t_cookd);
% plotDiagnostics(y7_mdl_lm,'cookd')
% legend('show')

% Stud. Res threshold (outlying points): 95th percentile of t-dist. 
% For n = 5, p = 1; v = 4
t_stud_res = tinv(0.95,4);
ind_y3_outlier = find(y3_mdl_lm.Residuals.Studentized > t_stud_res);
ind_y7_outlier = find(y7_mdl_lm.Residuals.Studentized > t_stud_res);
% plotResiduals(y7_mdl_lm,'fitted','ResidualType','studentized')
% legend('show')

% Robust fit for linear regression
y3_mdl_lm_robust = fitlm(x_usp,USP_3T_OverL,'RobustOpts','on');
y7_mdl_lm_robust = fitlm(x_usp,USP_7T_OverL,'RobustOpts','on');


%% Obtain prediction bounds
f = fittype('a*x+b');
c_algo1 = fit(transpose(x_usp),USP_3T_OverL,f);
algo1_PI95 = predint(c_algo1,x_usp); 

c_algo2 = fit(transpose(x_usp),USP_7T_OverL,f);
algo2_PI95 = predint(c_algo2,x_usp);

%% Experimental

s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);


err1 = errorbar(x_usp,USP_3T_OverL,USP_3T_SD,USP_3T_SD,uncert,uncert,'o');
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_usp,USP_7T_OverL,USP_7T_SD,USP_7T_SD,uncert,uncert,'o');
err2.Color = "r";
err2.CapSize = 30;
hold on


p_main = plot(x_usp,USP_3T_OverL,x_usp,USP_7T_OverL);
p_main(1).Marker = '.';
p_main(1).MarkerSize = 30;
p_main(2).Marker = '.';
p_main(2).MarkerSize = 30;
p_main(1).MarkerEdgeColor = "b";
p_main(2).MarkerEdgeColor = "r";
p_main(1).MarkerFaceColor = "b";
p_main(2).MarkerFaceColor = "r";
p_main(1).LineStyle = 'none';
p_main(2).LineStyle = 'none';
hold on


p_regression = plot(x_usp_plt,spu_3_plt,x_usp_plt,spu_7_plt);
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

xlim([0 0.8])
ylim([0 1.7]);

xlabel('[cFe] ($\mu$M)','interpreter','latex','fontsize',32);
ylabel('$\chi$ (ppm)','interpreter','latex','fontsize',32)
xticks([0, 0.1 0.2 0.3 0.4 0.5 0.6 0.7])
xticklabels({'0', '0.1', '0.2', '0.3', '0.4', '0.5', '0.6','0.7'})
yticks([0 .4 .8 1.2 1.6]);
yticklabels({'0', '0.4', '0.8', '1.2', '1.6'});

legend({'3 T','7 T'},'location','northwest','FontSize', 32,'interpreter','latex');

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 32;
saveas(gcf,strcat(output_dir,filename,'_QSM_scatter.png'));

