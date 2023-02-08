myfig(1,1)
clf
hold on
WM = worldmap([68 82], [-170 -120]);

mC = [103 152 154]/255;

borders('Canada','facecolor',mC)
borders('Alaska','facecolor',mC)

LOCs = geoshow([75 78 77 74],[-150 -150 -140 -140],'DisplayType','point');

LOCs.Marker = 'o';
LOCs.MarkerFaceColor = 'k';
LOCs.MarkerEdgeColor = 'none';
LOCs.MarkerSize = 14;

x = LOCs.XData;
y = LOCs.YData;

xS = 000;

text(x(1)+xS, y(1), 'A', 'HorizontalAlignment','center', 'VerticalAlignment','middle','Color','w','FontWeight','bold','FontSize',10)

text(x(2)+xS, y(2), 'B', 'HorizontalAlignment','center', 'VerticalAlignment','middle','Color','w','FontWeight','bold','FontSize',10)

text(x(3)+xS, y(3), 'C', 'HorizontalAlignment','center', 'VerticalAlignment','middle','Color','w','FontWeight','bold','FontSize',10)

text(x(4)+xS, y(4), 'D', 'HorizontalAlignment','center', 'VerticalAlignment','middle','Color','w','FontWeight','bold','FontSize',10)

gridm('MLineLocation', 5,...
    'MLabelLocation', 10,...
    'PLineLocation', 1,...
    'PLabelLocation', 2);

set(findall(gcf,'-property','FontName'),'FontName','times new roman')
