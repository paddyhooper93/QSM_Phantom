%% QSM_Scatter_Chloride.m
% Linear regression between iron concentration and QSM

clc
clearvars

filename = 'Chloride';
output_dir = 'C:\Users\s4601543\Downloads\';

x_chl = 10:10:40;
x_chl_plt = [0,40];

y3_chl_test =       [-0.230 -0.638 -0.985 -1.152]; 
y3_chl_retest =     [-0.232 -0.642 -0.979 -1.147]; 
y3_chl_8m =         [-0.248 -0.660 -0.994 -1.179]; 

y7_chl_test =       [-0.262 -0.659 -0.930 -1.017];
y7_chl_retest =     [-0.264 -0.652 -0.916 -1.013];
y7_chl_8m =         [-0.254 -0.645 -0.971 -1.155];

y3_chl_mean =       mean([y3_chl_test; y3_chl_retest; y3_chl_8m]);
expm_3_chl_err =    [0.06 0.07 0.07 0.17];
y7_chl_mean =       mean([y7_chl_test; y7_chl_retest; y7_chl_8m]);
expm_7_chl_err =    [0.02 0.04 0.03 0.15 ]; 

%% Obtain coefficient
y3_mdl_spu = fitlm(x_chl,y3_chl_mean);
y7_mdl_spu = fitlm(x_chl,y7_chl_mean);
y3_line_spu =  y3_mdl_spu.Coefficients{2,1}.*x_chl_plt + y3_mdl_spu.Coefficients{1,1};
y7_line_spu =  y7_mdl_spu.Coefficients{2,1}.*x_chl_plt + y7_mdl_spu.Coefficients{1,1};

%% Obtain prediction bounds
f = fittype('a*x+b');
c_algo1 = fit(transpose(x_chl),transpose(y3_chl_mean),f);
algo1_PI95 = predint(c_algo1,x_chl); 

c_algo2 = fit(transpose(x_chl),transpose(y7_chl_mean),f);
algo2_PI95 = predint(c_algo2,x_chl);

%% 3 T Exp'm

s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);
pbaspect([1 1 1])

err1 = errorbar(x_chl,y3_chl_mean,expm_3_chl_err,expm_3_chl_err,'o');
err1.MarkerSize = 30;
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_chl,y7_chl_mean,expm_7_chl_err,expm_7_chl_err,'o');
err2.MarkerSize = 30;
err2.Color = "k";
err2.CapSize = 30;
hold on

p1 = plot(x_chl_plt,y3_line_spu);
p1.LineStyle = '--';
p1.Color = "b";
hold on

p3 = plot(x_chl,algo1_PI95);
p3(1,1).Color = "b";
p3(2,1).Color = "b";
hold on

p2 = plot(x_chl_plt,y7_line_spu);
pbaspect([1 1 1])
p2.LineStyle = '--';
p2.Color = [0 0 0];
hold on

p4 = plot(x_chl,algo2_PI95);
p4(1,1).Color = [0 0 0];
p4(2,1).Color = [0 0 0];
hold on

xlim([0 45]);
ylim([-1.6 0]);

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 40;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

xlabel('CaCl$_{2}$ (wt.\%)','interpreter','latex','fontsize',22);
ylabel('$\chi$ (ppm)','interpreter','latex','fontsize',22)
grid on

xticks([0 10 20 30 40])
xticklabels({'0', '10', '20', '30', '40'})
yticks([-1.6, -1.2, -.8, -.4, 0])
yticklabels({'-1.6','-1.2', '-0.8', '-0.4', '0'})

legend({'3 T, QSM','7 T, QSM'},'location','northeast','FontSize', 22,'interpreter','latex');

% Save data
saveas(gcf,strcat(output_dir,filename,'_QSM_scatter.svg'));
