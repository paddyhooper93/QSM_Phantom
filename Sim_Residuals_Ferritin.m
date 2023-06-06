%% QSM_Scatter_Ferritin.m
% Linear regression between iron concentration and QSM

clc
clearvars

filename = 'Ferritin_Simulated';
output_dir = 'C:\Users\s4601543\Downloads\';

x_fer = 0.21:0.09:0.57;
x_fer_plt = [0,0.65];

sim_3_fer =       [.41 .54 .69 .84 .97]; 
sim_3_fer_err =   [.01 .01 .01 .02 .04]; 
expm_3_fer =      [.50 .58 .87 1.04 1.12];
gt_3_fer =        1.88.*x_fer + 0.1;
gt_3_fer_plt =    1.88.*x_fer_plt + 0.1;

sim_7_fer =       [.39 .52 .66 .79 .92]; 
sim_7_fer_err =   [.01 .02 .01 .03 .03]; 
expm_7_fer =      [0.47 0.59 0.84 1.02 1.03];
gt_7_fer =        1.81.*x_fer + 0.1;
gt_7_fer_plt =    1.81.*x_fer_plt + 0.1;

%% Obtain coefficient
y3_sim = fitlm(x_fer,sim_3_fer);
y7_sim = fitlm(x_fer,sim_7_fer);

y3_sim_fit = y3_sim.Coefficients{2,1}.*x_fer_plt + y3_sim.Coefficients{1,1};
y7_sim_fit = y7_sim.Coefficients{2,1}.*x_fer_plt + y7_sim.Coefficients{1,1};

y3_gt = fitlm(x_fer ,gt_3_fer);
y7_gt = fitlm(x_fer ,gt_7_fer);

plt3_gt = y3_gt.Coefficients{2,1}.*x_fer_plt + y3_gt.Coefficients{1,1};
plt7_gt = y7_gt.Coefficients{2,1}.*x_fer_plt + y7_gt.Coefficients{1,1};

gt_sim_3_fer = (gt_3_fer - sim_3_fer)
gt_sim_7_fer = (gt_7_fer - sim_7_fer)

GT_SIM_3 = fitlm(x_fer,gt_sim_3_fer);
GT_SIM_7 = fitlm(x_fer,gt_sim_7_fer);

fit3_gt_sim = GT_SIM_3.Coefficients{2,1}.*x_fer  + GT_SIM_3.Coefficients{1,1};
fit7_gt_sim = GT_SIM_7.Coefficients{2,1}.*x_fer  + GT_SIM_7.Coefficients{1,1};

plt3_gt_sim = GT_SIM_3.Coefficients{2,1}.*x_fer_plt  + GT_SIM_3.Coefficients{1,1};
plt7_gt_sim = GT_SIM_7.Coefficients{2,1}.*x_fer_plt  + GT_SIM_7.Coefficients{1,1};

ratio_3T = GT_SIM_3.Coefficients{2,1} / 1.88;
ratio_7T = GT_SIM_7.Coefficients{2,1} / 1.81;

%% Obtain prediction bounds
f = fittype('a*x+b');
c_algo1 = fit(transpose(x_fer),transpose(sim_3_fer),f);
algo1_PI95 = predint(c_algo1,x_fer); 

c_algo2 = fit(transpose(x_fer),transpose(sim_7_fer),f);
algo2_PI95 = predint(c_algo2,x_fer);

c_algo3 = fit(transpose(x_fer),transpose(gt_sim_3_fer),f);
algo3_PI95 = predint(c_algo3,x_fer);

c_algo4 = fit(transpose(x_fer),transpose(gt_sim_7_fer),f);
algo4_PI95 = predint(c_algo4,x_fer);

%% Scatter plot

t = tiledlayout(3,2,'TileSpacing','tight','Padding','tight');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
hold on

%% 'Simulated_3T

ax1 = nexttile([1 2]);

err1 = errorbar(ax1,x_fer,sim_3_fer,sim_3_fer_err,sim_3_fer_err,'o');
err1.Color = "b";
err1.MarkerSize = 8;
hold on

p11 = scatter(ax1,x_fer,gt_3_fer,'filled','MarkerFaceColor',"b");
p11.SizeData = 100;
hold on

p5 = plot(ax1,x_fer_plt,plt3_gt);
p5.LineStyle = '-.';
p5.Color = "b";

p1 = plot(ax1,x_fer_plt,y3_sim_fit);
p1.LineStyle = '--';
p1.Color = "b";
hold on

p3 = plot(ax1,x_fer,algo1_PI95);
p3(1,1).Color = "b";
p3(2,1).Color = "b";
hold on

ax1 = gca; % current axes
ax1.FontSizeMode = 'manual';
ax1.FontSize = 16;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

grid on

xlim([0 0.6]);
ylim([0 1.4]);

xlabel('$\it{[cFe]}$ ($mg.mL^{-1})$', 'interpreter','latex','fontsize',22);
ylabel('$\chi$ (ppm)','interpreter','latex','fontsize',22)

legend({'3 T, QSM','3 T, $\chi_{input}$'},'location','northwest','interpreter','latex','fontsize',30)

