clear all
close all
clc

load('..\Results\FinalResults.mat')

myfig(3,1); box on; 
axis([0 3 5 9])
yticks(5:1:9)
set(gcf, 'Units', 'centimeters', 'Position', [1, 20, 8, 6], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
set(gca,'fontname','times new roman')
xlabel('Level ice draft [m]')
ylabel('Weekly mean keel draft [m]')

scatter(LI_M,M,'filled','MarkerFaceAlpha',0.2,'SizeData',20)
 
[p,a,b] = linreg(LI_M,M,1);
p.LineStyle = '-';
p.Color = 'k';

set(gca,'units','centimeters')
set(gca,'Position',[1.2785    1.2012    5.9928    4.2042])

text(2.05,5.35,sprintf('R = %0.3f',corr2(LI_M,M)),'FontWeight','bold','fontname','times new roman')
