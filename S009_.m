% --- WORK IN PROGRESS ---

% clean simulation of weekly deepest ridge keels

clear all
close all
clc

office_screens = 0;

produce_scatter_plot = 1;
produce_confidence_plot = 0;
produce_return_period_plot = 0;



%% loading and trimming the data 
load('results1.mat')
load('ManualCorrection_3.mat')

Ntreashold = 15;
LI_DM(N<Ntreashold) = [];
Dmax(N<Ntreashold) = [];
M(N<Ntreashold) = [];
N(N<Ntreashold) = [];

LI_DM = LI_DM(not(to_delete));
LI_M = LI_M(not(to_delete));
Dmax = Dmax(not(to_delete));
M = M(not(to_delete));
N = N(not(to_delete));


%%
% figure for tracking steps of calculations on subplots
myfig(1,1); clf;
if office_screens == 1
    set(gcf,'Position',[2561         249        1080        1803])    
    warning('off','all')
    pause(0.00001);
    frame_h = get(handle(gcf),'JavaFrame');
    set(frame_h,'Maximized',1);
    warning('on','all')
end

subplot(6,3,1); hold on; box on; grid on; axis([0 3 5 30])
xlabel('Level ice draft [m]')
ylabel('Weekly deepeest keel draft [m]')
scatter(LI_M, Dmax,'filled','MarkerFaceAlpha',0.2,'SizeData',20)
[p,a,b] = linreg(LI_M,Dmax,1);
p.Color = 'k';
xA = 0:0.001:3;
yA = 20*sqrt(xA);
plot(xA,yA,'k--')

subplot(6,3,2); hold on; box on; grid on;
xlabel('Level ice draft [m]')
ylabel('Normalized weekly deepest keel draft [-]')
R = Dmax./(b+LI_M*a);
scatter(LI_M, R,'filled','MarkerFaceAlpha',0.2,'SizeData',20)

