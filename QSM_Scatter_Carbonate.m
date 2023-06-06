%% QSM_Scatter_Carbonate.m
% Linear regression between iron concentration and QSM

clc
clearvars

filename = 'Carbonate';
output_dir = 'C:\Users\s4601543\Downloads\';

x_crb = 10:10:50;
x_crb_plt = [0,x_crb(end)];

expm_3_crb =     [.14 -.08 -.13 -.28  -.48];
expm_3T_crb_err = [.02  .03  .04  .05   .09];

expm_7_crb =     [.11 -.08 -.12 -.25 -.41];
expm_7T_crb_err = [.02  .03  .03  .05  .09];

%% Alternative echo time combinations: mean values 
% TE1_3_crb =      [0.21 -0.14 -0.21 -0.39 -0.62];
% interSNR_3T_crb = [0.14 -0.08 -0.13 -0.28 -0.48];
% TE1_7T_crb =      [0.15 -0.06 -0.11 -0.24 -0.42];

%% Obtain coefficient
y3_mdl = fitlm(x_crb,expm_3_crb);
y7_mdl = fitlm(x_crb,expm_7_crb);

%% Obtain line-of-best-fit

y3_line =  y3_mdl.Coefficients{2,1}.*x_crb_plt + y3_mdl.Coefficients{1,1};
y7_line =  y7_mdl.Coefficients{2,1}.*x_crb_plt + y7_mdl.Coefficients{1,1};

%% Obtain prediction bounds
f = fittype('a*x+b');
c_algo1 = fit(transpose(x_crb),transpose(expm_3_crb),f);
algo1_PI95 = predint(c_algo1,x_crb); 

c_algo2 = fit(transpose(x_crb),transpose(expm_7_crb),f);
algo2_PI95 = predint(c_algo2,x_crb);

%% Exp'm
s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);
pbaspect([1 1 1])

err1 = errorbar(x_crb,expm_3T_crb,expm_3T_crb_err,expm_3T_crb_err,'o');
err1.MarkerSize = 30;
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_crb,expm_7T_crb,expm_7T_crb_err,expm_7T_crb_err,'o');
err2.MarkerSize = 30;
err2.Color = "k";
err2.CapSize = 30;
hold on

p1 = plot(x_crb_plt,y3_line);
pbaspect([1 1 1])
p1.LineStyle = '--';
p1.Color = "b";
hold on

p3 = plot(x_crb,algo1_PI95);
p3(1,1).Color = "b";
p3(2,1).Color = "b";
hold on

p2 = plot(x_crb_plt,y7_line);
pbaspect([1 1 1])
p2.LineStyle = '--';
p2.Color = [0 0 0];
hold on

p4 = plot(x_crb,algo2_PI95);
p4(1,1).Color = [0 0 0];
p4(2,1).Color = [0 0 0];
hold on

xlim([0 55]);
ylim([-0.6 0.3]);

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 20;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

xlabel('CaCO$_{3}$ (wt.\%)','interpreter','latex','fontsize',30);
ylabel('$\chi$ (ppm)','interpreter','latex','fontsize',30)
grid on

xticks([0 10 20 30 40 50])
xticklabels({'0', '10', '20', '30', '40', '50'})

legend({'3 T, QSM','7 T, QSM'},'location','northeast','FontSize', 30,'interpreter','latex');

% Save data
saveas(gcf,strcat(output_dir,filename,'_QSM_scatter.svg'));