%% 'Simulated_7T

ax2 = nexttile([1 2]);

err2 = errorbar(ax2,x_fer,sim_7_fer,sim_7_fer_err,sim_7_fer_err,'o');
err2.Color = [0 0 0];
err2.MarkerSize = 8;
hold on

p12 = scatter(ax2,x_fer,gt_7_fer,'filled','MarkerFaceColor',[0 0 0]);
p12.SizeData = 100;
hold on

p6 = plot(ax2,x_fer_plt,plt7_gt);
p6.LineStyle = '-.';
p6.Color = [0 0 0];

p2 = plot(ax2,x_fer_plt,y7_sim_fit);
p2.LineStyle = '--';
p2.Color = [0 0 0];
hold on

p4 = plot(ax2,x_fer,algo2_PI95);
p4(1,1).Color = [0 0 0];
p4(2,1).Color = [0 0 0];
hold on

ax2 = gca; % current axes
ax2.FontSizeMode = 'manual';
ax2.FontSize = 16;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

grid on

xlim([0 0.6]);
ylim([0 1.4]);

xlabel('$\it{[cFe]}$ ($mg.mL^{-1})$', 'interpreter','latex','fontsize',22);
ylabel('$\chi$ (ppm)','interpreter','latex','fontsize',22)

legend({'7T, QSM', '7 T, $\chi_{input}$'},'location','northwest','interpreter','latex','fontsize',30)

%% 3T_Residuals
ax3 = nexttile;
residuals_3T = transpose(y3_sim.Residuals{:,1});
p21 = scatter(ax3,x_fer,residuals_3T,'filled','diamond','MarkerFaceColor',"b",'SizeData',100);
ax3 = gca; % current axes
ax3.FontSizeMode = 'manual';
ax3.FontSize = 16;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)
xlabel('$\it{[cFe]}$ ($mg.mL^{-1})$', 'interpreter','latex','fontsize',22);
ylabel('Raw residuals (ppm)','interpreter','latex','fontsize',22)
xlim([0 0.6]);
ylim([-0.01 0.01]);
xticks([0:0.1:0.6]);
xticklabels({'0','0.1','0.2','0.3','0.4','0.5','0.6'});
yticks([-0.01:0.005:0.01]);
yticklabels({'-0.01', '-0.005', '0', '0.005', '0.01'});
grid on
box on
ax5 = nexttile;
residuals_3T = transpose(y3_sim.Residuals{:,3});
p21 = scatter(ax5,x_fer,residuals_3T,'filled','diamond','MarkerFaceColor',"b",'SizeData',100);
ax5 = gca; % current axes
ax5.FontSizeMode = 'manual';
ax5.FontSize = 16;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)
xlabel('$\it{[cFe]}$ ($mg.mL^{-1})$', 'interpreter','latex','fontsize',22);
ylabel('Studentized residuals','interpreter','latex','fontsize',22)
xlim([0 0.6]);
ylim([-6 6]);
xticks([0:0.1:0.6]);
xticklabels({'0','0.1','0.2','0.3','0.4','0.5','0.6'});
yticks([-6,-3,0,3,6]);
yticklabels({'-6', '-3', '0', '3', '6'});
grid on
box on
hold on
%% 7T_Residuals

hold on
ax4 = nexttile;
residuals_7T = transpose(y7_sim.Residuals{:,1});
p22 = scatter(ax4,x_fer,residuals_7T,'filled','diamond','MarkerFaceColor',"k",'SizeData',100);
ax4 = gca; % current axes
ax4.FontSizeMode = 'manual';
ax4.FontSize = 16;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)
xlabel('$\it{[cFe]}$ ($mg.mL^{-1})$', 'interpreter','latex','fontsize',22);
ylabel('Raw residuals (ppm)','interpreter','latex','fontsize',22)
xlim([0 0.6]);
ylim([-0.01 0.01]);
xticks([0:0.1:0.6]);
xticklabels({'0','0.1','0.2','0.3','0.4','0.5','0.6'});
yticks([-0.01 -0.005 0 0.005 0.01]);
yticklabels({'-0.01', '-0.005', '0', '0.005', '0.01'});
grid on
box on
ax6 = nexttile;
residuals_7T = transpose(y7_sim.Residuals{:,3});
p22 = scatter(ax6,x_fer,residuals_7T,'filled','diamond','MarkerFaceColor',"k",'SizeData',100);
ax6 = gca; % current axes
ax6.FontSizeMode = 'manual';
ax6.FontSize = 16;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)
xlabel('$\it{[cFe]}$ ($mg.mL^{-1})$', 'interpreter','latex','fontsize',22);
ylabel('Studentized residuals','interpreter','latex','fontsize',22)
xlim([0 0.6]);
ylim([-6 6]);
xticks([0:0.1:0.6]);
xticklabels({'0','0.1','0.2','0.3','0.4','0.5','0.6'});
yticks([-6,-3,0,3,6]);
yticklabels({'-6', '-3', '0', '3', '6'});
grid on
box on
%% Save data
saveas(gcf,strcat(output_dir,filename,'_ResidualPlot.jpg'));
