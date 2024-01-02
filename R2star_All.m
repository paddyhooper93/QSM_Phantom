% R2star_scatter.m
% Least squares linear regression between iron concentration and R2star

clc
clearvars

filename = 'R2star';
output_dir = 'C:\Users\s4601543\Downloads\';

x_usp = 0.0125:0.00625:0.0375;
usp_uncert = [.0034 .0038 .0043 .0048 .0053];
x_usp_plt = [0,0.04375];
x_fer = 0.21:0.09:0.57;
fer_uncert = [.0207 .0295 .0383 .0471 .0559];
x_fer_plt = [0,0.65];
x_chl = 10:10:40;
x_chl_plt = [0,40];
x_crb = 10:10:40;
x_crb_plt = [0,40];
labels = {'3 T, R$_2^*$','7 T, R$_2^*$'};  

%% 3 T
y3_usp_test =           [30.2 38.6 50.3 52.6 61.3]; 
y3_usp_retest =         [31.0 39.0 50.5 52.8 61.4]; 
y3_usp_8m =             [30.9 40.3 49.7 53.9 62.7]; 
y3_usp_24m_test     =   [29.5 39.0 48.4 51.9 58.8];
y3_usp_24m_retest   =   [29.5 39.3 48.5 52.2 59.0];
y3_usp_mean =     mean([y3_usp_test; y3_usp_retest; y3_usp_8m; y3_usp_24m_test; y3_usp_24m_retest]);

y3_fer_test =           [16.1 15.9 18.6 20.0 20.2];
y3_fer_retest =         [15.9 16.2 19.0 20.1 20.6];
y3_fer_8m =             [16.4 16.9 17.8 19.8 20.4];
y3_fer_24m_test     =   [16.1 16.2 18.0 19.8 20.9];
y3_fer_24m_retest   =   [16.3 16.3 18.3 20.0 21.1];
y3_fer_mean = mean([y3_fer_test; y3_fer_retest; y3_fer_8m; y3_fer_24m_test; y3_fer_24m_retest]);

y3_chl_test =           [14.4 13.1 13.5 13.9];  
y3_chl_retest =         [14.5 12.8 13.3 14.1];  
y3_chl_8m =             [9.9 9.7 10.2 10.4];  
y3_chl_mean = mean([y3_chl_test; y3_chl_retest; y3_chl_8m]);

y3_crb_test =           [39.3 100.1 110.9 151.1]; 
y3_crb_retest =         [38.4 98.7 109.3 149.5];
y3_crb_15m =            [42.5 102.9 111.4 148.8];
y3_crb_mean = mean([y3_crb_test; y3_crb_retest; y3_crb_15m]);



%% 7 T

y7_usp_test =           [29.4 39.5 47.9 51.0 62.1]; 
y7_usp_retest =         [29.5 39.4 48.0 51.0 62.2]; 
y7_usp_8m =             [30.2 40.6 48.3 50.7 62.1]; 
y7_usp_24m_test     =   [29.3 38.9 41.9 50.6 60.4];
y7_usp_24m_retest   =   [29.5 38.9 41.9 50.6 60.4];
y7_usp_mean =     mean([y7_usp_test; y7_usp_retest; y7_usp_8m; y7_usp_24m_test; y7_usp_24m_retest]);


y7_fer_test =           [18.2 19.1 28.1 31.6 34.0];
y7_fer_retest =         [18.1 19.3 28.1 31.8 34.0];
y7_fer_8m =             [18.5 21.2 28.1 32.7 35.1];
y7_fer_24m_test     =   [20.2 20.9 27.9 33.3 35.7];
y7_fer_24m_retest   =   [20.3 21.0 27.8 32.9 35.6];
y7_fer_mean = mean([y7_fer_test; y7_fer_retest; y7_fer_8m; y7_fer_24m_test; y7_fer_24m_retest]);

y7_chl_test =           [15.8 14.4 15.2 15.8];
y7_chl_retest =         [15.6 14.2 15.2 15.8]; 
y7_chl_8m =             [11.3 11.0 9.7 12.0]; 
y7_chl_mean = mean([y7_chl_test; y7_chl_retest; y7_chl_8m]);

y7_crb_test =           [96.6 229.1 255.1 344.5];
y7_crb_retest =         [95.5 230.7 264.1 349.5];
y7_crb_15m =            [144.7 225.1 252.8 337.1];
y7_crb = mean([y7_crb_test; y7_crb_retest; y7_crb_15m]);

%% Error-bars, y-axis
e3_usp = [3.4 1.3 1.4 1.6 1.9]; 
e7_usp = [5.4 2.8 2.9 3.1 4.3];

e3_fer = [4.4 3.4 1.7 1.3 1.1];
e7_fer = [0.8 0.9 1.1 2.2 2.1];

e3_chl = [2.9 2.0 1.5 1.8]; 
e7_chl = [0.9 1.3 1.0 1.4]; 

