% !!!!!!!!!!!!!!!!!!! HAVE TO RUN S011_SimulationAllRidges_Multiple.m FIRST   !!!!!!!!!!!!!!!!!
keep YI DAll

office_screens = 1;

P1 = prctile(YI,1,2);
P5 = prctile(YI,5,2);
P95 = prctile(YI,95,2);
P99 = prctile(YI,99,2);
P50 = prctile(YI,50,2);

x = [(200000:-1:1)/200000]';
xi = [(200000:-1:1)/200000]';

%%
myfig(1,1); box on;
if office_screens == 1
   set(gcf, 'Units', 'centimeters', 'Position', [70, 20, 9, 6], 'PaperUnits', 'centimeters', 'PaperSize', [29.7, 21])
else
    set(gcf, 'Units', 'centimeters', 'Position', [4, 10, 9, 6], 'PaperUnits', 'centimeters', 'PaperSize', [29.7, 21])
end
set(gca,'yscale','log')
set(gca,'units','centimeters')
xlim([5 40])
xlabel('Ridge keel depth [m]')
ylabel('Excedence probability [-]')
set(gca,'fontname','times new roman')
yticks([1E-5 1E-4 1E-3 1E-2 1E-1 1E-0])

idx = [1:10000:190000 191000:1000:199000 199010:10:199900 199901:200000];

xx = x(idx);
P1x = P1(idx);
P5x = P5(idx);
P95x = P95(idx);
P99x = P99(idx);
P50x = P50(idx);

F = fill([P5x; flipud(P95x)],[xx; flipud(xx)],'b');
F.FaceAlpha = 0.6;
F.EdgeColor = 'none';

F98a = fill([P1x; flipud(P5x)],[xx; flipud(xx)],'b');
F98a.FaceAlpha = 0.3;
F98a.EdgeColor = 'none';

F98b = fill([P95x; flipud(P99x)],[xx; flipud(xx)],'b');
F98b.FaceAlpha = 0.3;
F98b.EdgeColor = 'none';

P50plot = plot(P50x,xx,'k-','LineWidth',2);

N = numel(DAll);
xepp = sort(DAll);
yepp = (N:-1:1)/N;
index = [1:1000:100000 101000:100:180000 180010:10:199000 199001:199128];
epa = scatter(xepp(index),yepp(index),'r.');


L = legend([epa,P50plot,F,F98a],'Data - all ridges','Simulation - best estimate','90% confidence interval','98% confidence interval');
L.Position = [0.4811    0.7077    0.4824    0.2533];
ylim([min(xi) 1])





