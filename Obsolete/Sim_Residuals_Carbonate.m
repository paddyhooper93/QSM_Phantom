%% QSM_Scatter_Carbonate.m
% Linear regression between iron concentration and QSM

clc
clearvars

filename = 'Carbonate_Simulated';
output_dir = 'C:\Users\s4601543\Downloads\';

x_crb = 10:10:50;
x_crb_plt = [0,55];

sim_3_crb =     [.17 .09 .00 -.09 -.17]; 
sim_3_crb_err = [.02 .03  .03  .05  .07];
expm_3_crb =    [.14 -.08 -.13 -.28  -.48];
gt_3_crb =      -0.01.*x_crb + 0.3;
gt_3_crb_plt =  -0.01.*x_crb_plt + 0.3;

sim_7_crb =     [.08 .00 -.08 -.17 -.25]; 
sim_7_crb_err = [.02  .02  .02  .04  .07]; 
expm_7_crb =    [.11 -.08 -.12 -.25 -.41];
gt_7_crb =      -0.01*x_crb + 0.2;
gt_7_crb_plt =  -0.01*x_crb_plt + 0.2;

%% Obtain coefficient
y3_sim = fitlm(x_crb,sim_3_crb);
y7_sim = fitlm(x_crb,sim_7_crb);

y3_sim_fit  =  y3_sim.Coefficients{2,1}.*x_crb_plt + y3_sim.Coefficients{1,1};
y7_sim_fit  =  y7_sim.Coefficients{2,1}.*x_crb_plt + y7_sim.Coefficients{1,1};

y3_gt = fitlm(x_crb ,gt_3_crb);
y7_gt = fitlm(x_crb ,gt_7_crb);

plt3_gt = y3_gt.Coefficients{2,1}.*x_crb_plt + y3_gt.Coefficients{1,1};
plt7_gt = y7_gt.Coefficients{2,1}.*x_crb_plt + y7_gt.Coefficients{1,1};

gt_sim_3_crb = (gt_3_crb - sim_3_crb);
gt_sim_7_crb = (gt_7_crb - sim_7_crb);

GT_SIM_3 = fitlm(x_crb,gt_sim_3_crb);
GT_SIM_7 = fitlm(x_crb,gt_sim_7_crb);

fit3_gt_sim = GT_SIM_3.Coefficients{2,1}.*x_crb  + GT_SIM_3.Coefficients{1,1};
fit7_gt_sim = GT_SIM_7.Coefficients{2,1}.*x_crb  + GT_SIM_7.Coefficients{1,1};

plt3_gt_sim = GT_SIM_3.Coefficients{2,1}.*x_crb_plt  + GT_SIM_3.Coefficients{1,1};
plt7_gt_sim = GT_SIM_7.Coefficients{2,1}.*x_crb_plt  + GT_SIM_7.Coefficients{1,1};

ratio_3T = GT_SIM_3.Coefficients{2,1} / -0.01;
ratio_7T = GT_SIM_7.Coefficients{2,1} / -0.01;

%% Obtain prediction bounds
f = fittype('a*x+b');
c_algo1 = fit(transpose(x_crb),transpose(sim_3_crb),f);
algo1_PI95 = predint(c_algo1,x_crb); 

c_algo2 = fit(transpose(x_crb),transpose(sim_7_crb),f);
algo2_PI95 = predint(c_algo2,x_crb);

c_algo3 = fit(transpose(x_crb),transpose(gt_sim_3_crb),f);
algo3_PI95 = predint(c_algo3,x_crb);

c_algo4 = fit(transpose(x_crb),transpose(gt_sim_7_crb),f);
algo4_PI95 = predint(c_algo4,x_crb);


%% Scatter plot

t = tiledlayout(3,2,'TileSpacing','tight','Padding','tight');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
hold on

%% 'Simulated_3T
ax1 = nexttile([1 2]);

err1 = errorbar(ax1,x_crb,sim_3_crb,sim_3_crb_err,sim_3_crb_err,'o');
err1.Color = "b";
err1.MarkerSize = 10;
hold on

p11 = scatter(ax1,x_crb,gt_3_crb,'filled','MarkerFaceColor',"b");
p11.SizeData = 100;
hold on

p5 = plot(ax1,x_crb_plt,plt3_gt);
p5.LineStyle = '-.';
p5.Color = "b";

p1 = plot(ax1,x_crb_plt,y3_sim_fit);

p1.LineStyle = '--';
p1.Color = "b";
hold on

p3 = plot(ax1,x_crb,algo1_PI95);
p3(1,1).Color = "b";
p3(2,1).Color = "b";
hold on

xlim([0 50]);
ylim([-0.6 0.3]);

grid on
box on

ax1 = gca; % current axes
ax1.FontSizeMode = 'manual';
ax1.FontSize = 16;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

xlabel('CaCO$_{3}$ (wt.\%)','interpreter','latex','fontsize',22);
ylabel('$\chi$ (ppm)','interpreter','latex','fontsize',22);

xticks([0 10 20 30 40 50])
xticklabels({'0', '10', '20', '30', '40', '50'})

