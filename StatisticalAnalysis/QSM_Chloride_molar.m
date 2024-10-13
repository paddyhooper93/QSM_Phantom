%% QSM_Scatter_Chloride.m
% Linear regression between iron concentration and Chi

clc
clearvars
close all
%%
cd C:\Users\rosly\Documents\Data
output_dir = 'C:\Users\rosly\Documents\Data\';
filename = 'Chloride';

% 10 wt.\% = 10 g/100mL = 0.1 g/mL
% molar mass: 110.98 g/mol
x_chl = (0.1:0.1:0.4)./110.98.*1000; % mol/L
x_chl_plt = [0,0.45]./110.98.*1000; % mol/L

data_3T = csvread('CaCl2_QSM_3T.csv',2,10);
data_7T = csvread('CaCl2_QSM_7T.csv',2,10);

y3_chl_mean = data_3T(:,1);
y3_chl_SD = data_3T(:,2);
y7_chl_mean = data_7T(:,1);
y7_chl_SD = data_7T(:,2);

%% Obtain coefficient
y3_mdl_spu = fitlm(x_chl,y3_chl_mean);
y7_mdl_spu = fitlm(x_chl,y7_chl_mean);
y3_line_spu =  y3_mdl_spu.Coefficients{2,1}.*x_chl_plt + y3_mdl_spu.Coefficients{1,1};
y7_line_spu =  y7_mdl_spu.Coefficients{2,1}.*x_chl_plt + y7_mdl_spu.Coefficients{1,1};

%% Obtain prediction bounds
f = fittype('a*x+b');
c_algo1 = fit(transpose(x_chl),(y3_chl_mean),f);
algo1_PI95 = predint(c_algo1,x_chl); 

c_algo2 = fit(transpose(x_chl),(y7_chl_mean),f);
algo2_PI95 = predint(c_algo2,x_chl);

%% 3 T Exp'm

s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);
pbaspect([1 1 1])

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
p_main(1).MarkerEdgeColor = "b";
p_main(2).MarkerEdgeColor = "r";
p_main(1).MarkerFaceColor = "b";
p_main(2).MarkerFaceColor = "r";
p_main(1).LineStyle = 'none';
p_main(2).LineStyle = 'none';
hold on


p_regression = plot(x_chl_plt,y3_line_spu,x_chl_plt,y7_line_spu);
p_regression(1).LineStyle = '--';
p_regression(1).Color = "b";
p_regression(2).LineStyle = '--';
p_regression(2).Color = "r";
pbaspect([1 1 1])
hold on

p_CI = plot(x_chl,algo1_PI95,x_chl,algo2_PI95);
p_CI(1,1).Color = "b";
p_CI(2,1).Color = "b";
p_CI(3,1).Color = "r";
p_CI(4,1).Color = "r";


xlim([0 4]);
ylim([-1.6 0]);

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 32;

xlabel('CaCl$_{2}$ (mM)','interpreter','latex','fontsize',32);
ylabel('$\chi$ (ppm)','interpreter','latex','fontsize',32)

xticks([0 0.9 1.8 2.7 3.6])
xticklabels({'0', '0.9', '1.8', '2.7', '3.6'})
yticks([-1.6, -1.2, -.8, -.4, 0])
yticklabels({'-1.6','-1.2', '-0.8', '-0.4', '0'})

legend({'3 T','7 T'},'location','northeast','FontSize', 32,'interpreter','latex');

% Save data
saveas(gcf,strcat(output_dir,filename,'_QSM_scatter.png'));
