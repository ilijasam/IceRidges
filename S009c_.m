% Test for Equal Variances Using the Brown-Forsythe Test (for R_N ratio )
close all
clc


% loading the results
load('results1.mat')
load('ManualCorrection_3.mat')

% subplots settings
marr = 0.05; 
marl = 0.08; 
mart = 0.1; 
marb = 0.2; 
sv = 0.1; 
sh = 0.12; 
fs = 11; 

% removing points with less than 15 ridges
LI_DM(N<15) = [];
Dmax(N<15) = [];
M(N<15) = [];
N(N<15) = [];
LI_DM = LI_DM(not(to_delete));
LI_M = LI_M(not(to_delete));
Dmax = Dmax(not(to_delete));
M = M(not(to_delete));
N = N(not(to_delete));

myfig(1,1);

% subplot with level ice VS weekly deepest keel draft
ax1 = subaxis(1,2,1,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on; grid on;
set(gcf, 'Units', 'centimeters', 'Position', [70, 10, 16, 6.5], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
xlabel('Weekly mean keel draft [m]')
ylabel('Number of ridges [ridges/week]')
set(gca,'fontname','times new roman')

scatter(M,N,'filled','MarkerFaceAlpha',0.2,'SizeData',20)

a1 = 37.21;
b1 = 2.16;
x = 5:0.001:9;
y = a1*(x-5).^b1;
plot(x,y,'k')


% subplot with level ice VS normalized weekly deepest keel draft
ax2 = subaxis(1,2,2,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on; grid on;
R = N./(a1*(M-5).^b1);
xlabel('Level ice draft [m]')
ylabel('Normalized weekly mean keel draft [-]')
set(gca,'fontname','times new roman')

scatter(M,R,'filled','MarkerFaceAlpha',0.2,'SizeData',20)


R = N./(a1*(M-5).^b1);               % calculating the R ratio (Normalized weekly deepest keel draft)
[M_sorted i] = sort(M);       % sorting the variables according to the level ice draft

% dividing the ratio R in 8 subsamples following the level ice draft. This way the keels in first
% subsambpe are with the shallowest level ice draft, second is with deeper, etc.
R = reshape(R(i),[],8);             

vartestn(R,'TestType','BrownForsythe')