%% QSM_Scatter_Carbonate.m
% Linear regression between iron concentration and QSM

clc
clearvars
close all
%%
cd C:\vnm\Data
filename = 'Carbonate';
output_dir = 'C:\Users\s4601543\Downloads\';

% 10 wt.\% = 10 g/100mL = 0.1 g/mL
% molar mass: 100.0869 g/mol
x_crb = [0.1:0.1:0.5]./100.0869.*1000; % mM
x_crb_plt = [0,0.55]./100.0869.*1000; % mM

data_3T = csvread('CaCO3_QSM_3T.csv',2,10);
data_7T = csvread('CaCO3_QSM_7T.csv',2,10);

y3_crb_mean = data_3T(:,1);
y3_crb_SD = data_3T(:,2);
y7_crb_mean = data_7T(:,1);
y7_crb_SD = data_7T(:,2);

%% Obtain coefficient
y3_mdl = fitlm(x_crb,y3_crb_mean);
y7_mdl = fitlm(x_crb,y7_crb_mean);

%% Obtain line-of-best-fit

y3_line =  y3_mdl.Coefficients{2,1}.*x_crb_plt + y3_mdl.Coefficients{1,1};
y7_line =  y7_mdl.Coefficients{2,1}.*x_crb_plt + y7_mdl.Coefficients{1,1};

%% Obtain prediction bounds
f = fittype('a*x+b');
c_algo1 = fit(transpose(x_crb),(y3_crb_mean),f);
algo1_PI95 = predint(c_algo1,x_crb); 

c_algo2 = fit(transpose(x_crb),(y7_crb_mean),f);
algo2_PI95 = predint(c_algo2,x_crb);

%% Exp'm
s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);
pbaspect([1 1 1])

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
p_main(1).MarkerEdgeColor = "b";
p_main(2).MarkerEdgeColor = "r";
p_main(1).MarkerFaceColor = "b";
p_main(2).MarkerFaceColor = "r";
p_main(1).LineStyle = 'none';
p_main(2).LineStyle = 'none';
hold on

p_regression = plot(x_crb_plt,y3_line,x_crb_plt,y7_line);
p_regression(1).LineStyle = '--';
p_regression(1).Color = "b";
p_regression(2).LineStyle = '--';
p_regression(2).Color = "r";
pbaspect([1 1 1])
hold on

p_CI = plot(x_crb,algo1_PI95,x_crb,algo2_PI95);
p_CI(1,1).Color = "b";
p_CI(2,1).Color = "b";
p_CI(3,1).Color = "r";
p_CI(4,1).Color = "r";

xlim([0 6]);
ylim([-0.65 0.25]);

xlabel('CaCO$_{3}$ (mM)','interpreter','latex','fontsize',32);
ylabel('$\chi$ (ppm)','interpreter','latex','fontsize',32)

xticks([0 1 2 3 4 5])
xticklabels({'0', '1', '2', '3', '4', '5'})
yticks([-0.6 -0.4 -0.2 0 0.2])
yticklabels({'-0.6', '-0.4', '-0.2', '0', '0.2'})

legend({'3 T','7 T'},'location','northeast','FontSize', 32,'interpreter','latex');
ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 32;
% Save data
saveas(gcf,strcat(output_dir,filename,'_QSM_scatter.png'));
