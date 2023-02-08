clear all
close all
clc

office_screens = 1;

addpath('..\Supporting Files\')

load('MonthsLabelsS.mat')
load('..\Results\FinalResults.mat')

%%

marr = 0.05; 
marl = 0.05; 
mart = 0.07; 
marb = 0.15; 
sv = 0.1; 
sh = 0.08; 
fs = 11; 

myfig(1,1);

if office_screens == 1
    set(gcf, 'Units', 'centimeters', 'Position', [70, 30, 16, 5.5], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
else
    set(gcf, 'Units', 'centimeters', 'Position', [6, 30, 16, 5.5], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
end
ax1 = subaxis(1,2,1,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on; grid on;
set(gca, 'YGrid', 'on', 'XGrid', 'off')
set(gca,'fontname','times new roman')
m = month(T);
m(m>8) = m(m>8)-12;
boxplot(N,m,'symbol','','Whisker',0)
ylim([0 1200])
xticklabels(MonthsLabelsS)
xtickangle(90)
ylabel('Number of ridges [ridges/week]')
ax1.FontSize = 9
ax1.Position


ax2 = subaxis(1,2,2,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on; box on;
set(gca, 'YGrid', 'on', 'XGrid', 'off')
ylim([0 1200])
set(gca,'fontname','times new roman')
ts = T-datenum(year(T),ones(1,numel(T)),ones(1,numel(T)));
moveyear = find(ts>datenum('01-Sep-0000 00:00:00'));
for n = moveyear
ts(n) = addtodate( ts(n) , -1, 'year') ;
end
scatter(ts,N,'filled','MarkerFaceAlpha',0.2,'SizeData',20)
xt = datenum(zeros(12,1),[1:12]',ones(12,1));
moveyear = find(xt>=datenum('01-Sep-0000 00:00:00'));
for n = moveyear'
xt(n) = addtodate( xt(n) , -1, 'year') ;
end
xticks(sort(xt))
ax2.XLim = [addtodate( datenum('01-Sep-0000 00:00:00') , -1, 'year') datenum('31-Aug-0000 00:00:00') ];
datetick('x','mmm','keepticks','keeplimits')
xtickangle(90)
ax2.Position([2 4]) = ax1.Position([2 4]);






%%

marr = 0.05; 
marl = 0.05; 
mart = 0.07; 
marb = 0.15; 
sv = 0.1; 
sh = 0.08; 
fs = 11; 

myfig(2,1);
if office_screens == 1
    set(gcf, 'Units', 'centimeters', 'Position', [90, 10, 16, 5.5], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
else
    set(gcf, 'Units', 'centimeters', 'Position', [6, 10, 16, 5.5], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
end
ax1 = subaxis(1,2,1,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on;
set(gca, 'YGrid', 'on', 'XGrid', 'off')
set(gca,'fontname','times new roman')
m = month(T);
m(m>8) = m(m>8)-12;
boxplot(M,m,'symbol','','Whisker',0)
ylim([5 9])
xticklabels(MonthsLabelsS)
xtickangle(90)
ylabel('Mean ridge keel draft [m]')
ax1.FontSize = 9
ax1.Position


ax2 = subaxis(1,2,2,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on; box on;
set(gca, 'YGrid', 'on', 'XGrid', 'off')
ylim([5 9])
set(gca,'fontname','times new roman')
ts = T-datenum(year(T),ones(1,numel(T)),ones(1,numel(T)));
moveyear = find(ts>datenum('01-Sep-0000 00:00:00'));
for n = moveyear
ts(n) = addtodate( ts(n) , -1, 'year') ;
end
scatter(ts,M,'filled','MarkerFaceAlpha',0.2,'SizeData',20)
xt = datenum(zeros(12,1),[1:12]',ones(12,1));
moveyear = find(xt>=datenum('01-Sep-0000 00:00:00'));
for n = moveyear'
xt(n) = addtodate( xt(n) , -1, 'year') ;
end
xticks(sort(xt))
ax2.XLim = [addtodate( datenum('01-Sep-0000 00:00:00') , -1, 'year') datenum('31-Aug-0000 00:00:00') ];
datetick('x','mmm','keepticks','keeplimits')
xtickangle(90)
ax2.Position([2 4]) = ax1.Position([2 4]);

%%

MonthsLabelsS = ['Sep';'Oct';'Nov';'Dec';'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug'];

marr = 0.05; 
marl = 0.05; 
mart = 0.07; 
marb = 0.10; 
sv = 0.08; 
sh = 0.08; 
fs = 9; 

myfig(3,1);
set(gcf, 'Units', 'centimeters', 'Position', [70, 10, 16, 16.5], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])

ax1 = subaxis(3,2,1,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on; grid on;
set(gca, 'YGrid', 'on', 'XGrid', 'off')
yticks(0:0.5:3)
ax1.FontSize = fs;
set(gca,'fontname','times new roman')
m = month(T);
m(m>8) = m(m>8)-12;
boxplot(LI_AM,m,'symbol','','Whisker',0)
ylim([0 3])
xticklabels(MonthsLabelsS)
xtickangle(90)
ylabel('Level ice draft [m]')
text(ax1.XLim(1),ax1.YLim(2)+0.3,'a) Level ice thickness according to the absolute mode','FontWeight','bold')


ax2 = subaxis(3,2,2,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on; box on; grid on;
set(gca, 'YGrid', 'on', 'XGrid', 'off')
yticks(0:0.5:3)
ax2.FontSize = fs;
ylim([0 3])
set(gca,'fontname','times new roman')
ts = T-datenum(year(T),ones(1,numel(T)),ones(1,numel(T)));
moveyear = find(ts>datenum('01-Sep-0000 00:00:00'));
for n = moveyear
ts(n) = addtodate( ts(n) , -1, 'year') ;
end
scatter(ts,LI_AM,'filled','MarkerFaceAlpha',0.2,'SizeData',20)
xt = datenum(zeros(12,1),[1:12]',ones(12,1));
moveyear = find(xt>=datenum('01-Sep-0000 00:00:00'));
for n = moveyear'
xt(n) = addtodate( xt(n) , -1, 'year') ;
end
xticks(sort(xt))
ax2.XLim = [addtodate( datenum('01-Sep-0000 00:00:00') , -1, 'year') datenum('31-Aug-0000 00:00:00') ];
datetick('x','mmm','keepticks','keeplimits')
xtickangle(90)
ax2.Position([2 4]) = ax1.Position([2 4]);

%---------------------------------------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------------------------------------

ax3 = subaxis(3,2,3,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on; grid on;
set(gca, 'YGrid', 'on', 'XGrid', 'off')
yticks(0:0.5:3)
ax3.FontSize = fs;
set(gca,'fontname','times new roman')
m = month(T);
m(m>8) = m(m>8)-12;
boxplot(LI_DM,m,'symbol','','Whisker',0)
ylim([0 3])
xticklabels(MonthsLabelsS)
xtickangle(90)
ylabel('Level ice draft [m]')
text(ax3.XLim(1),ax3.YLim(2)+0.3,'b) Level ice thickness according to the deepest mode','FontWeight','bold')


ax4 = subaxis(3,2,4,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on; box on; grid on;
set(gca, 'YGrid', 'on', 'XGrid', 'off')
yticks(0:0.5:3)
ax4.FontSize = fs;
ylim([0 3])
set(gca,'fontname','times new roman')
ts = T-datenum(year(T),ones(1,numel(T)),ones(1,numel(T)));
moveyear = find(ts>datenum('01-Sep-0000 00:00:00'));
for n = moveyear
ts(n) = addtodate( ts(n) , -1, 'year') ;
end
scatter(ts,LI_DM,'filled','MarkerFaceAlpha',0.2,'SizeData',20)
xt = datenum(zeros(12,1),[1:12]',ones(12,1));
moveyear = find(xt>=datenum('01-Sep-0000 00:00:00'));
for n = moveyear'
xt(n) = addtodate( xt(n) , -1, 'year') ;
end
xticks(sort(xt))
ax4.XLim = [addtodate( datenum('01-Sep-0000 00:00:00') , -1, 'year') datenum('31-Aug-0000 00:00:00') ];
datetick('x','mmm','keepticks','keeplimits')
xtickangle(90)
ax4.Position([2 4]) = ax3.Position([2 4]);

%---------------------------------------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------------------------------------
%%

T(N<15) = [];
T(to_delete) = [];
LI_M(to_delete) = [];

ax5 = subaxis(3,2,5,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on; grid on; cla
set(gca, 'YGrid', 'on', 'XGrid', 'off')
yticks(0:0.5:3)
ax5.FontSize = fs;
set(gca,'fontname','times new roman')
m = month(T);
m(m>8) = m(m>8)-12;
boxplot(LI_M,m,'symbol','','Whisker',0)
ylim([0 3])
xticklabels(MonthsLabelsS)
xtickangle(90)
ylabel('Level ice draft [m]')
text(ax3.XLim(1),ax3.YLim(2)+0.3,'c) Level ice according to the deepest mode + manual correction','FontWeight','bold')


ax6 = subaxis(3,2,6,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on; box on; grid on; cla
set(gca, 'YGrid', 'on', 'XGrid', 'off')
yticks(0:0.5:3)
ax6.FontSize = fs;
ylim([0 3])
set(gca,'fontname','times new roman')
ts = T-datenum(year(T),ones(1,numel(T)),ones(1,numel(T)));
moveyear = find(ts>datenum('01-Sep-0000 00:00:00'));
for n = moveyear
ts(n) = addtodate( ts(n) , -1, 'year') ;
end
scatter(ts,LI_M,'filled','MarkerFaceAlpha',0.2,'SizeData',20)
xt = datenum(zeros(12,1),[1:12]',ones(12,1));
moveyear = find(xt>=datenum('01-Sep-0000 00:00:00'));
for n = moveyear'
xt(n) = addtodate( xt(n) , -1, 'year') ;
end
xticks(sort(xt))
ax6.XLim = [addtodate( datenum('01-Sep-0000 00:00:00') , -1, 'year') datenum('31-Aug-0000 00:00:00') ];
datetick('x','mmm','keepticks','keeplimits')
xtickangle(90)
ax6.Position([2 4]) = ax5.Position([2 4]);