subplot(6,3,3); hold on; box on; grid on; axis([0 2 0 2.5])
xlabel('Normalized weekly deepest keel draft [-]')
ylabel('Probability density [-]')
histogram(R,0.05:0.08:2,'Normalization','pdf')
pd = fitdist(R','lognormal');
% pd = fitdist(R','generalized extreme value');
x = 0:0.001:2;
y = pdf(pd,x);
plot(x,y,'k')
legend('Hist.','PDF')

subplot(6,3,4); hold on; box on; grid on; 
title('SIMULATED')
axis([0 3 5 30])
xlabel('Level ice draft [m]')
ylabel('Weekly deepeest keel draft [m]')
Dmax_simulated = (b+a*LI_M).*random(pd,size(LI_M));
scatter(LI_M, Dmax_simulated,'filled','MarkerFaceAlpha',0.2,'SizeData',20)
plot(xA,yA,'k--')
xLR = 0:0.01:3;
yLR = b+a*xLR;
plot(xLR,yLR,'k')

subplot(6,3,5); hold on; box on; grid on; axis([0 40 0.00001 1])
xlabel('Level ice draft [m]')
ylabel('Exceedence probability [-]')
yticks([0.00001 0.0001 0.001 0.01 0.1 1])
N_repeat = 100;
Dmax_simulated = repmat((b+a*LI_M),1,N_repeat).*random(pd,size(LI_M).*[1 N_repeat]);
epp(Dmax_simulated)
epp(Dmax)
legend('simulated','measured')

subplot(6,3,6); cla; hold on; box on; grid on; 
axis([5 35 5 35])
qqplot(Dmax,Dmax_simulated)
xlabel('Measured draft [[m]')
ylabel('Simulated draft [m]')




%%

if produce_scatter_plot==1
    myfig(2,1); box on;
    set(gcf, 'Units', 'centimeters', 'Position', [1, 10, 8, 6], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
    set(gca,'units','centimeters')
    set(gca,'Position',[1.2785    1.2012    5.9928    4.2042])
    axis([0 3 5 30])
    xlabel('Level ice draft [m]')
    ylabel('Weekly deepeest keel draft [m]')
    set(gca,'fontname','times new roman')
    Dmax_simulated = (b+a*LI_M).*random(pd,size(LI_M));
    scatter(LI_M, Dmax_simulated,'filled','MarkerFaceAlpha',0.2,'SizeData',20)
%     plot(xA,yA,'k--')
    xLR = 0:0.01:3;
    yLR = b+a*xLR;
    plot(xLR,yLR,'k')
    
    text(2.05,7,sprintf('R = %0.3f',corr2(LI_M, Dmax_simulated)),'FontWeight','bold','fontname','times new roman')

    
end

%%

if produce_return_period_plot==1
    myfig(3,1); box on;
    set(gcf, 'Units', 'centimeters', 'Position', [70, 10, 9, 6], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
    set(gca,'units','centimeters')
    set(gca,'Position',[1.8870    1.2012    5.9928    4.2042])
    axis([10 50 1E-5 1])
    xlabel('Weekly maximum ridge keel depth [m]')
    ylabel('Return period [years]')
    set(gca,'fontname','times new roman')
    N_repeat = 100000;
    Dmax_simulated = repmat((b+a*LI_M),1,N_repeat).*random(pd,size(LI_M).*[1 N_repeat]);
    set(gca,'YScale','log')
    N = numel(Dmax_simulated);
    P = (1-(N:-1:1)/N).^42;
    epp1 = scatter(sort(Dmax_simulated),1-P,'.');
    yticks([1E-5 1E-4 1E-3 1E-2 1E-1 1E-0])
    yticklabels({'100,000' '10,000' '1,000' '100' '10' '1'})
    
    XD = epp1.XData;
    YD = epp1.YData;
    delete(epp1)
    
    ii = [20000000:50000000:100000000 100000000:5000000:150000000 150000000:1000000:156000000 156000000:10000:156790000 156790000:156800000];
    
    EPP1 = plot(XD(ii),YD(ii),'k','LineWidth',2);
    
    
    
end

%%


if produce_confidence_plot==1
    
    x = [(numel(LI_M):-1:1)/numel(LI_M)]';
    nS = 100000;
    YI = zeros(numel(LI_M),nS);
    for n = 1:nS
        disp(n)
        Dmax_simulated = [(b+a*LI_M).*random(pd,size(LI_M))]';
        Dmax_simulated_sorted = sort(Dmax_simulated);
        YI(:,n) = Dmax_simulated_sorted;
    end
    
    myfig(4,1); hold on; grid on; box on
    set(gcf, 'Units', 'centimeters', 'Position', [70, 10, 9, 6], 'PaperUnits', 'Inches', 'PaperSize', [29.7, 21])
    set(gca,'yscale','log')    
    xlabel('Weekly maximum ridge keel draft [m]')
    ylabel('Exceedence probability [-]')
    set(gca,'fontname','times new roman')
    set(gca,'units','centimeters')
    set(gca,'Position',[1.2785    1.2012    5.9928    4.2042])
    xlim([5 40])
    
    
    P1 = prctile(YI,1,2);
    P5 = prctile(YI,5,2);
    P95 = prctile(YI,95,2);  
    P99 = prctile(YI,99,2);
    P50 = prctile(YI,50,2);
    
    F = fill([P5; flipud(P95)],[x; flipud(x)],'b');
    F.FaceAlpha = 0.6;
    F.EdgeColor = 'none';
    
    F98a = fill([P1; flipud(P5)],[x; flipud(x)],'b');
    F98a.FaceAlpha = 0.3;
    F98a.EdgeColor = 'none';
    
    F98b = fill([P95; flipud(P99)],[x; flipud(x)],'b');
    F98b.FaceAlpha = 0.3;
    F98b.EdgeColor = 'none';
    
    P50plot = plot(P50,x,'k-','LineWidth',2);

    EPP = epp(Dmax);
    EPP.MarkerEdgeColor = 'r';
    EPP.SizeData = 50;
    
    L = legend([EPP,P50plot,F,F98a],'Data - weekly deepest ridges','Simulation - best estimate','90% confidence interval','98% confidence interval');
    L.Position = [0.4811    0.7077    0.4824    0.2533];
    
 
    
end
















