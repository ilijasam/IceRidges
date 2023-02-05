%% This script is used for analysing the results from S003
% It loops through the weeks of a selected season/location

% Instructions for looping through the weeks
%     - Select a season/year in Cyear and Cloca variables  
%     - run the script
%     - NumPad1 for going one week back
%     - NumPad2 for going one week forward
%     - Esc for stopping the loop


clc
clear all
close all

load('Results\results1.mat')
load('Supporting Files\co.mat')
MatFilesFolder = 'c:\Users\ilijas\OneDrive - NTNU\PhD\IceRidges\MAT files';
office_screens = 1;

% Define season and location that is to be analysed
Cyear = 2017;       % (e.g., 2017 for 2017/2018 season)
Cloca = 4;          % (1 - location A; 2-B; 3-C; 4-D)
Location_vector = ['a';'b';'c';'d'];
id = ID(YR == Cyear & LC == Cloca);

ThisYear = Year == Cyear & Location == Cloca;

%% Loading of the raw ULS draft signal
load([MatFilesFolder,'\uls', sprintf('%02d',Cyear-2000) ,Location_vector(Cloca),'_draft.mat'])
h = Data.draft;
t = Data.dateNUM;
dt1 = mean(diff(t));
% there were some errors in time steps for some years, I need it equidistant in order for some routines to work
if not(min(diff(t))>0)
    t = [t(1):dt1:t(end)]';
end

%% --------------------------------------------------------------------------
myfig(1,1)
if office_screens==1
    set(gcf,'Position',[3000        1100        1022         199])
else
    set(gcf,'Position',[10 1150 700 200])
end
axis([-inf inf 0 30])
yticks([0:0.5:2 3:5 10:5:30])
PP = patch([t(1) t(end) t(end) t(1)],[0 0 30 30],'g','facealpha',0.2);

ULS_Draft_Signal = reduce_plot(t,h);
RidgePeaks = scatter(  cell2mat(T_all{id}') ,cell2mat(D_all{id}'),'r.','SizeData',20);
LI_Thickenss = stairs(T(ThisYear)-3.5,LI_DM(ThisYear),'k','LineWidth',2);

legend([ULS_Draft_Signal,RidgePeaks,LI_Thickenss],'Raw ULS draft signal','Individual ridge peaks','Level ice draft estimate')

dynamicDateTicks

%% --------------------------------------------------------------------------

myfig(2,1)
if office_screens==1
    set(gcf,'Position',[3000        100         2000         890])
else
    set(gcf,'Position',[10 1150 700 200])
end
AX2 = gca;
axis([-inf inf 0 25])
yticks([0:0.5:2 3:5 10:5:30])
title('Current week - indicated with the green box in Figure 1')

reduce_plot(t,h)
scatter(  cell2mat(T_all{id}') ,cell2mat(D_all{id}'),'rv','SizeData',6)
stairs(T(ThisYear)-3.5,LI_DM(ThisYear),'k','LineWidth',2)

dynamicDateTicks

%% --------------------------------------------------------------------------

myfig(3,1)
set(gcf,'Position',[2587         100         344        1200])

subplot(4,1,1); hold on; grid on;
caxis([0 1])
colormap(flipud(othercolor('RdYlBu_11b')))
axis([0 3 5 9])
xlabel('LI DM [m]')
ylabel('Mean ridge keel depth [m]')
scatter(LI_DM,M,36,ThisYear,'filled','MarkerFaceAlpha',0.4);
scatter(LI_DM(ThisYear),M(ThisYear),10,ThisYear(ThisYear)*10,'filled','MarkerFaceAlpha',1);
CP1 = scatter(0.2,7,'square','k','linewidth',1,'sizedata',80);
T1 = title('t');

%--------------------------------------------------------------------------
subplot(4,1,2); hold on; grid on;
axis([0 3 0 6])
AX33 = gca;
DMline = plot([0 0],[0 6],'color',co(1,:),'linewidth',2);
AMline = plot([0 0],[0 6],'--','color',co(2,:),'linewidth',2);
HH = [];
K = plot(0,0,'color','r','linewidth',2);
PS = scatter(0,0,'k','filled');
legend([AMline DMline],'AM','DM')

%--------------------------------------------------------------------------
subplot(4,1,3); hold on; grid on;
axis([0 3 0 30])
xlabel('LI DM [m]')
ylabel('Weekly deepest ridge [m]')
scatter(LI_DM,Dmax,36,ThisYear*10,'filled','MarkerFaceAlpha',0.4);
scatter(LI_DM(ThisYear),Dmax(ThisYear),10,ThisYear(ThisYear)*10,'filled','MarkerFaceAlpha',1);
CP3 = scatter(0.2,7,'square','k','linewidth',1,'sizedata',80);
T3 = title('t');

%--------------------------------------------------------------------------
subplot(4,1,4); hold on; grid on;
axis([0 3 0 1200])
xlabel('LI DM [m]')
ylabel('Number of ridges [-]')
scatter(LI_DM,N,36,ThisYear*10,'filled','MarkerFaceAlpha',0.4);
scatter(LI_DM(ThisYear),N(ThisYear),10,ThisYear(ThisYear)*10,'filled','MarkerFaceAlpha',1);
CP4 = scatter(0.2,7,'square','k','linewidth',1,'sizedata',80);
T4 = title('t');

i = 1;
%% Looping thorugh the weeks
nn = 1:length(ThisYear);
nn = nn(ThisYear);

br = 0;
while not(br == 27)
    n = nn(i);
    AX2.XLim = [WS(n) WE(n)];
    CP1.XData = LI_DM(n);
    CP1.YData = M(n);
    CP3.XData = LI_DM(n);
    CP3.YData = Dmax(n);
    CP4.XData = LI_DM(n);
    CP4.YData = N(n);
    PP.XData = [WS(n) WE(n) WE(n) WS(n)];
    T1.String = sprintf('LI DM = %.2f m    ||  M = %.2f m',LI_DM(n),M(n));
    T3.String = sprintf('LI DM = %.2f m    ||  D = %.2f m',LI_DM(n),Dmax(n));
    T4.String = sprintf('LI DM = %.2f m    ||  N = %.0f ',LI_DM(n),N(n));
    
    h_SubSet = h(  (h>0.0) & (t>WS(n)) & t<WE(n)) ;
    delete(HH)
    HH = histogram(AX33,h_SubSet,0:0.05:4,'facecolor','k','normalization','pdf');
    
    bw_sigma = std(h_SubSet);
    bw_n = numel(h_SubSet);
    bw_h(n) = 1.06*bw_sigma*bw_n^-0.2;
    
    %       calculating the kernel estimate of the draft PDF
    [f,xi,bw]=ksdensity(h_SubSet,'Bandwidth',bw_h(n)) ;
    
    K.XData = xi;
    K.YData = f;
    
    [pks,locs] = findpeaks(f,xi);                           % intensities and locations of all modes
    PS.XData = locs;
    PS.YData = pks;
                
    DM(n) = max(locs(   (locs<3) & (pks>0.1)    ));         % deepest mode estimate
    [pks,locs] = max(f);                                    % intensity and location of the absolute mode
    AM(n) = xi(locs);
    
    AMline.XData = [AM(n) AM(n)];
    DMline.XData = [DM(n) DM(n)];
    
    w = waitforbuttonpress;
    br = double(get(gcf,'CurrentCharacter'));
    if br == 50
        i = min(length(nn),i+1);
    elseif br == 49
        i = max(1,i-1);
    end    
    
end
