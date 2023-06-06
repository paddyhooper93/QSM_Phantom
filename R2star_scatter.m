%% R2star_scatter.m
% Least squares linear regression between iron concentration and R2star

clc
clearvars
close all

filename = 'R2star';
output_dir = 'C:\your_directory\';

x_usp = 0.0125:0.00625:0.0375;
usp_uncert = [.0034 .0038 .0043 .0048 .0053];
x_usp_plt = [0,0.04375];
x_fer = 0.21:0.09:0.57;
fer_uncert = [.0207 .0295 .0383 .0471 .0559];
x_fer_plt = [0,0.65];
x_chl = 10:10:40;
x_chl_plt = [0,40];
x_crb = 10:10:50;
x_crb_plt = [0,50];


y3_usp = [30.5 40.4 49.5 53.7 62.9]; 
e3_usp = [ 3.4  1.3  1.4  1.6  1.9]; 
y7_usp = [30.2 40.6 48.3 50.7 61.8]; 
e7_usp = [ 1.7  0.4  2.1  2.4  2.1];

y3_fer = [13.3 16.3 17.4 19.3 20.2];
e3_fer = [ 4.4  3.4  1.7  1.3  1.1];
y7_fer = [18.5 21.2 28.1 32.6 33.9];
e7_fer = [ 0.5  0.8  0.6  0.7  0.9];

% Fifth data point is not included due to CaCl2 solubility limit
y3_chl = [9.4 9.1 9.4 10.2];  %17.6
e3_chl = [2.9 2.0 1.5  1.8];  %2.1
y7_chl = [11.3 11.0 9.7 12.0]; % 26.9
e7_chl = [ 0.8  1.8  1.0  1.6]; % 3.8

y3_crb = [42.5 102.9 111.4 148.8 179.4];
e3_crb = [7.5  13.9  14.5  13.9  14.5];
y7_crb = [138.2 225.1 245.3 316.1 343.8];
e7_crb = [ 30.8  18.4  26.2  31.4  49.1];

%% linear regression
y3_usp_mdl = fitlm(x_usp,y3_usp);
y7_usp_mdl = fitlm(x_usp,y7_usp);
y3_fer_mdl = fitlm(x_fer,y3_fer);
y7_fer_mdl = fitlm(x_fer,y7_fer);
y3_chl_mdl = fitlm(x_chl,y3_chl);
y7_chl_mdl = fitlm(x_chl,y7_chl);
y3_crb_mdl = fitlm(x_crb,y3_crb);
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
c_algo1 = fit(transpose(x_usp),transpose(y3_usp),f);
algo1_PI95 = predint(c_algo1,x_usp); 

c_algo2 = fit(transpose(x_usp),transpose(y7_usp),f);
algo2_PI95 = predint(c_algo2,x_usp);

c_algo3 = fit(transpose(x_fer),transpose(y3_fer),f);
algo3_PI95 = predint(c_algo3,x_fer); 

c_algo4 = fit(transpose(x_fer),transpose(y7_fer),f);
algo4_PI95 = predint(c_algo4,x_fer);

c_algo5 = fit(transpose(x_chl),transpose(y3_chl),f);
algo5_PI95 = predint(c_algo5,x_chl); 

c_algo6 = fit(transpose(x_chl),transpose(y7_chl),f);
algo6_PI95 = predint(c_algo6,x_chl);

c_algo7 = fit(transpose(x_crb),transpose(y3_crb),f);
algo7_PI95 = predint(c_algo7,x_crb); 

c_algo8 = fit(transpose(x_crb),transpose(y7_crb),f);
algo8_PI95 = predint(c_algo8,x_crb);


%% Scatter plot

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
hold on

%%
s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);

% 95 % Confidence bounds (Error Bars) 
err1 = errorbar(x_usp,y3_usp,e3_usp,e3_usp,usp_uncert,usp_uncert,'o');
err1.MarkerSize = 30;
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_usp,y7_usp,e7_usp,e7_usp,usp_uncert,usp_uncert,'o');
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

