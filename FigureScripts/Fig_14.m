clear all
close all
clc

load('..\Results\FinalResults.mat')


myfig(2,1); box on; 
set(gcf, 'Units', 'centimeters', 'Position', [1, 20, 8, 8], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
set(gca,'fontname','times new roman')
xlabel('Level ice draft [m]')
ylabel('Number of ridges [ridges/week]')

scatter(LI_M,N,'filled','MarkerFaceAlpha',0.2,'SizeData',20)
 
aa = 84.69;
bb = 1.318;
x = 0:0.001:3;
y = aa*x.^bb;
plot(x,y,'k')

text(0.25,1100,sprintf('R = %0.3f',corr2(LI_M,N)),'FontWeight','bold','fontname','times new roman')
