%% QSM_Scatter_USPIO_Sim_AbsDiff.m
% Linear regression between iron concentration and QSM

clc
clearvars

filename = 'USPIO_Simulated';
output_dir = 'C:\Users\s4601543\Downloads\';

x_usp = 0.0125:0.00625:0.0375;
x_usp_plt = 0:0.00625:0.04375;

sim_3_usp =     [.57 .74 .90 1.05 1.22]; 
gt_3_usp =      31.2.*x_usp  + 0.3;
sim_3_usp_err = [.01 .01 .02 .02 .03]; 
expm_3_usp =    [0.64 0.88 1.16 1.25 1.43];

sim_7_usp =     [.30 .37 .45 .51 .58]; 
gt_7_usp =      13.6.*x_usp  + 0.2;
sim_7_usp_err = [.01 .02 .02 .02 .02]; 
expm_7_usp =    [0.39 0.49 0.60 0.66 0.73];


%% Obtain coefficient
y3_sim = fitlm(x_usp,sim_3_usp);
y7_sim = fitlm(x_usp,sim_7_usp);

y3_sim_fit = y3_sim.Coefficients{2,1}.*x_usp_plt + y3_sim.Coefficients{1,1};
y7_sim_fit = y7_sim.Coefficients{2,1}.*x_usp_plt + y7_sim.Coefficients{1,1};

y3_gt = fitlm(x_usp ,gt_3_usp);
y7_gt = fitlm(x_usp ,gt_7_usp);

plt3_gt = y3_gt.Coefficients{2,1}.*x_usp_plt + y3_gt.Coefficients{1,1};
plt7_gt = y7_gt.Coefficients{2,1}.*x_usp_plt + y7_gt.Coefficients{1,1};

gt_sim_3_usp =  (gt_3_usp - sim_3_usp);
gt_sim_7_usp =  (gt_7_usp - sim_7_usp);

GT_SIM_3 = fitlm(x_usp,gt_sim_3_usp);
GT_SIM_7 = fitlm(x_usp,gt_sim_7_usp);

fit3_gt_sim = GT_SIM_3.Coefficients{2,1}.*x_usp  + GT_SIM_3.Coefficients{1,1};
fit7_gt_sim = GT_SIM_7.Coefficients{2,1}.*x_usp  + GT_SIM_7.Coefficients{1,1};

plt3_gt_sim = GT_SIM_3.Coefficients{2,1}.*x_usp_plt  + GT_SIM_3.Coefficients{1,1};
plt7_gt_sim = GT_SIM_7.Coefficients{2,1}.*x_usp_plt  + GT_SIM_7.Coefficients{1,1};

ratio_3T = GT_SIM_3.Coefficients{2,1} / 31.2;
ratio_7T = GT_SIM_7.Coefficients{2,1} / 13.6;

%% Obtain prediction bounds
f = fittype('a*x+b');
c_algo1 = fit(transpose(x_usp),transpose(sim_3_usp),f);
algo1_PI95 = predint(c_algo1,x_usp); 

c_algo2 = fit(transpose(x_usp),transpose(sim_7_usp),f);
algo2_PI95 = predint(c_algo2,x_usp);

c_algo3 = fit(transpose(x_usp),transpose(gt_sim_3_usp),f);
algo3_PI95 = predint(c_algo3,x_usp);

c_algo4 = fit(transpose(x_usp),transpose(gt_sim_7_usp),f);
algo4_PI95 = predint(c_algo4,x_usp);

%% Scatter plot

t = tiledlayout(3,2,'TileSpacing','tight','Padding','tight');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
hold on

%% 'Simulated_3T
ax1 = nexttile([1 2]);

err1 = errorbar(ax1,x_usp,sim_3_usp,sim_3_usp_err,sim_3_usp_err,'o');
err1.MarkerSize = 10;
err1.Color = "b";
err1.CapSize = 10;
hold on

p11 = scatter(ax1,x_usp,gt_3_usp,'filled','MarkerFaceColor',"b");
p11.SizeData = 100;
hold on

p3 = plot(ax1,x_usp,algo1_PI95);
p3(1,1).Color = "b";
p3(2,1).Color = "b";
hold on

p5 = plot(ax1,x_usp_plt,plt3_gt);
p5.LineStyle = '-.';
p5.Color = "b";

p1 = plot(ax1,x_usp_plt,y3_sim_fit);
p1.LineStyle = '--';
p1.Color = "b";
hold on

grid on
box on

ax2 = gca; % current axes
ax2.FontSizeMode = 'manual';
ax2.FontSize = 16;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

xlabel('$\it{[cFe]}$ ($mg.mL^{-1})$', 'interpreter','latex','fontsize',22);
ylabel('$\chi$ (ppm)','interpreter','latex','fontsize',22)

xlim([0 0.04375]);
ylim([0 1.7]);

xticks([0,0.00625,0.0125,0.01875,0.0250,0.03125,0.0375,0.04375]);
xticklabels({'0','0.0063','0.0125', '0.0188', '0.0250', '0.0313', '0.0375', '0.0438'});

legend({'3 T, QSM','3 T, $\chi_{input}$'},'location','northwest','interpreter','latex','fontsize',22)

%% 'Simulated
ax2 = nexttile([1 2]);

err2 = errorbar(ax2,x_usp,sim_7_usp,sim_7_usp_err,sim_7_usp_err,'o');
err2.MarkerSize = 10;
err2.Color = "k";
err2.CapSize = 10;
hold on