labels = {'$\quad$ 3 T, $R_2^*$ $\quad$','$\quad$ 7 T, $R_2^*$ $\quad$'};   
legend(labels,'Location','northwest','interpreter','latex','FontSize',20);
xlim([0 0.04375]);
ylim([0 75]);

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 14;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

xlabel('$\it{[cFe]}$ ($mg.mL^{-1})$','interpreter','latex','fontsize',22);
ylabel('$R_2^*$ ($s^{-1}$)','interpreter','latex','fontsize',22)

xticks([0,0.00625,0.0125,0.01875,0.0250,0.03125,0.0375,0.04375]);
xticklabels({'0','0.0063','0.0125', '0.0188', '0.0250', '0.0313', '0.0375', '0.0438'});

grid on

% Save data
saveas(gcf,strcat(output_dir,filename,'_scatter.svg'));

%%

s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);

grid on

err1 = errorbar(x_fer,y3_fer,e3_fer,e3_fer,fer_uncert,fer_uncert,'o');
err1.MarkerSize = 30;
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_fer,y7_fer,e7_fer,e7_fer,fer_uncert,fer_uncert,'o');
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
labels = {'$\quad$ 3 T, $R_2^*$ $\quad$','$\quad$ 7 T, $R_2^*$ $\quad$'};   
legend(labels,'Location','northwest','FontSize', 22,'interpreter','latex');
xlim([0 0.66]);
ylim([0 45]);

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 14;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

xlabel('$\it{[cFe]}$ ($mg.mL^{-1}$)','interpreter','latex','fontsize',22);
ylabel('$R_2^*$ ($s^{-1}$)','interpreter','latex','fontsize',22)
grid on

xticks([0,0.1,0.2,0.3,0.4,0.5,0.6]);
xticklabels({'0','0.1','0.2', '0.3', '0.4', '0.5', '0.6'});

saveas(gcf,strcat(output_dir,filename,'_scatter.svg'));

%%
grid on

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 14;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);

err1 = errorbar(x_chl,y3_chl,e3_chl,e3_chl,'o');
err1.MarkerSize = 30;
err1.Color = "b";
err1.CapSize = 30;
hold on

err2 = errorbar(x_chl,y7_chl,e7_chl,e7_chl,'o');
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
labels = {'$\quad$ 3 T, $R_2^*$ $\quad$','$\quad$ 7 T, $R_2^*$ $\quad$'};   
legend(labels,'Location','northwest','FontSize', 22,'interpreter','latex');
xlim([0 45]);
ylim([0 30]);

xticks([0 10 20 30 40])
xticklabels({'0', '10', '20', '30', '40'});

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 22;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

xlabel('CaCl$_{2}$ (wt.\%)','interpreter','latex','FontSize', 22);
ylabel('R$_2^*$ ($s^{-1}$)','interpreter','latex','FontSize', 22)
grid on

saveas(gcf,strcat(output_dir,filename,'_scatter.svg'));

%%
s = get(0, 'ScreenSize');
figure('Position', [0 0 s(3) s(4)]);

grid on

err1 = errorbar(x_crb,y3_crb,e3_crb,e3_crb,'o');
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

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 14;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

legend(labels,'Location','northwest','FontSize', 20,'interpreter','latex');
xlim([0 55]);
ylim([0 500]);

xticks([0 10 20 30 40 50])
xticklabels({'0', '10', '20', '30', '40', '50'});

ax = gca; % current axes
ax.FontSizeMode = 'manual';
ax.FontSize = 14;
set(gca,'GridColor',"k",'GridAlpha',0.5,'MinorGridAlpha',0.5)

xlabel('CaCO$_{3}$ (wt.\%)','interpreter','latex','FontSize', 22);
ylabel('$R_2^*$ ($s^{-1}$)','interpreter','latex','FontSize', 22)
grid on

% Save data
saveas(gcf,strcat(output_dir,filename,'_scatter.jpg'));