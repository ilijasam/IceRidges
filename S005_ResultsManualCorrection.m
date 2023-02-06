% This script is used to analyse the level ice draft identification point by point. First, year and
% location is specified of the mooring subset to be analysed. Analysis is done by observing several figures.

% Figure 1 illustrates a whole year of draft data suplemented with level ice draft and identified keels.

% Figure 2 zoomed in section of the current week's data.

% Figure 3 has four subplots showing the following :
% SP1 : LI DM vs Mean ridge keel draft
% SP2 : Draft histogram, PDF, AM, DM
% SP3 : LI DM vs Weekly deepest ridge draft
% SP4: LI DM vs Number of ridges

% Figure 4 shows the "distogram" plot where evolution of the level ice can be seen and outliers can
% be identified more reliably

% INSTRUCTIONS FOR GOING THROUGH THE LOOP
% 
%     - Arrow right     -   Go one week forward
%     - Arrow left      -   Go one week back
%     - Arrow up        -   Go 5 weeks forward
%     - Arrow down      -   Go 5 weeks back
%     - NumPad 0        -   Select the point to be analysed in Figure 4 (only horisontal location is enogh)
%     - Enter           -   Correct the location of level ice thickness in Figure 3
%     - NumPad -        -   Delete current point
%     - Esc             -   Go forward to next season/location

% In order to close the loop completely do the following
%       First press "NumPad +" and then press "Esc"

% This script requires ULS data in .mat format. The data is stored in folder defined in MatFilesFolder variable

clear all
close all
clc