e3_crb = [7.5  13.9 14.5 13.9];
e7_crb = [35.6 22.3 23.9 54.4]; 


%% linear regression
y3_usp_mdl = fitlm(x_usp,y3_usp_mean);
y7_usp_mdl = fitlm(x_usp,y7_usp_mean);
y3_fer_mdl = fitlm(x_fer,y3_fer_mean);
y7_fer_mdl = fitlm(x_fer,y7_fer_mean);
y3_chl_mdl = fitlm(x_chl,y3_chl_mean);
y7_chl_mdl = fitlm(x_chl,y7_chl_mean);
y3_crb_mdl = fitlm(x_crb,y3_crb_mean);
y7_crb_mdl = fitlm(x_crb,y7_crb);


%% Line-of-best-fit
y3_usp_line = y3_usp_mdl.Coefficients{2,1}.*x_usp_plt + y3_usp_mdl.Coefficients{1,1};
y7_usp_line = y7_usp_mdl.Coefficients{2,1}.*x_usp_plt + y7_usp_mdl.Coefficients{1,1};
y3_fer_line = y3_fer_mdl.Coefficients{2,1}.*x_fer_plt + y3_fer_mdl.Coefficients{1,1};
y7_fer_line = y7_fer_mdl.Coefficients{2,1}.*x_fer_plt + y7_fer_mdl.Coefficients{1,1};
y3_chl_line = y3_chl_mdl.Coefficients{2,1}.*x_chl_plt + y3_chl_mdl.Coefficients{1,1};
y7_chl_line = y7_chl_mdl.Coefficients{2,1}.*x_chl_plt + y7_chl_mdl.Coefficients{1,1};
y3_crb_line = y3_crb_mdl.Coefficients{2,1}.*x_crb_plt + y3_crb_mdl.Coefficients{1,1};
y7_crb_line = y7_crb_mdl.Coefficients{2,1}.*x_crb_plt + y7_crb_mdl.Coefficients{1,1};

%% Obtain prediction bounds

f = fittype('a*x+b');
c_algo1 = fit(transpose(x_usp),transpose(y3_usp_mean),f);
algo1_PI95 = predint(c_algo1,x_usp); 

c_algo2 = fit(transpose(x_usp),transpose(y7_usp_mean),f);
algo2_PI95 = predint(c_algo2,x_usp);

c_algo3 = fit(transpose(x_fer),transpose(y3_fer_mean),f);
algo3_PI95 = predint(c_algo3,x_fer); 

c_algo4 = fit(transpose(x_fer),transpose(y7_fer_mean),f);
algo4_PI95 = predint(c_algo4,x_fer);

c_algo5 = fit(transpose(x_chl),transpose(y3_chl_mean),f);
algo5_PI95 = predint(c_algo5,x_chl); 

c_algo6 = fit(transpose(x_chl),transpose(y7_chl_mean),f);
algo6_PI95 = predint(c_algo6,x_chl);

c_algo7 = fit(transpose(x_crb),transpose(y3_crb_mean),f);
algo7_PI95 = predint(c_algo7,x_crb); 

c_algo8 = fit(transpose(x_crb),transpose(y7_crb),f);
algo8_PI95 = predint(c_algo8,x_crb);

%% USPIO

s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);

% 95 % Confidence bounds (Error Bars) 
err1 = errorbar(x_usp,y3_usp_mean,e3_usp,e3_usp,usp_uncert,usp_uncert,'o');
err1.MarkerSize = 30;
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_usp,y7_usp_mean,e7_usp,e7_usp,usp_uncert,usp_uncert,'o');
err2.MarkerSize = 30;
err2.Color = "k";
err2.CapSize = 30;
hold on

p1 = plot( x_usp_plt,y3_usp_line);
p1.LineStyle = '--';
p1.Color = "b";
hold on

p3 = plot( x_usp,algo1_PI95);
p3(1,1).Color = "b";
p3(2,1).Color = "b";
hold on

p2 = plot( x_usp_plt,y7_usp_line);
pbaspect([1 1 1])
p2.LineStyle = '--';
p2.Color = "k";
hold on

p4 = plot( x_usp,algo2_PI95);
p4(1,1).Color = "k";
p4(2,1).Color = "k";
hold on
 
legend(labels,'Location','northwest','interpreter','latex','FontSize',32);
xlim([0 0.04375]);
ylim([0 75]);

xlabel('[cFe] ($\mu$g.mL$^{-1}$)','interpreter','latex','fontsize',32);
ylabel('R$_2^*$ ($s^{-1}$)','interpreter','latex','FontSize', 32)

xticks([0,0.00625,0.0125,0.01875,0.0250,0.03125,0.0375]);
xticklabels({'0','6.3','12.5', '18.8', '25.0', '31.3', '37.5'});
yticks([0, 20, 40, 60]);
yticklabels({'0', '20', '40', '60'});

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 32;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)
grid on
% Save data
saveas(gcf,strcat(output_dir,filename,'_scatter.jpg'));