p12 = scatter(ax2,x_usp,gt_7_usp,'filled','MarkerFaceColor',[0 0 0]);
p12.SizeData = 100;
hold on

p6 = plot(ax2,x_usp_plt,plt7_gt);
p6.LineStyle = '-.';
p6.Color = [0 0 0];

p2 = plot(ax2,x_usp_plt,y7_sim_fit);
p2.LineStyle = '--';
p2.Color = [0 0 0];
hold on

p4 = plot(ax2,x_usp,algo2_PI95);
p4(1,1).Color = [0 0 0];
p4(2,1).Color = [0 0 0];
hold on

grid on

ax2 = gca; % current axes
ax2.FontSizeMode = 'manual';
ax2.FontSize = 16;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

xlabel('$\it{[cFe]}$ ($mg.mL^{-1})$', 'interpreter','latex','fontsize',22);
ylabel('$\chi$ (ppm)','interpreter','latex','fontsize',22)

xlim([0 0.04375]);
ylim([0 1.7]);

xticks([0,0.00625,0.0125,0.01875,0.0250,0.03125,0.0375,0.04375]);
xticklabels({'0','0.0063','0.0125', '0.0188', '0.0250', '0.0313', '0.0375', '0.0438'});

legend({'7 T, QSM','7 T, $\chi_{input}$'},'location','northwest','interpreter','latex','fontsize',22)
% 
%% 3T_Residuals
ax3 = nexttile;
residuals_3T = transpose(y3_sim.Residuals{:,1});
p21 = scatter(ax3,x_usp,residuals_3T,'filled','diamond','MarkerFaceColor',"b",'SizeData',100);
ax3 = gca; % current axes
ax3.FontSizeMode = 'manual';
ax3.FontSize = 16;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)
xlabel('$\it{[cFe]}$ ($mg.mL^{-1})$', 'interpreter','latex','fontsize',22);
ylabel('Raw residuals (ppm)','interpreter','latex','fontsize',22)
xlim([0 0.04375]);
ylim([-0.01 0.01]);
xticks([0,0.00625,0.0125,0.01875,0.0250,0.03125,0.0375,0.04375]);
xticklabels({'0','0.0063','0.0125', '0.0188', '0.0250', '0.0313', '0.0375', '0.0438'});
yticks([-0.01 -0.005 0 0.005 0.01]);
yticklabels({'-0.01', '-0.005', '0', '0.005', '0.01'});
grid on
box on
hold on
ax5 = nexttile;
residuals_3T = transpose(y3_sim.Residuals{:,3});
p21 = scatter(ax5,x_usp,residuals_3T,'filled','diamond','MarkerFaceColor',"b",'SizeData',100);
ax5 = gca; % current axes
ax5.FontSizeMode = 'manual';
ax5.FontSize = 16;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)
xlabel('$\it{[cFe]}$ ($mg.mL^{-1})$', 'interpreter','latex','fontsize',22);
ylabel('Studentized residuals','interpreter','latex','fontsize',22)
xlim([0 0.04375]);
ylim([-6 6]);
xticks([0,0.00625,0.0125,0.01875,0.0250,0.03125,0.0375,0.04375]);
xticklabels({'0','0.0063','0.0125', '0.0188', '0.0250', '0.0313', '0.0375', '0.0438'});
yticks([-6,-3,0,3,6]);
yticklabels({'-6', '-3', '0', '3', '6'});
grid on
box on
hold on


%% 7T_Residuals

ax4 = nexttile;
residuals_7T = transpose(y7_sim.Residuals{:,1});
p22 = scatter(ax4,x_usp,residuals_7T,'filled','diamond','MarkerFaceColor',"k",'SizeData',100);
ax4 = gca; % current axes
ax4.FontSizeMode = 'manual';
ax4.FontSize = 16;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)
xlabel('$\it{[cFe]}$ ($mg.mL^{-1})$', 'interpreter','latex','fontsize',22);
ylabel('Raw residuals (ppm)','interpreter','latex','fontsize',22)
xlim([0 0.04375]);
ylim([-0.01 0.01]);
xticks([0,0.00625,0.0125,0.01875,0.0250,0.03125,0.0375,0.04375]);
xticklabels({'0','0.0063','0.0125', '0.0188', '0.0250', '0.0313', '0.0375', '0.0438'});
yticks([-0.01 -0.005 0 0.005 0.01]);
yticklabels({'-0.01', '-0.005', '0', '0.005', '0.01'});
grid on
box on
ax6 = nexttile;
residuals_7T = transpose(y7_sim.Residuals{:,3});
p22 = scatter(ax6,x_usp,residuals_7T,'filled','diamond','MarkerFaceColor',"k",'SizeData',100);
ax6 = gca; % current axes
ax6.FontSizeMode = 'manual';
ax6.FontSize = 16;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)
xlabel('$\it{[cFe]}$ ($mg.mL^{-1})$', 'interpreter','latex','fontsize',22);
ylabel('Studentized residuals','interpreter','latex','fontsize',22)
xlim([0 0.04375]);
ylim([-12 13]);
xticks([0,0.00625,0.0125,0.01875,0.0250,0.03125,0.0375,0.04375]);
xticklabels({'0','0.0063','0.0125', '0.0188', '0.0250', '0.0313', '0.0375', '0.0438'});
yticks([-12:6:12]);
yticklabels({'-12', '-6', '0', '6', '12'});
grid on
box on

%% Save data
saveas(gcf,strcat(output_dir,filename,'_ResidualPlot.jpg'));













