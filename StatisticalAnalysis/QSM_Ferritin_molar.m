%% QSM_Scatter_Ferritin.m
% Least sqauares linear regression between [cFe] and Chi

clc
clearvars

cd C:\Users\rosly\Documents\L1\L1_Data\
output_dir = 'C:\Users\rosly\Documents\L1\L1_Data\';
filename = 'Ferritin';

x_fer = (210 : 90 : 570) ./ 55.845;% (mmol/L)
uncert = [20.7 29.5 38.3 47.1 56.0]./ 55.845;  %mmol/L
x_fer_plt = [0,650] ./ 55.845;

data_3T = csvread('Ferritin_QSM_3T.csv',2,10);
data_7T = csvread('Ferritin_QSM_7T.csv',2,10);

y3_fer_mean = data_3T(:,1);
y3_fer_SD = data_3T(:,2);

y7_fer_mean = data_7T(:,1);
y7_fer_SD = data_7T(:,2);

FS_ratio = mean(y3_fer_mean ./ y7_fer_mean);

%% Obtain coefficient
y3_mdl = fitlm(x_fer,y3_fer_mean);
y7_mdl = fitlm(x_fer,y7_fer_mean);
y3_line =  y3_mdl.Coefficients{2,1}.*x_fer_plt + y3_mdl.Coefficients{1,1};
y7_line =  y7_mdl.Coefficients{2,1}.*x_fer_plt + y7_mdl.Coefficients{1,1};

% Test for influential and outlying points
% Cook's D threshold (influential points): 50th percentile of the F-dist.
% For n = 5, p = 1; v1 = 2, v2 = 3
t_cookd = finv(0.5,2,3);
ind_y3_infl = find(y3_mdl.Diagnostics.CooksDistance > t_cookd);
ind_y7_infl = find(y7_mdl.Diagnostics.CooksDistance > t_cookd);
plotDiagnostics(y3_mdl,'cookd')
legend('show')

% Stud. Res threshold (outlying points): 95th percentile of t-dist. 
% For n = 5, p = 1; v = 4
t_stud_res = tinv(0.95,4);
ind_y3_outlier = find(y3_mdl.Residuals.Studentized > t_stud_res);
ind_y7_outlier = find(y7_mdl.Residuals.Studentized > t_stud_res);
plotResiduals(y3_mdl,'fitted','ResidualType','studentized')
legend('show')
%% Obtain prediction bounds
f = fittype('a*x+b');
c_algo1 = fit(transpose(x_fer),y3_fer_mean,f);
algo1_PI95 = predint(c_algo1,x_fer); 

c_algo2 = fit(transpose(x_fer),y7_fer_mean,f);
algo2_PI95 = predint(c_algo2,x_fer);

%% 3 T Experimental

s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);
pbaspect([1 1 1])

err1 = errorbar(x_fer,y3_fer_mean,y3_fer_SD,y3_fer_SD,uncert,uncert,'o');
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_fer,y7_fer_mean,y7_fer_SD,y7_fer_SD,uncert,uncert,'o');
err2.Color = "r";
err2.CapSize = 30;
hold on

p_main = plot(x_fer,y3_fer_mean,x_fer,y7_fer_mean);
p_main(1).Marker = '.';
p_main(1).MarkerSize = 30;
p_main(2).Marker = '.';
p_main(2).MarkerSize = 30;
p_main(1).MarkerEdgeColor = "b";
p_main(2).MarkerEdgeColor = "r";
p_main(1).MarkerFaceColor = "b";
p_main(2).MarkerFaceColor = "r";
p_main(1).LineStyle = 'none';
p_main(2).LineStyle = 'none';
hold on


p_regression = plot(x_fer_plt,y3_line,x_fer_plt,y7_line);
p_regression(1).LineStyle = '--';
p_regression(1).Color = "b";
p_regression(2).LineStyle = '--';
p_regression(2).Color = "r";
pbaspect([1 1 1])
hold on

p_CI = plot(x_fer,algo1_PI95,x_fer,algo2_PI95);
p_CI(1,1).Color = "b";
p_CI(2,1).Color = "b";
p_CI(3,1).Color = "r";
p_CI(4,1).Color = "r";

xlim([0 12]);
ylim([0, 1.4]);

xticks = ([0 2 4 6 8 10]);
xticklabels = ({'0', '2', '4', '6', '8', '10'});
yticks([0,0.4,0.8,1.2]);
yticklabels({'0','0.4','0.8','1.2'});

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 32;
% set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

xlabel('[cFe] ($\mu$M)', 'interpreter','latex','fontsize',32);
ylabel('$\chi$ (ppm)','interpreter','latex','fontsize',32)

% grid on
  
legend({'3 T','7 T'},'location','northwest','FontSize', 32,'interpreter','latex');

% Save data
saveas(gcf,strcat(output_dir,filename,'_QSM_scatter.png'));