%% QSM_Scatter_Ferritin.m
% Least sqauares linear regression between [cFe] and QSM

clc
clearvars

filename = 'Ferritin';
output_dir = 'C:\Users\s4601543\Downloads\';

x_fer = 0.21:0.09:0.57;
x_fer_plt = 0:0.1625:0.65;
uncert = [.0207 .0295 .0383 .0471 .0559];
x_fer_uncert = x_fer + uncert;

expm_3_fer =     [0.50 0.58 0.87 1.04 1.12];
expm_3_fer_err =  [0.02 0.01 0.02 0.02 0.05];
expm_7_fer =     [0.47 0.59 0.84 1.02 1.03];
expm_7_fer_err =  [0.02 0.02 0.03 0.05 0.04];

ratio_fieldstrength = expm_3_fer ./ expm_7_fer;

%% Obtain coefficient
y3_mdl_spu = fitlm(x_fer,expm_3_fer);
y7_mdl_spu = fitlm(x_fer,expm_7_fer);
y3_line_spu =  y3_mdl_spu.Coefficients{2,1}.*x_fer_plt + y3_mdl_spu.Coefficients{1,1};
y7_line_spu =  y7_mdl_spu.Coefficients{2,1}.*x_fer_plt + y7_mdl_spu.Coefficients{1,1};

%% Obtain prediction bounds
f = fittype('a*x+b');
c_algo1 = fit(transpose(x_fer),transpose(expm_3_fer),f);
algo1_PI95 = predint(c_algo1,x_fer); 

c_algo2 = fit(transpose(x_fer),transpose(expm_7_fer),f);
algo2_PI95 = predint(c_algo2,x_fer);

%% 3 T Experimental

s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);
pbaspect([1 1 1])

err1 = errorbar(x_fer,expm_3_fer,expm_3_fer_err,expm_3_fer_err,uncert,uncert,'o');
err1.MarkerSize = 30;
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_fer,expm_7_fer,expm_7_fer_err,expm_7_fer_err,uncert,uncert,'o');
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
ylim([0, 1.4])

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 14;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

xlabel('$\it{[cFe]}$ ($mg.mL^{-1})$', 'interpreter','latex','fontsize',22);
ylabel('$\chi$ (ppm)','interpreter','latex','fontsize',22)

grid on
  
legend({'3 T, QSM','7 T, QSM'},'location','northwest','FontSize', 22,'interpreter','latex');

% Save data
saveas(gcf,strcat(output_dir,filename,'_QSM_scatter.svg'));
