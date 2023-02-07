% --- WORK IN PROGRESS ---

%%
% This script is similar to S007a, but with different figures.
% See S007a for further description.

clear all
close all

MatFilesFolder = 'c:\Users\ilijas\OneDrive - NTNU\PhD\IceRidges\MAT files';

yr = 12;
office_screens = 1;
mooring_location = 'b';

addpath('Supporting Files\')

%%

level_ice_time = 1;             %   duration of sample for LI estimate (in hours)
level_ice_statistics_days = 7;  %   duration of sample of estimated LI for LI statistics (in days)

%%      LOADING THE DATA AND CALCULATING DIFFERENT LEVEL ICE STATISTICS (ESTIMATING LEVEL ICE)

load([MatFilesFolder,'\uls', sprintf('%02d',yr) ,mooring_location,'_draft.mat'])

%       loading the time and draft, dt1 needs to be estimated and time recalculated because sometimes there
%       is small error in time sequence that causes error in peak over treshold function later on
t = Data.dateNUM;
dt1 = mean(diff(t));
t = [t(1):dt1:t(end)]';
h = Data.draft;

%       calulating the time time interval of the data
dt = round(mean(diff(t))*24*3600);

%       reshaping the time and draft matrices to calculate means and modes
mean_time = 3600*level_ice_time;
mean_points = mean_time/dt;
no_e = floor(length(t)/mean_points)*mean_points;
t_reshape = t(1:no_e);
t_reshape = reshape(t_reshape,mean_points,floor(length(t)/mean_points));
h_reshape = h(1:no_e);
h_reshape = reshape(h_reshape,mean_points,floor(length(t)/mean_points));

%       calculating the mode, first have to multiply it by a number (1000) -> round -> mode -> divide by number
%       this has to be done because mode is working with integer values
h_LI_mode = mode(round(h_reshape*1000),1)/1000;

%       calculating the mean time and the mean ice thickness
t_LI = mean(t_reshape,1);
h_mean = mean(h_reshape);

%%      ESTIMATING THE LEVEL ICE STATISTICS FOR EACH "level_ice_statistics_time" PERIOD

%       defining the histogram bins and initialization of moving histogram
HistBins = [-0.1:0.1:8];

%       setting the period (already defined in the beginning)
period = (24/level_ice_time)*level_ice_statistics_days;
h_LI_DM = [];
h_LI_AM = [];
t_LI_TEMP = [];
HHi = [];
ws = [];
we = [];
i = 0;
t_hist = zeros(length(1:period:length(h_LI_mode)-period),1);

%       loop for estimating LI histogram for each "level_ice_statistics_days" period
for n = 1:period:length(h_LI_mode)-period
    i = i+1;
    HHi(i,:) = histcounts(h_LI_mode(n:n+period),HistBins);
%     HH.BinCounts = HHi(i,:);
    t_hist(i,1) = mean(t_LI(n:n+period));
    
    h_SubSet =  h(  (h<3.0) &(h>0.0) & (t>t_LI(n)) & (t<t_LI(n+period))) ;
    
    if numel(h_SubSet)>100
        bw_sigma = std(h_SubSet);
        bw_n = numel(h_SubSet);
        bw_h(n) = 1.06*bw_sigma*bw_n^-0.2;
        [f,xi]=ksdensity(h_SubSet(h_SubSet<5),'Bandwidth',bw_h(n),'NumPoints',100 ) ;
        [pks,locs] = findpeaks(f,xi);
        
        if not(isempty(max(locs(   (locs<3) & (pks>0.3)    ))))
            h_LI_DM = [h_LI_DM; max(locs(   (locs<3) & (pks>0.3)    ))];
            
            [pks1,locs1] = max(f);                                    % intensity and location of the absolute mode
            h_LI_AM = [h_LI_AM; xi(locs1)];            
            
            t_LI_TEMP = [t_LI_TEMP; mean(t_LI(n:n+period))];
            
            
            ws = [ws; t_LI(n)];
            we = [we; t_LI(n+period)];
        end
        
    end
    
    
    
end
hh = HistBins(1:end-1)+diff(HistBins)/2;

clear HistBins n i
%%

myfig(16,1); grid on; box on;
cf = gcf;
if office_screens == 1
    cf.Position = [2570        1000         650         350];
else
    cf.Position = [600,100,900,400];
    set(gcf,'Position',[50,50,1000,400])
end
xlabel('Time [months]','FontSize',12)
ylabel('Ice draft [m]','FontSize',12)
title(['20' num2str(yr) '   ' upper(mooring_location)])

axis([-inf inf 0 3])
C = max(max(HHi));
caxis([0 C/2/169])

[X,Y] = meshgrid(t_hist,hh-0.00);
surf(X,Y,HHi'/169)
shading interp
colormap(othercolor('BuOr_10'))
c = colorbar;
c.Label.String = 'Probability mass [-]';
c.FontSize = 10;
dynamicDateTicks()

xlim([min(X(:)) max(X(:))])

P3 = plot3(t_LI_TEMP,  h_LI_DM,50*ones(1,length(h_LI_DM)),'color',[0.2 0.2 0.2],'Marker','square','MarkerSize',6,'LineStyle','none');
P3 = plot3(t_LI_TEMP,  h_LI_AM,50*ones(1,length(h_LI_DM)),'color',[0.2 0.2 0.2],'Marker','x','MarkerSize',4,'LineStyle','none');

myfig(18,1); f8 = gcf; ylim([0 5])
if office_screens == 1
    f8.Position = [2571        100        1000        400];
else
    f8.Position = [51,554.3333,1600,306];
end
sp1 = subplot(2,6,1:4); hold on; grid on; box on
% sp1.Position = [0.1300    0.195    0.42    0.78]
ylim([0 5])
ID = reduce_plot(t,h,'k');
xlabel('Time [days]')
ylabel('Ice draft [m]')
r = patch([t(1) t(1)+1  t(1)+1 t(1)],[0 0 5 5],'r');
r.EdgeColor = 'none'
r.FaceAlpha = 0.3;

dynamicDateTicks

sp3 = subplot(2,4,5:8); hold on; grid on; box on;
ylim([0 5])
reduce_plot(t,h,'k')
xlabel('Time [hours]')
ylabel('Ice draft [m]')
dynamicDateTicks



%%
figure(16)
[x,y] = ginput(1);

[m,i] = min(abs(t_LI_TEMP-x));

if exist('PCdm')
    delete(PCdm);
    delete(PCam);
end
PCdm = plot3(t_LI_TEMP(i),  h_LI_DM(i),50,'square','MarkerEdgeColor','r','MarkerSize',10,'linewidth',1);
PCam = plot3(t_LI_TEMP(i),  h_LI_AM(i),50,'square','MarkerEdgeColor','r','MarkerSize',10,'linewidth',1);

figure(18)
sp2 = subplot(2,6,5:6);
cla; hold on; grid on; box on;
axis(sp2,[0 3 0 4])
h_SubSet =  h(  (h<3.0) &(h>0.0) & (t>ws(i)) & (t<we(i))) ;
histogram(h_SubSet,0:0.1:3,'Normalization','pdf','facecolor','k')
sp2.YLim = [0 4];
if exist('Hdm')
    delete(Hdm);
    delete(Ham);
end

bw_sigma = std(h_SubSet);
bw_n = numel(h_SubSet);
bw_h = 1*1.06*bw_sigma*bw_n^-0.2;
[f,xi]=ksdensity(h_SubSet(h_SubSet<5),'Bandwidth',bw_h,'NumPoints',200 ) ;
[pks,locs] = findpeaks(f,xi);
plot(xi,f,'r','LineWidth',2)

xlabel('Ice draft [m]')
ylabel('Probability density [m^{-1}]')
legend('Hist.','PDF')

figure(18)
sp1.XLim = [ws(i) we(i)];
dynamicDateTicks(sp1)
if exist('hdm')
    delete(hdm);
    delete(ham);
end
hdm = plot(sp1,get(sp1,'xlim'),[h_LI_DM(i) h_LI_DM(i)],'r--','LineWidth',2);
ham = plot(sp1,get(sp1,'xlim'),[h_LI_AM(i) h_LI_AM(i)],'r','LineWidth',2);
L = legend(sp1,[ID hdm ham],'Ice draft','DM','AM','Ice drift speed','Location','northwest');

sp1.XLim = [ws(i) we(i)];

%%
DayNumber = 5;
sp3.XLim = [round(ws(i)+DayNumber) round(ws(i)+DayNumber+1)];
if exist('hdmD')
    delete(hdmD);
    delete(hamD);
end
hdmD = plot(sp3,get(sp1,'xlim'),[h_LI_DM(i) h_LI_DM(i)],'r--','LineWidth',2);
hamD = plot(sp3,get(sp1,'xlim'),[h_LI_AM(i) h_LI_AM(i)],'r','LineWidth',2);
r.XData = [round(ws(i)+DayNumber) round(ws(i)+DayNumber+1) round(ws(i)+DayNumber+1) round(ws(i)+DayNumber)];

zoom(sp1,'out')
zoom(sp3,'out')




