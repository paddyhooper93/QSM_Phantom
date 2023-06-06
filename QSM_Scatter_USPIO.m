%% QSM_Scatter_USPIO.m
% Linear regression between iron concentration and QSM

clc
clearvars

filename = 'USPIO';
output_dir = 'C:\Users\s4601543\Downloads\';

x_usp = 0.0125:0.00625:0.0375;
uncert = [.0034 .0038 .0043 .0048 .0053];
x_usp_plt = 0:0.00625:0.05;
x_usp_uncert = x_usp + uncert;

expm_3_usp =     [0.64 0.88 1.16 1.25 1.43];
expm_3_usp_err = [0.02 0.02 0.03 0.03 0.03];
expm_7_usp =     [0.39 0.49 0.60 0.66 0.73];
expm_7_usp_err = [0.01 0.02 0.01 0.02 0.02];

ratio_fieldstrength = expm_3_usp ./ expm_7_usp;

%% Obtain coefficient
y3_mdl_spu = fitlm(x_usp,expm_3_usp);
y7_mdl_spu = fitlm(x_usp,expm_7_usp);

spu_3_plt = y3_mdl_spu.Coefficients{2,1}.* x_usp_plt + y3_mdl_spu.Coefficients{1,1};
spu_7_plt = y7_mdl_spu.Coefficients{2,1}.* x_usp_plt + y7_mdl_spu.Coefficients{1,1};

%% Obtain prediction bounds
f = fittype('a*x+b');
c_algo1 = fit(transpose(x_usp),transpose(expm_3_usp),f);
algo1_PI95 = predint(c_algo1,x_usp); 

c_algo2 = fit(transpose(x_usp),transpose(expm_7_usp),f);
algo2_PI95 = predint(c_algo2,x_usp);

%% Experimental

s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);

pbaspect([1 1 1])

err1 = errorbar(x_usp,expm_3_usp,expm_3_usp_err,expm_3_usp_err,uncert,uncert,'o');
err1.MarkerSize = 30;
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_usp,expm_7_usp,expm_7_usp_err,expm_7_usp_err,uncert,uncert,'o');
err2.MarkerSize = 30;
err2.Color = "k";
err2.CapSize = 30;
hold on

p1 = plot(x_usp_plt,spu_3_plt);
p1.LineStyle = '--';
p1.Color = "b";
hold on

p3 = plot(x_usp,algo1_PI95);
p3(1,1).Color = "b";
p3(2,1).Color = "b";
hold on

p2 = plot(x_usp_plt,spu_7_plt);
pbaspect([1 1 1])
p2.LineStyle = '--';
p2.Color = [0 0 0];
hold on

p4 = plot(x_usp,algo2_PI95);
p4(1,1).Color = [0 0 0];
p4(2,1).Color = [0 0 0];
hold on

ax1 = gca; % current axes
ax1.FontSizeMode = 'manual';
ax1.FontSize = 18;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)


xlim([0 0.04375]);
ylim([0 1.7]);

xlabel('$\it{[cFe]}$ ($mg.mL^{-1})$', 'interpreter','latex','fontsize',22);
ylabel('$\chi$ (ppm)','interpreter','latex','fontsize',22)

grid on
  
xticks([0,0.00625,0.0125,0.01875,0.0250,0.03125,0.0375,0.04375,0.05]);
xticklabels({'0','0.0063','0.0125', '0.0188', '0.0250', '0.0313', '0.0375', '0.0438','0.05'});

legend({'3 T, QSM','7 T, QSM'},'location','northwest','FontSize', 22,'interpreter','latex');

% Save data
saveas(gcf,strcat(output_dir,filename,'_QSM_scatter.svg'));

