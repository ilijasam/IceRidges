% --- WORK IN PROGRESS ---

% This script is calculating the "running level ice (LI) statistics".

% First, it estimates the level ice from the signal by calulating the mode. This is done by taking samples with duration of "level_ice_time".
% Then, with this estimated LI, we do the statistics every "level_ice_statistics_time" days.
% Final plot shows the histograms throughout the year. It is in a way the yearly level ice statistics.

% - The script is optimized for 2012D data set, but it can be used for other seasons/locations

% INSTRUCTIONS
% After running the script the user need to pick one point on Figure 16

clear all
close all

addpath('Supporting Files\')
MatFilesFolder = 'c:\Users\ilijas\OneDrive - NTNU\PhD\IceRidges\MAT files';

yr = 12;                        % Chose season to be analysed (e.g., 12 for 2012/2013)
office_screens = 1;             % If 1, this works with double screen. Please update figure positions to your display layout.
PlotMidResults = 0;             % Plot temporary results in Figure 22?        
mooring_location = 'b';         % Chose mooring location

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

clear dt1 dt no_e t_reshape mean_time mean_points


%%      ESTIMATING THE LEVEL ICE STATISTICS FOR EACH "level_ice_statistics_time" PERIOD

myfig(22,1)
FIG22 = figure(22);
if office_screens==1
    set(gcf,'Position', [2570.00        600.00        560.00        300.00]);
else
    set(gcf,'Position',[100 100 435 245])
end
%       subolot of level draft signal and level ice estimate as a reference to know where you are at each step
%       Tline(s) are showing the middle of current estimate and the range of the current bin
subplot(2,1,1)
hold on
grid on
axis([-inf inf 0 30])
plot(t(1:20:end),h(1:20:end))
plot(t_LI,h_LI_mode,'k','LineWidth',1)
dynamicDateTicks()

%       initializing subplot for the histograms for each "level_ice_statistics_days"
subplot(2,1,2)
hold on
grid on
axis([0 6 0 4])
MLine = plot([0 0],[0 12],'r');             % initializing the line that indicates the location of the mode

%       defining the histogram bins and initialization of moving histogram
HistBins = [-0.1:0.1:8];
HH = histogram(h_LI_mode,HistBins,'Normalization','pdf','EdgeColor','k');

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
    HH.BinCounts = HHi(i,:);
    t_hist(i,1) = mean(t_LI(n:n+period));
    
    h_SubSet =  h(  (h<3.0) &(h>0.0) & (t>t_LI(n)) & (t<t_LI(n+period))) ;
    
    if numel(h_SubSet)>100
        bw_sigma = std(h_SubSet);
        bw_n = numel(h_SubSet);
        bw_h(n) = 1.06*bw_sigma*bw_n^-0.2;
        [f,xi]=ksdensity(h_SubSet(h_SubSet<5),'Bandwidth',bw_h(n),'NumPoints',100 ) ;
        [pks,locs] = findpeaks(f,xi);
        
        if not(isempty(max(locs(   (locs<3) & (pks>0.25)    ))))
            h_LI_DM = [h_LI_DM; max(locs(   (locs<3) & (pks>0.25)    ))];
            
            [pks1,locs1] = max(f);                                    % intensity and location of the absolute mode
            h_LI_AM = [h_LI_AM; xi(locs1)];
            
            
            MLine.XData = [ones(2,1)*h_LI_DM(end)];
            t_LI_TEMP = [t_LI_TEMP; mean(t_LI(n:n+period))];
            
            
            ws = [ws; t_LI(n)];
            we = [we; t_LI(n+period)];
        end
        
    end
        
    if PlotMidResults == 1
    drawnow
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

myfig(17,1); f7 = gcf ; ax7 = gca;
if office_screens == 1
    f7.Position = [3250        1000         400         350];
else
    f7.Position = [1150,90,400,350];
end


myfig(18,1); f8 = gcf; ylim([0 5])
if office_screens == 1
    f8.Position = [2571        100        2400        400];
else
    f8.Position = [51,554.3333,1600,306];
end
reduce_plot(t,h)
dynamicDateTicks
ax8 = gca;

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

figure(17)
clf; hold on; grid on; box on;
h_SubSet =  h(  (h<3.0) &(h>0.0) & (t>ws(i)) & (t<we(i))) ;
histogram(h_SubSet,0:0.1:3,'Normalization','pdf')
if exist('Hdm')
    delete(Hdm);
    delete(Ham);
end
Hdm = plot([h_LI_DM(i) h_LI_DM(i)],get(gca,'ylim'),'k--','LineWidth',2);
Ham = plot([h_LI_AM(i) h_LI_AM(i)],get(gca,'ylim'),'k-','LineWidth',2);

bw_sigma = std(h_SubSet);
bw_n = numel(h_SubSet);
bw_h = 1*1.06*bw_sigma*bw_n^-0.2;
[f,xi]=ksdensity(h_SubSet(h_SubSet<5),'Bandwidth',bw_h,'NumPoints',100 ) ;
[pks,locs] = findpeaks(f,xi);
PDFk = plot(xi,f,'r','LineWidth',2);

legend([PDFk,Ham,Hdm],'PDF','AM','DM')

figure(18)
ax8.XLim = [ws(i) we(i)];
dynamicDateTicks
if exist('hdm')
    delete(hdm);
    delete(ham);
end
hdm = plot(get(gca,'xlim'),[h_LI_DM(i) h_LI_DM(i)],'k--','LineWidth',2);
ham = plot(get(gca,'xlim'),[h_LI_AM(i) h_LI_AM(i)],'k-','LineWidth',2);

legend([ham,hdm],'AM','DM')

ax8.XLim = [ws(i) we(i)];
