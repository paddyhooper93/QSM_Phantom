%% QSM_Scatter_Ferritin.m
% Least sqauares linear regression between [cFe] and QSM

clc
clearvars

filename = 'Ferritin';
output_dir = 'C:\Users\s4601543\Downloads\';

x_fer = 0.21:0.09:0.57;
x_fer_plt = 0:0.1625:0.65;
uncert = [.0207 .0295 .0383 .0471 .0559];  

y3_fer_test =           [0.506 0.584 0.886 1.040 1.109];
y3_fer_retest =         [0.505 0.581 0.878 1.038 1.116];
y3_fer_8m =             [0.504 0.600 0.884 1.055 1.121];
y3_fer_24m_test     =   [0.499 0.570 0.848 1.005 1.102];
y3_fer_24m_retest   =   [0.496 0.568 0.848 1.007 1.107];

y7_fer_test =           [0.460 0.518 0.789 0.947 1.018];
y7_fer_retest =         [0.459 0.517 0.792 0.946 1.016];
y7_fer_8m =             [0.469 0.569 0.817 0.993 1.038];
y7_fer_24m_test     =   [0.438 0.519 0.779 0.909 1.009];
y7_fer_24m_retest   =   [0.432 0.514 0.769 0.902 1.013];

y3_fer_mean = mean([y3_fer_test; y3_fer_retest; y3_fer_8m; y3_fer_24m_test; y3_fer_24m_retest]);
expm_3_fer_err =  [0.02 0.01 0.02 0.02 0.05]; 
y7_fer_mean = mean([y7_fer_test; y7_fer_retest; y7_fer_8m; y7_fer_24m_test; y7_fer_24m_retest]);
expm_7_fer_err =  [0.02 0.02 0.03 0.05 0.04]; 

%% Obtain coefficient
y3_mdl_spu = fitlm(x_fer,y3_fer_mean);
y7_mdl_spu = fitlm(x_fer,y7_fer_mean);
y3_line_spu =  y3_mdl_spu.Coefficients{2,1}.*x_fer_plt + y3_mdl_spu.Coefficients{1,1};
y7_line_spu =  y7_mdl_spu.Coefficients{2,1}.*x_fer_plt + y7_mdl_spu.Coefficients{1,1};

%% Obtain prediction bounds
f = fittype('a*x+b');
c_algo1 = fit(transpose(x_fer),transpose(y3_fer_mean),f);
algo1_PI95 = predint(c_algo1,x_fer); 

c_algo2 = fit(transpose(x_fer),transpose(y7_fer_mean),f);
algo2_PI95 = predint(c_algo2,x_fer);

%% 3 T Experimental

s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);
pbaspect([1 1 1])

err1 = errorbar(x_fer,y3_fer_mean,expm_3_fer_err,expm_3_fer_err,uncert,uncert,'o');
err1.MarkerSize = 30;
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_fer,y7_fer_mean,expm_7_fer_err,expm_7_fer_err,uncert,uncert,'o');
err2.MarkerSize = 30;
err2.Color = "k";
err2.CapSize = 30;
hold on

p1 = plot(x_fer_plt,y3_line_spu);
p1.LineStyle = '--';
p1.Color = [.5 .5 .5];
hold on

p3 = plot(x_fer,algo1_PI95);
p3(1,1).Color = [.5 .5 .5];
p3(2,1).Color = [.5 .5 .5];
hold on

p2 = plot(x_fer_plt,y7_line_spu);
pbaspect([1 1 1])
p2.LineStyle = '--';
p2.Color = [0 0 0];
hold on

p4 = plot(x_fer,algo2_PI95);
p4(1,1).Color = [0 0 0];
p4(2,1).Color = [0 0 0];
hold on

xlim([0 0.65]);
ylim([0, 1.4]);

xticks([0,0.2,0.4,0.6]);
xticklabels({'0','0.2','0.4','0.6'});
yticks([0,0.4,0.8,1.2]);
yticklabels({'0','0.4','0.8','1.2'});

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 32;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

xlabel('[cFe] (mg.mL$^{-1}$)', 'interpreter','latex','fontsize',32);
ylabel('$\chi$ (ppm)','interpreter','latex','fontsize',32)

grid on
  
legend({'3 T, QSM','7 T, QSM'},'location','northwest','FontSize', 32,'interpreter','latex');

% Save data
saveas(gcf,strcat(output_dir,filename,'_QSM_scatter.svg'));
