load('..\Results\FinalResults.mat')

TwoScreens = 1;

marr = 0.05; 
marl = 0.08; 
mart = 0.1; 
marb = 0.2; 
sv = 0.1; 
sh = 0.12; 
fs = 11; 

myfig(1,1);
if TwoScreens == 1
set(gcf, 'Units', 'centimeters', 'Position', [70, 10, 16, 6], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
end
ax1 = subaxis(1,2,1,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on; grid on;
scatter(LI_AM,Dmax,'filled','MarkerFaceAlpha',0.2,'SizeData',20)
xlabel('Level ice draft (AM) [m]')
ylabel('Weekly deepeest keel draft [m]')
set(gca,'fontname','times new roman')
text(ax1.XLim(1),ax1.YLim(2)+2.5,'a','FontWeight','bold')
text(2.05,7,sprintf('R = %0.3f',corr2(LI_AM,Dmax)),'FontWeight','bold','fontname','times new roman')

ax2 = subaxis(1,2,2,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on; grid on;
scatter(LI_DM,Dmax,'filled','MarkerFaceAlpha',0.2,'SizeData',20)
xlabel('Level ice draft (DM) [m]')
ylabel('Weekly deepeest keel draft [m]')
set(gca,'fontname','times new roman')
text(ax2.XLim(1),ax1.YLim(2)+2.5,'b','FontWeight','bold')
text(2.05,7,sprintf('R = %0.3f',corr2(LI_DM,Dmax)),'FontWeight','bold','fontname','times new roman')

set(ax1,'units','centimeters')
ax1.Position

%%

myfig(2,1); box on; axis([0 3 5 30])
if TwoScreens == 1
    set(gcf, 'Units', 'centimeters', 'Position', [70, 20, 8, 6], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
else
    set(gcf, 'Units', 'centimeters', 'Position', [10, 10, 8, 6], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
end

set(gca,'fontname','times new roman')
xlabel('Level ice draft (DM + manual correction) [m]')
ylabel('Weekly deepeest keel draft [m]')

scatter(LI_M,Dmax,'filled','MarkerFaceAlpha',0.2,'SizeData',20)
x = 0:0.001:3;
y = 20*sqrt(x);
[p,a,b] = linreg(LI_M,Dmax,1);
p.LineStyle = '-';
p.Color = 'k';

set(gca,'units','centimeters')
set(gca,'Position',[1.2785    1.2012    5.9928    4.2042])

text(2.05,7,sprintf('R = %0.3f',corr2(LI_M,Dmax)),'FontWeight','bold','fontname','times new roman')
