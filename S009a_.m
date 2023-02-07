% Test for Equal Variances Using the Brown-Forsythe Test

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
LI_DM = LI_DM(not(to_delete));
LI_M = LI_M(not(to_delete));
Dmax = Dmax(not(to_delete));
M = M(not(to_delete));

myfig(1,1);

% subplot with level ice VS weekly deepest keel draft
ax1 = subaxis(1,2,1,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on; grid on;
set(gcf, 'Units', 'centimeters', 'Position', [70, 10, 16, 6.5], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
xlabel('Level ice draft [m]')
ylabel('Weekly deepeest keel draft [m]')
set(gca,'fontname','times new roman')

scatter(LI_M,Dmax,'filled','MarkerFaceAlpha',0.2,'SizeData',20)
[p,a,b] = linreg(LI_M,Dmax,1);


% subplot with level ice VS normalized weekly deepest keel draft
ax2 = subaxis(1,2,2,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on; grid on;
R = Dmax./(b+LI_M*a);
xlabel('Level ice draft [m]')
ylabel('Normalized weekly deepest keel draft [-]')
set(gca,'fontname','times new roman')

scatter(LI_M,R,'filled','MarkerFaceAlpha',0.2,'SizeData',20)


R = Dmax./(b+LI_M*a);               % calculating the R ratio (Normalized weekly deepest keel draft)
[LI_M_sorted i] = sort(LI_M);       % sorting the variables according to the level ice draft

% dividing the ratio R in 8 subsamples following the level ice draft. This way the keels in first
% subsambpe are with the shallowest level ice draft, second is with deeper, etc.
R = reshape(R(i),[],8);             

vartestn(R,'TestType','BrownForsythe')