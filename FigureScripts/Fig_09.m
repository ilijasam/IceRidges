clear all
close all
clc

office_screens = 1;

load('results1.mat','M','N','T','LI_DM','LI_AM')
load('MonthsLabelsS.mat')
%%

marr = 0.05; 
marl = 0.05; 
mart = 0.07; 
marb = 0.15; 
sv = 0.1; 
sh = 0.08; 
fs = 11; 

limic = 400;

myfig(1,1);

if office_screens == 1
    set(gcf, 'Units', 'centimeters', 'Position', [70, 10, 16, 5.5], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
else
    set(gcf, 'Units', 'centimeters', 'Position', [6, 20, 16, 7], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
end
ax1 = subaxis(1,2,1,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on; grid on;
set(gca, 'YGrid', 'on', 'XGrid', 'off')
set(gca,'Units','centimeters')
set(gca,'fontname','times new roman')
m = month(T);
m(m>8) = m(m>8)-12;
boxplot(N,m,'symbol','','Whisker',0)
ylim([0 limic])
xticklabels(MonthsLabelsS)
xtickangle(90)
ylabel('Number of ridges [ridges/week]')
ax1.FontSize = 9
ax1.Position


ax2 = subaxis(1,2,2,'sv',sv,'sh',sh,'MarginRight',marr,'MarginLeft',marl,'MarginTop',mart,'MarginBottom',marb); hold on; box on;
get(gca,'position')
set(gca,'Units','centimeters')
set(gca, 'YGrid', 'on', 'XGrid', 'off')
ylim([0 limic])
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
get(gca,'XLim')


set(gcf,'Position', [70, 10, 16, 8])
axE = axes('Position',[.54 0.7 .41 .2])
set(gca,'fontname','times new roman')
axE.FontSize = 9


axis([-121 244 limic 1200])
xticks([sort(xt)])
yticks([400 800 1200])

hold on
box on
scatter(ts(N>limic),N(N>limic),'filled','MarkerFaceAlpha',0.2,'SizeData',20)

datetick('x','mmm','keepticks','keeplimits')

set(gca,'xticklabel',{[]})


