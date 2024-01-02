%% QSM_Scatter_Carbonate.m
% Linear regression between iron concentration and QSM

clc
clearvars

filename = 'Carbonate';
output_dir = 'C:\Users\s4601543\Downloads\';

x_crb = 10:10:40;
x_crb_plt = [0,x_crb(end)];

y3_crb_test =       [0.118 -0.077 -0.116 -0.292];
y3_crb_retest =     [0.118 -0.076 -0.115 -0.290];
y3_crb_15m =        [0.085 -0.058 -0.110 -0.279];

y7_crb_test =       [0.080 -0.081 -0.110 -0.141];
y7_crb_retest =     [0.082 -0.078 -0.109 -0.142];
y7_crb_15m =        [0.091 -0.072 -0.110 -0.266];

y3_crb_mean =       mean([y7_crb_test; y7_crb_retest; y7_crb_15m]);
expm_3_crb_err =    [0.06 0.05 0.05 0.09 ]; 
y7_crb_mean =       mean([y7_crb_test; y7_crb_retest; y7_crb_15m]);
expm_7_crb_err =    [0.05 0.05 0.07 0.10 ];  

%% Obtain coefficient
y3_mdl = fitlm(x_crb,y3_crb_mean);
y7_mdl = fitlm(x_crb,y7_crb_mean);

%% Obtain line-of-best-fit

y3_line =  y3_mdl.Coefficients{2,1}.*x_crb_plt + y3_mdl.Coefficients{1,1};
y7_line =  y7_mdl.Coefficients{2,1}.*x_crb_plt + y7_mdl.Coefficients{1,1};

%% Obtain prediction bounds
f = fittype('a*x+b');
c_algo1 = fit(transpose(x_crb),transpose(y3_crb_mean),f);
algo1_PI95 = predint(c_algo1,x_crb); 

c_algo2 = fit(transpose(x_crb),transpose(y7_crb_mean),f);
algo2_PI95 = predint(c_algo2,x_crb);

%% Exp'm
s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);
pbaspect([1 1 1])

err1 = errorbar(x_crb,y3_crb_mean,expm_3_crb_err,expm_3_crb_err,'o');
err1.MarkerSize = 30;
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_crb,y7_crb_mean,expm_7_crb_err,expm_7_crb_err,'o');
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

xlim([0 45]);
ylim([-0.5 0.3]);



xlabel('CaCO$_{3}$ (wt.\%)','interpreter','latex','fontsize',40);
ylabel('$\chi$ (ppm)','interpreter','latex','fontsize',40)
grid on

xticks([0 10 20 30 40])
xticklabels({'0', '10', '20', '30', '40'})
yticks([-0.4 -0.2 0 0.2])
yticklabels({'-0.4', '-0.2', '0', '0.2'})

legend({'3 T, QSM','7 T, QSM'},'location','northeast','FontSize', 40,'interpreter','latex');
ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 40;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)
% Save data
saveas(gcf,strcat(output_dir,filename,'_QSM_scatter.svg'));
