office_screens = 1;

marr = 0.05; 
marl = 0.08; 
mart = 0.1; 
marb = 0.2; 
sv = 0.1; 
sh = 0.12; 
fs = 11; 

%%

load('..\Results\FinalResults.mat')

myfig(2,1); box on; 

[p,a,b] = linreg(LI_M,Dmax,1);
R = Dmax./(b+LI_M*a);
cla

if office_screens == 1
    set(gcf, 'Units', 'centimeters', 'Position', [70, 10, 16, 6], 'PaperUnits', 'centimeters', 'PaperSize', [29.7, 21])
else
    set(gcf, 'Units', 'centimeters', 'Position', [6, 10, 16, 6], 'PaperUnits', 'centimeters', 'PaperSize', [29.7, 21])
    
end

ax1 = subaxis(1,2,1,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on; grid on;

axis([0 2 0 2.5])
set(gca,'fontname','times new roman')
xlabel('Normalized weekly deepest keel draft [-]')
ylabel('Probability density [-]')
set(gca,'units','centimeters')
set(gca,'Position',[1.2785    1.2012    5.9928    4.2042])

histogram(R,0.05:0.08:2,'Normalization','pdf')


pd = fitdist(R','lognormal');
pd = fitdist(R','generalized extreme value');
x = 0:0.001:2;
y = pdf(pd,x);
plot(x,y,'k')

legend('Hist.','PDF')
text(ax1.XLim(1),ax1.YLim(2)+(ax1.YLim(2)-ax1.YLim(1))*0.1,'a','FontWeight','bold')

ax2 = subaxis(1,2,2,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on; grid on;

set(gca,'fontname','times new roman')
xlabel('Normalized weekly deepest keel draft [-]')
ylabel('Probability density [-]')

QQP = qqplot(R,pd);


set(gca,'units','centimeters')
title('')
xlabel('Quantiles of log-normal distribution [-]')
ylabel('Quantiles of input sample [-]')

QQP(1).MarkerFaceColor = 'k';
QQP(1).Marker = '+';
QQP(1).MarkerEdgeColor = 'k';
QQP(1).MarkerSize = 4;

QQP(3).LineStyle = '-';
QQP(3).LineWidth = 1;


text(ax2.XLim(1),ax2.YLim(2)+(ax2.YLim(2)-ax2.YLim(1))*0.1,'b','FontWeight','bold')







