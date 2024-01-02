
%% QSM_Scatter_USPIO.m
% Linear regression between iron concentration and QSM

clc
clearvars

filename = 'USPIO';
output_dir = 'C:\Users\s4601543\Downloads\';
x_usp = 1.25.*[0.01:0.005:0.03]; % multiply by 25\% due to given mftg range: 10-15 mgFe/mL
uncert = [.0034 .0038 .0043 .0048 .0053];
x_usp_plt = 0:0.00625:0.05;


y3_usp_test =           [0.663 0.893 1.179 1.273 1.460];
y3_usp_retest =         [0.657 0.894 1.180 1.272 1.457];
y3_usp_8m =             [0.650 0.904 1.180 1.274 1.454];
y3_usp_24m_test     =   [0.621 0.855 1.135 1.225 1.369];
y3_usp_24m_retest   =   [0.619 0.854 1.135 1.224 1.361];

y7_usp_test =           [0.392 0.499 0.596 0.644 0.724];
y7_usp_retest =         [0.395 0.497 0.593 0.640 0.722];
y7_usp_8m =             [0.369 0.477 0.596 0.634 0.709];
y7_usp_24m_test     =   [0.343 0.448 0.560 0.600 0.681];
y7_usp_24m_retest   =   [0.340 0.448 0.551 0.596 0.688];

y3_usp_mean =     mean([y3_usp_test; y3_usp_retest; y3_usp_8m; y3_usp_24m_test; y3_usp_24m_retest]);
expm_3_usp_err = [0.02 0.02 0.03 0.03 0.03];
y7_usp_mean =     mean([y7_usp_test; y7_usp_retest; y7_usp_8m; y7_usp_24m_test; y7_usp_24m_retest]);
expm_7_usp_err = [0.01 0.02 0.01 0.02 0.02]; 

%% Obtain coefficient
y3_mdl_spu = fitlm(x_usp,y3_usp_mean);
y7_mdl_spu = fitlm(x_usp,y7_usp_mean);

spu_3_plt = y3_mdl_spu.Coefficients{2,1}.* x_usp_plt + y3_mdl_spu.Coefficients{1,1};
spu_7_plt = y7_mdl_spu.Coefficients{2,1}.* x_usp_plt + y7_mdl_spu.Coefficients{1,1};

modelfun = @(b,x)(b(1)+b(2).*x+b(3).*x.^2);
beta0 = [0,1,0];
y3_mdl_nlm = fitnlm(x_usp,y3_usp_mean,modelfun,beta0);
y7_mdl_nlm = fitnlm(x_usp,y7_usp_mean,modelfun,beta0);

%% Obtain prediction bounds
f = fittype('a*x+b');
c_algo1 = fit(transpose(x_usp),transpose(y3_usp_mean),f);
algo1_PI95 = predint(c_algo1,x_usp); 

c_algo2 = fit(transpose(x_usp),transpose(y7_usp_mean),f);
algo2_PI95 = predint(c_algo2,x_usp);

%% Experimental

s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);

pbaspect([1 1 1])

err1 = errorbar(x_usp,y3_usp_mean,expm_3_usp_err,expm_3_usp_err,uncert,uncert,'o');
err1.MarkerSize = 30;
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_usp,y7_usp_mean,expm_7_usp_err,expm_7_usp_err,uncert,uncert,'o');
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

xlim([0 0.04375]);
ylim([0 1.7]);

xlabel('[cFe] ($\mu$g.mL$^{-1}$)','interpreter','latex','fontsize',22);
ylabel('$\chi$ (ppm)','interpreter','latex','fontsize',22)

grid on
  
xticks([0,0.00625,0.0125,0.01875,0.0250,0.03125,0.0375]);
xticklabels({'0','6.3','12.5', '18.8', '25.0', '31.3', '37.5'});
yticks([0 .4 .8 1.2 1.6]);
yticklabels({'0', '0.4', '0.8', '1.2', '1.6'});

legend({'3 T, QSM','7 T, QSM'},'location','northwest','FontSize', 22,'interpreter','latex');

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 22;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)
% Save data
saveas(gcf,strcat(output_dir,filename,'_QSM_scatter.svg'));

