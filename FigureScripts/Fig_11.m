
load('..\Results\FinalResults.mat')

myfig(1,1); box on; grid off; hold on;
set(gcf, 'Units', 'centimeters', 'Position', [70, 20, 8, 6], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
set(gca,'fontname','times new roman')
xlabel('Level ice draft [m]')
ylabel('Probability for N < 15 [%]')
XX = edges(2:end)-mean(diff(edges))/2;
YY = (1-H2./H1)*100;

x = 0:0.01:3;
y = 100.^(1-0.6*x);
plot(x,y,'-k','LineWidth',1)
scatter([0 XX],[100 (1-H2./H1)*100],'filled','MarkerFaceAlpha',0.6,'SizeData',36)

txt = '$ \leftarrow y = 100^{1 - 0.6x} $';
text(0.2,60,txt,'Interpreter','latex')