%% FERRITIN

s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);

grid on

err1 = errorbar(x_fer,y3_fer_mean,e3_fer,e3_fer,fer_uncert,fer_uncert,'o');
err1.MarkerSize = 30;
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_fer,y7_fer_mean,e7_fer,e7_fer,fer_uncert,fer_uncert,'o');
err2.MarkerSize = 30;
err2.Color = "k";
err2.CapSize = 30;
hold on

p1 = plot( x_fer_plt,y3_fer_line);
pbaspect([1 1 1])
p1.LineStyle = '--';
p1.Color = "b";
hold on

p3 = plot( x_fer,algo3_PI95);
p3(1,1).Color = "b";
p3(2,1).Color = "b";
hold on

p2 = plot( x_fer_plt,y7_fer_line);
pbaspect([1 1 1])
p2.LineStyle = '--';
p2.Color = "k";
hold on

p4 = plot( x_fer,algo4_PI95);
p4(1,1).Color = "k";
p4(2,1).Color = "k";
hold on
legend(labels,'Location','northwest','FontSize', 32,'interpreter','latex');
xlim([0 0.66]);
ylim([0 45]);

xlabel('[cFe] (mg.mL$^{-1}$)','interpreter','latex','fontsize',32);
ylabel('R$_2^*$ ($s^{-1}$)','interpreter','latex','FontSize', 32);
grid on

xticks([0,0.2,0.4,0.6]);
xticklabels({'0','0.2','0.4','0.6'});
yticks([0 10 20 30 40])
yticklabels({'0','10','20','30','40'});

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 32;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

saveas(gcf,strcat(output_dir,filename,'_scatter.jpg'));

%% CALCIUM CHLORIDE
grid on

s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);

err1 = errorbar(x_chl,y3_chl_mean,e3_chl,e3_chl,'o');
err1.MarkerSize = 30;
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_chl,y7_chl_mean,e7_chl,e7_chl,'o');
err2.MarkerSize = 30;
err2.Color = "k";
err2.CapSize = 30;
hold on

p1 = plot( x_chl_plt,y3_chl_line);
pbaspect([1 1 1])
p1.LineStyle = '--';
p1.Color = "b";
hold on

p3 = plot( x_chl,algo5_PI95);
p3(1,1).Color = "b";
p3(2,1).Color = "b";
hold on

p2 = plot( x_chl_plt,y7_chl_line);
pbaspect([1 1 1])
p2.LineStyle = '--';
p2.Color = "k";

p4 = plot( x_chl,algo6_PI95);
p4(1,1).Color = "k";
p4(2,1).Color = "k";
hold on

legend(labels,'Location','southwest','FontSize', 32,'interpreter','latex');
xlim([0 45]);
ylim([0 20]);

xticks([0 10 20 30 40])
xticklabels({'0', '10', '20', '30', '40'});

xlabel('CaCl$_{2}$ (wt.\%)','interpreter','latex','FontSize', 32);
ylabel('R$_2^*$ ($s^{-1}$)','interpreter','latex','FontSize', 32);
grid on

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 32;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

saveas(gcf,strcat(output_dir,filename,'_scatter.jpg'));

%% CALCIUM CARBONATE

s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);

grid on

err1 = errorbar(x_crb,y3_crb_mean,e3_crb,e3_crb,'o');
err1.MarkerSize = 30;
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_crb,y7_crb,e7_crb,e7_crb,'o');
err2.MarkerSize = 30;
err2.Color = "k";
err2.CapSize = 30;
hold on

p1 = plot( x_crb_plt,y3_crb_line);
pbaspect([1 1 1])
p1.LineStyle = '--';
p1.Color = "b";
hold on

p2 = plot( x_crb_plt,y7_crb_line);
pbaspect([1 1 1])
p2.LineStyle = '--';
p2.Color = "k";

p3 = plot( x_crb,algo7_PI95);
p3(1,1).Color = "b";
p3(2,1).Color = "b";
hold on

p4 = plot( x_crb,algo8_PI95);
p4(1,1).Color = "k";
p4(2,1).Color = "k";
hold on

legend(labels,'Location','northwest','FontSize', 32,'interpreter','latex');
xlim([0 45]);
ylim([-50 450]);

xticks([0 10 20 30 40])
xticklabels({'0', '10', '20', '30', '40'});
yticks([0 100 200 300 400])
yticklabels({'0', '100', '200', '300', '400'});

xlabel('CaCO$_{3}$ (wt.\%)','interpreter','latex','FontSize', 32);
ylabel('R$_2^*$ ($s^{-1}$)','interpreter','latex','FontSize', 32);
grid on

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 32;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

% Save data
saveas(gcf,strcat(output_dir,filename,'_scatter.jpg'));