addpath('Supporting Files\')
MatFilesFolder = 'c:\Users\ilijas\OneDrive - NTNU\PhD\IceRidges\MAT files';  % define folder with .mat files with ULS draft data
load('co.mat')
office_screens = 1;
Location_vector = ['a';'b';'c';'d'];

load('Results\results1')                    % !!! LOAD RESULTS FROM S003
% load('Results\ManualCorrection_3.mat')    % !!! LOAD PREVIOUS MANUAL CORRECTION RESULTS (IF AVAILABLE)

% deleting data points that have less ridges than difined in Ntreashold
Ntreashold = 15;
LI_DM(N<Ntreashold) = [];
LI_AM(N<Ntreashold) = [];
D(N<Ntreashold) = [];
M(N<Ntreashold) = [];
WS(N<Ntreashold) = [];
WE(N<Ntreashold) = [];
ThisYear(N<Ntreashold) = [];
T(N<Ntreashold) = [];
Dmax(N<Ntreashold) = [];
Year(N<Ntreashold) = [];
Location(N<Ntreashold) = [];
PKSall(N<Ntreashold,:) = [];
LOCSall(N<Ntreashold,:) = [];
N(N<Ntreashold) = [];

% Defining which years to be analysed for 4 different locations A, B, C, D
% Define the same location/seasons as in S003 if all data is to be manually revised/corrected

% These are the location/seasons used in Samardžija & Høyland (2023)
loc_yrs{1} = [03:08 10:15 16 17];
loc_yrs{2} = [03 04 06 08 10 12 13 15 16 17];
loc_yrs{3} = [03 04 05 07];
loc_yrs{4} = [06 07 08 10 12 13 14 16 17];


for Cloca = 1:4
    for Cyear = 2000+loc_yrs{Cloca}
        
        id = ID(YR == Cyear & LC == Cloca);
        ThisYear = Year == Cyear & Location == Cloca;   
        
        %% LOADING THE DRAFT DATA
        load([MatFilesFolder,'\uls', sprintf('%02d',Cyear-2000) ,Location_vector(Cloca),'_draft.mat'])
        h = Data.draft;
        t = Data.dateNUM;
        dt1 = mean(diff(t));
        % there were some errors in time steps for some years, I need it equidistant in order for some routines to work
        if not(min(diff(t))>0)
            t = [t(1):dt1:t(end)]';
        end
        
        %% DISTOGRAM PLOT
        
        myfig(4,1); hold on; grid on; box on; f4 = gcf; f4.Position = [3000        1020         647         309];
        
        level_ice_time = 1;             %   duration of sample for instantaneous LI estimate (in hours)
        level_ice_statistics_days = 7;  %   duration of sample of estimated LI for LI statistics (in days)
        
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
        
        % hi is the instantaneous LI draft estimated by finding the mode of the distribution. Multiplication
        % with 1000, finding the mode and subsequent division by 1000 is done because the mode function bins
        % the data in integers. t_LI is the time of the instantaneous estimates.
        hi = mode(round(h_reshape*1000),1)/1000;
        t_LI = mean(t_reshape,1);
        
        % Here we make weekly histograms that are later used for creating the distogram plot
        HistBins = [-0.1:0.1:8];
        period = (24/level_ice_time)*level_ice_statistics_days;
        i = 0;
        clear HHi t_hist
        for n = 1:period:length(hi)-period
            i = i+1;
            HHi(i,:) = histcounts(hi(n:n+period),HistBins);
            t_hist(i,1) = mean(t_LI(n:n+period));
        end
        
        % Creating and plotting the distogram plot with AM and DM draft identification
        hh = HistBins(1:end-1)+diff(HistBins)/2;
        [X,Y] = meshgrid(t_hist,hh-0.00);
        
        set(gca,'clim',[0 0.4])
        ylim([0 3])
        surf(X,Y,HHi'/169)
        
        shading interp
        colormap(othercolor('BuOr_10'))
        c = colorbar;
        c.Label.String = 'Probability density [-]';
        c.FontSize = 10;
        
        dynamicDateTicks
        xlim([t_LI(1)+3.5 t_LI(end)-10.5])
        
        Scatter_DM = scatter3(T(ThisYear),LI_DM(ThisYear),10*ones(sum(ThisYear),1),'k','Marker','o');
        Scatter_AM = scatter3(T(ThisYear),LI_AM(ThisYear),10*ones(sum(ThisYear),1),'k','Marker','x','SizeData',20);
        
        CP44 = scatter3(0,0,10,'square','r','linewidth',1,'sizedata',150,'linewidth',2);
        
        legend([Scatter_AM,Scatter_DM],'AM','DM')
        
        %% --------------------------------------------------------------------------
        myfig(1,1);
        if office_screens==1
            set(gcf,'Position',[3800        1180        1062         165])
        else
            set(gcf,'Position',[10 1150 700 200])
        end
        axis([-inf inf 0 30])
        yticks([0:0.5:2 3:5 10:5:30])
        PP = patch([t(1) t(end) t(end) t(1)],[0 0 30 30],'g','facealpha',0.2);
        reduce_plot(t,h)
        
        scatter(  cell2mat(T_all{id}') ,cell2mat(D_all{id}'),'r.','SizeData',20)
        stairs(T(ThisYear)-3.5,LI_DM(ThisYear),'k','LineWidth',2)        
        
        dynamicDateTicks
        
        %% --------------------------------------------------------------------------
        
        myfig(2,1);
        if office_screens==1
            set(gcf,'Position',[3000        100        2000         800])
        else
            set(gcf,'Position',[10 1150 700 200])
        end
        AX2 = gca;
        axis([-inf inf 0 5])
        yticks([0:0.5:2 3:5 10:5:30])
        reduce_plot(t,h)
        
        TTT = T(ThisYear);
        
        scatter(  cell2mat(T_all{id}') ,cell2mat(D_all{id}'),'rv','SizeData',6)
        stairs(T(ThisYear)-3.5,LI_DM(ThisYear),'k','LineWidth',2)
        
        dynamicDateTicks
        
        
        %% --------------------------------------------------------------------------
        
        myfig(3,1);
        set(gcf,'Position',[2571         100         402        1135])
        
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
        DMline = plot([0 0],[0 6],'color','r','linewidth',3);
        % DMline1 = plot([0 0],[0 6],'color','b','linewidth',3);
        AMline = plot([0 0],[0 6],'--','color','k','linewidth',2);
        HH = [];
        K = plot(0,0,'color','b','linewidth',2);
        PS = scatter(0,0,'bx','sizedata',80);
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
        %%
        nn = 1:length(ThisYear);
        nn = nn(ThisYear);
        
        % for n = nn(ThisYear)
        br = 0;
        figure(4);
        title([sprintf(['Location: '  upper(Location_vector(Cloca)) '       Season: %d / %d'],Cyear,Cyear+1)])
        BreakSwitch = 0;
        while not(br == 27)  % br = 27 is when user presses Esc
            n = nn(i);
            AX2.XLim = [WS(n) WE(n)];
            CP1.XData = LI_DM(n);
            CP1.YData = M(n);
            CP3.XData = LI_DM(n);
            CP3.YData = Dmax(n);
            CP4.XData = LI_DM(n);
            CP4.YData = N(n);
            CP44.XData = T(n);
            CP44.YData = LI_DM(n);
            PP.XData = [WS(n) WE(n) WE(n) WS(n)];
            T1.String = sprintf('LI DM = %.2f m    ||  M = %.2f m',LI_DM(n),M(n));
            T3.String = sprintf('LI DM = %.2f m    ||  D = %.2f m',LI_DM(n),Dmax(n));
            T4.String = sprintf('LI DM = %.2f m    ||  N = %.0f ',LI_DM(n),N(n));
            
            h_SubSet = h( (h<3.0) & (h>0.0) & (t>WS(n)) & t<WE(n)) ;
            delete(HH)
            HH = histogram(AX33,h_SubSet,0:0.05:4,'facecolor','k','normalization','pdf');
            
            bw_sigma = std(h_SubSet);
            bw_n = numel(h_SubSet);
            bw_h(n) = 1.06*bw_sigma*bw_n^-0.2;
            
            %       calculating the kernel estimate of the draft PDF
            [f,xi,bw1]=ksdensity(h_SubSet,'Bandwidth',bw_h(n)) ;
            K.XData = xi;
            K.YData = f;
            [pks,locs] = findpeaks(f,xi);                           % intensities and locations of all modes
            PS.XData = locs;
            PS.YData = pks;
            DM(n) = max(locs(   (locs<3) & (pks>0.25)    ));         % deepest mode estimate
            
            [pks,locs] = max(f);                                    % intensity and location of the absolute mode
            AM(n) = xi(locs);
            
            % Create lines indicating location of AM and DM in Figure3/Subplot2
            AMline.XData = [AM(n) AM(n)];
            DMline.XData = [DM(n) DM(n)];
            
            % looping control
            w = waitforbuttonpress;
            br = double(get(gcf,'CurrentCharacter'));            
            if br == 29                         % arrow right
                i = min(length(nn),i+1);
            elseif br == 28                     % arrow left
                i = max(1,i-1);
            elseif br == 30                     % arrow up
                i = min(length(nn),i+5);
            elseif br == 31
                i = min(length(nn),i-5);        % arrow down
            elseif br == 48                     % NumPad0
                [xx,yy] = ginput(1);
                [m,i] = min(abs(T(ThisYear)-xx));
            elseif br == 13                     % Enter
                figure(3)
                [xx,yy] = ginput(1);
                LI_M(n) = xx;
                figure(4)
            elseif br == 45                     % NumPad -
                to_delete(n) = true;
            elseif br == 43                     % NumPad +
                BreakSwitch = 1;
            end
            
            
        end
        if BreakSwitch == 1
            break
        end
    end
    if BreakSwitch == 1
        break
    end
end

% Save the manually corrected results. One can override the previously defined and loaded manual correction results or
% make new data file.

% save('ManualCorrection_3.mat','to_delete','LI_M')