legend({'3 T, QSM','3 T, $\chi$'},'interpreter','latex','fontsize',22)

%% 'Simulated_7T
ax2 = nexttile([1 2]);

err2 = errorbar(ax2,x_crb,sim_7_crb,sim_7_crb_err,sim_7_crb_err,'o');
err2.Color = [0 0 0];
err2.MarkerSize = 10;
hold on

p12 = scatter(ax2,x_crb,gt_7_crb,'filled','MarkerFaceColor',[0 0 0]);
p12.SizeData = 100;
hold on

p6 = plot(ax2,x_crb_plt,plt7_gt);
p6.LineStyle = '-.';
p6.Color = [0 0 0];

p2 = plot(ax2,x_crb_plt,y7_sim_fit);

p2.LineStyle = '--';
p2.Color = [0 0 0];
hold on

p4 = plot(ax2,x_crb,algo2_PI95);
p4(1,1).Color = [0 0 0];
p4(2,1).Color = [0 0 0];
hold on

xlim([0 50]);
ylim([-0.6 0.3]);

grid on
box on

ax2 = gca; % current axes
ax2.FontSizeMode = 'manual';
ax2.FontSize = 18;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

xlabel('CaCO$_{3}$ (wt.\%)','interpreter','latex','fontsize',22);
ylabel('$\chi$ (ppm)','interpreter','latex','fontsize',22);

xticks([0 10 20 30 40 50])
xticklabels({'0', '10', '20', '30', '40', '50'})

legend({'7 T, QSM','7 T, $\chi$'},'interpreter','latex','fontsize',22)


%% Residuals
ax3 = nexttile;
residuals_3T = transpose(y3_sim.Residuals{:,1});
p21 = scatter(ax3,x_crb,residuals_3T,'filled','diamond','MarkerFaceColor',"b",'SizeData',100);
ax3 = gca; % current axes
ax3.FontSizeMode = 'manual';
ax3.FontSize = 16;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)
xlabel('CaCO$_{3}$ (wt.\%)', 'interpreter','latex','fontsize',22);
ylabel('Raw residuals (ppm)','interpreter','latex','fontsize',22)
xlim([0 50]);
ylim([-0.01 0.01]);
xticks([0 10 20 30 40 50])
xticklabels({'0', '10', '20', '30', '40', '50'})
yticks([-0.01 -0.005 0 0.005 0.01]);
yticklabels({'-0.01', '-0.005', '0', '0.005', '0.01'});
grid on
box on
hold on
ax5 = nexttile;
residuals_3T = transpose(y3_sim.Residuals{:,3});
p21 = scatter(ax5,x_crb,residuals_3T,'filled','diamond','MarkerFaceColor',"b",'SizeData',100);
ax5 = gca; % current axes
ax5.FontSizeMode = 'manual';
ax5.FontSize = 16;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)
xlabel('CaCO$_{3}$ (wt.\%)', 'interpreter','latex','fontsize',22);
ylabel('Studentized residuals','interpreter','latex','fontsize',22)
xlim([0 50]);
xticks([0 10 20 30 40 50])
xticklabels({'0', '10', '20', '30', '40', '50'})
ylim([-6 6]);
yticks([-6,-3,0,3,6]);
yticklabels({'-6', '-3', '0', '3', '6'});
grid on
box on
hold on

ax4 = nexttile;
residuals_7T = transpose(y7_sim.Residuals{:,1});
p22 = scatter(ax4,x_crb,residuals_7T,'filled','diamond','MarkerFaceColor',"k",'SizeData',100);
ax4 = gca; % current axes
ax4.FontSizeMode = 'manual';
ax4.FontSize = 16;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)
xlabel('CaCO$_{3}$ (wt.\%)', 'interpreter','latex','fontsize',22);
ylabel('Raw residuals (ppm)','interpreter','latex','fontsize',22)
xlim([0 50]);
ylim([-0.01 0.01]);
xticks([0 10 20 30 40 50])
xticklabels({'0', '10', '20', '30', '40', '50'})
yticks([-0.01 -0.005 0 0.005 0.01]);
yticklabels({'-0.01', '-0.005', '0', '0.005', '0.01'});
box on
grid on
ax6 = nexttile;
residuals_7T = transpose(y7_sim.Residuals{:,3});
p22 = scatter(ax6,x_crb,residuals_7T,'filled','diamond','MarkerFaceColor',"k",'SizeData',100);
ax6 = gca; % current axes
ax6.FontSizeMode = 'manual';
ax6.FontSize = 16;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)
xlabel('CaCO$_{3}$ (wt.\%)', 'interpreter','latex','fontsize',22);
ylabel('Studentized residuals','interpreter','latex','fontsize',22)
xlim([0 50]);
xticks([0 10 20 30 40 50])
xticklabels({'0', '10', '20', '30', '40', '50'})
ylim([-6 6]);
yticks([-6,-3,0,3,6]);
yticklabels({'-6', '-3', '0', '3', '6'});
grid on
box on
%% Save data
saveas(gcf,strcat(output_dir,filename,'_ResidualPlot.jpg'));
