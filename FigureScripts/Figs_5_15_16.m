load('..\Supporting Files\data_2000_2019.mat')

keep ui T F

Trs = T;

load('..\Results\FinalResults.mat')

TwoScreens = 1;




%%

for n = 1:numel(LI_M)
    switch Location(n)
        case 1
            S(n) = nanmean(F{1}(Trs>WS(n)&Trs<WE(n)) .*  ui{1}(Trs>WS(n)&Trs<WE(n)))*7*24*3600/1000;
            V(n) = nanmean(ui{1}(Trs>WS(n)&Trs<WE(n)));
        case 2
            S(n) = nanmean(F{2}(Trs>WS(n)&Trs<WE(n)) .*  ui{2}(Trs>WS(n)&Trs<WE(n)))*7*24*3600/1000;
            V(n) = nanmean(ui{2}(Trs>WS(n)&Trs<WE(n)));
        case 3
            S(n) = nanmean(F{3}(Trs>WS(n)&Trs<WE(n)) .*  ui{3}(Trs>WS(n)&Trs<WE(n)))*7*24*3600/1000;
            V(n) = nanmean(ui{3}(Trs>WS(n)&Trs<WE(n)));
        case 4
            S(n) = nanmean(F{4}(Trs>WS(n)&Trs<WE(n)) .*  ui{4}(Trs>WS(n)&Trs<WE(n)))*7*24*3600/1000;
            V(n) = nanmean(ui{4}(Trs>WS(n)&Trs<WE(n)));
    end
end


%%
myfig(1,1)
scatter(LI_M,S)

corr2(S(~isnan(S)),N(~isnan(S)))

%%
myfig(1,1); box on; 

if TwoScreens == 1
set(gcf, 'Units', 'centimeters', 'Position', [70, 20, 9, 6], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
end
set(gca,'fontname','times new roman')
xlabel('Level ice draft [m]')
ylabel('Transect length [km]')

scatter(LI_M,S,'filled','MarkerFaceAlpha',0.2,'SizeData',20)

CORIC = corr2(LI_M(~isnan(S)),S(~isnan(S)));

txt = text(2.1435,12.4277,sprintf('R = %0.3f',CORIC))

myfig(11,1); box on; 
if TwoScreens == 1
set(gcf, 'Units', 'centimeters', 'Position', [70, 10, 9, 6], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
end
set(gca,'fontname','times new roman')
xlabel('Level ice draft [m]')
ylabel('Weekly mean ice drift speed [m/s]')

scatter(LI_M,V,'.')

CORIC = corr2(LI_M(~isnan(S)),V(~isnan(S)));

txt = text(2.1435,0.05,sprintf('R = %0.3f',CORIC))

%%
MonthsLabelsS = ['Sep';'Oct';'Nov';'Dec';'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug'];
SS = [ui{1}.*F{1} ui{2}.*F{2} ui{3}.*F{3} ui{4}.*F{4}].*24*7*3600/1000;
myfig(2,1)
if TwoScreens == 1
set(gcf, 'Units', 'centimeters', 'Position', [80   30   13.3140    5.6162], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
end
set(gca,'fontname','times new roman')

tall = repmat(Trs,1,4);

m = month(tall);
m(m>8) = m(m>8)-12;
boxplot(SS,m,'symbol','','Whisker',0)
xticklabels(MonthsLabelsS)
ylim([0 100])
xlabel('Months')
ylabel('Weekly ice transect length [km]')

%%
myfig(3,1); box on; 

if TwoScreens == 1
set(gcf, 'Units', 'centimeters', 'Position', [80   17    8.2   8.2], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
end
set(gca,'fontname','times new roman')
xlabel('Spatial ridge frequency [ridges/km]')
ylabel('Weekly number of ridges [ridges/week]')
xlim([0 10])

scatter(N./S,N,'filled','MarkerFaceAlpha',0.2,'SizeData',20)

CORIC = corr2(N(~isnan(S))./S(~isnan(S)),N(~isnan(S)));

plot([0 10],[0 10]*61.8,'k--')


%%

myfig(4,1); box on; 

if TwoScreens == 1
set(gcf, 'Units', 'centimeters', 'Position', [80, 5, 8, 8], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
else
set(gcf, 'Units', 'centimeters', 'Position', [1, 5, 8, 8], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
end
set(gca,'fontname','times new roman')
xlabel('Level ice draft [m]')
ylabel('Spatial ridge frequency [ridges/km]')
ylim([0 20])

scatter(LI_M,N./S,'filled','MarkerFaceAlpha',0.2,'SizeData',20)
NS = N./S;
xx = 0:0.01:3;
yy = 1.505*xx.^1.222;
plot(xx,yy,'k')

LILI = LI_M(NS<15);
NS = NS(NS<15);

NSnan = NS(not(isnan(NS)));
LInan = LI_M(not(isnan(NS)));

text(0.1,19,sprintf('R = %0.3f',corr2(LInan,NSnan)),'FontWeight','bold','fontname','times new roman')


%%
MonthsLabelsS = ['Sep';'Oct';'Nov';'Dec';'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug'];
SS = [ui{1}.*F{1} ui{2}.*F{2} ui{3}.*F{3} ui{4}.*F{4}].*24*7*3600/1000;
myfig(5,1)
set(gcf, 'Units', 'centimeters', 'Position', [70   30   18   5.6162], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])

tall = repmat(Trs,1,4);


m = month(T);
m(m>8) = m(m>8)-12;

subplot(1,3,1:2); hold on; grid on; box on
set(gca,'fontname','times new roman')
boxplot(S,m,'symbol','','Whisker',0)
xticklabels(MonthsLabelsS)
ylim([0 100])
xlabel('Months')
ylabel('Weekly ice transect length [km]')

subplot(1,3,3); hold on; grid on; box on
set(gca,'fontname','times new roman')
xlabel('Weekly ice transect length [km]')
ylabel('Probability density [m^{-1}]')
histogram(S,0:10:200,'Normalization','pdf')
xlim([0 200])
xticks([0 50 100 150 200])
text(90,0.02,sprintf('\\mu = %0.01f \n \\sigma = %0.01f',nanmean(S),nanstd(S)),'FontName','times new roman','FontSize',10,'BackgroundColor','w')












