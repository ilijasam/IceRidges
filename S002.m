% for the previous version of this script see "DRAFT_Q_Median_Ice.m"

% This script is mooring/year datasets, determines the level ice draft by analysing the draft
% distrivbution and extracts ridge paramenters (deepest, mean, number of ridges).
addpath('Supporting Files\')

% Defining the folder that contains the data in .mat format
MatFilesFolder = 'c:\Users\ilijas\OneDrive - NTNU\PhD\IceRidges\MAT files';

plotresults = 1;
office_screens = 1;
estimate_hourly = 0;

level_ice_time = 3;                 %   duration of sample for LI estimate (in hours)
level_ice_statistics_days = 7;   	%   duration of sample of estimated LI for LI statistics (in days)

CompletePlot3 = [];
CompletePlot4 = [];
CompletePlot5 = [];
CompletePlot6 = [];
CompletePlot7 = [];
CompletePlot8 = [];

%       make empty vectors if it is the first year to be evaluated
if not(exist('LI'))
    LI_DM = [];         %   level ice estimate
    LI_AM = [];         %   level ice estimate DEEPEST MODE
    D = [];             %   deepest keel estimate
    N = [];             %   number of ridges
    M = [];             %   mean keel depth
    T = [];             %   mean time in the week's subsample
    WS = [];            %   week start timing
    WE = [];            %   week end timing
    D_all = [];         %   collection of all of the keels
    T_all = [];         %   collection of all the times
    Year = [];          %   year of the specific datapoint (week)
    Location = [];      %   location of the specific datapoint (week)
    Dmax = [];          %   maximum deel depth
    PKSall = [];        %   all of the distribution's peaks values
    LOCSall = [];       %   all of the distribution's peaks locations
end

% defining strings abcd for corresponding 1234 locations
Location_vector = ['a';'b';'c';'d'];

% defining which years to be analysed for 4 different locations
loc_yrs{1} = [03:08 10:15 16 17];
loc_yrs{2} = [03 04 06 08 10 12 13 15 16 17];
loc_yrs{3} = [03 04 05 07];
loc_yrs{4} = [06 07 08 10 12 13 14 16 17];

PKS = zeros(5000,100);
LOCS = zeros(5000,100);

SetsNum = numel(loc_yrs{1})+numel(loc_yrs{2})+numel(loc_yrs{3})+numel(loc_yrs{4});

i = 0;
tic
for mooring_location = 1:4
% for mooring_location = 1
    
    % reading the corresponding string abcd for location number 1234
    loc_mooring = Location_vector(mooring_location,1);
    
    
    for yr = loc_yrs{mooring_location}
%     for yr = 14:15
        fprintf('ML: %.0f   YR: %.0f \n',mooring_location,yr);
        i = i+1;
        ID(i,1) = i;
        YR(i,1) = 2000+yr;
        LC(i,1) = mooring_location;
        
        keep yr office_screens estimate_hourly level_ice_time level_ice_statistics_days...
            CompletePlot3 CompletePlot4  CompletePlot5 CompletePlot6 CompletePlot7 CompletePlot8...
            LI_AM LI_DM D N M T D_all T_all Dmax Year Location loc_mooring...
            ID i YR LC WS WE mooring_location Location_vector loc_yrs plotresults PKS LOCS PKSall LOCSall SetsNum MatFilesFolder
        
        load([MatFilesFolder,'\uls', sprintf('%02d',yr) ,loc_mooring,'_draft.mat'])
        
        %%
        
        h = Data.draft;
        t = Data.dateNUM;
        dt1 = mean(diff(t));
        % there were some errors in time steps for some years, I need it equidistant in order for some routines to work
        if not(min(diff(t))>0)
            t = [t(1):dt1:t(end)]';
        end
        % calulating the time time interval of the data
        dt = round(dt1*24*3600);
        
        %%
        %       estimating the "instantanious LI thickness"
        %       the time frame is defined in "level_ice_time"
        if estimate_hourly==1
            %       reshaping the time and draft matrices to calculate means and modes
            mean_time = 3600*level_ice_time;
            mean_points = mean_time/dt;
            no_e = floor(length(t)/mean_points)*mean_points; % number of elements to take in, so it is dividable with number of "mean_points" per specified "level_ice_time"
            t_reshape = t(1:no_e);
            t_reshape = reshape(t_reshape,mean_points,floor(length(t)/mean_points));
            h_reshape = h(1:no_e);
            h_reshape = reshape(h_reshape,mean_points,floor(length(t)/mean_points));
            
            %       estimating LI thickness using mode (AM - absolute mode)
            t_LI = mean(t_reshape,1); % time for LI predictions that are about to be estimated
            clear h_LI2
            for n = 1:length(t_LI)
                [f,xi]=ksdensity(h_reshape(:,n)) ;
                [fmax imax] = max(f);
                h_LI2(n) = xi(imax);
            end
        end
        
        clear adcp no_e i_max fmax f xi dt1 n imax mean_time mean_points Data
        %%      RAYLEIGH CRITERIA
                
        h_tres = 2.5;
        h_k_min = 5;
        
        if isfile(['RC data\', sprintf('%02d',yr) ,loc_mooring,'.mat'])
            load(['RC data\', sprintf('%02d',yr) ,loc_mooring,'.mat'])
        else
            [T_R,H_R] = RC(t,h,h_tres,h_k_min)  ;
            save(['RC data\', sprintf('%02d',yr) ,loc_mooring,'.mat'],'T_R','H_R')
        end
                
        clear h_tres
        %%      RIDGE STATISTICS
        
        %       Transferring the time vector into a matrix t_reshape_R with N colums (weeks).
        %       This is necessary in order to evaluate weekly statistics.
        mean_time_R = 3600*24*level_ice_statistics_days;
        mean_points_R = mean_time_R/dt;
        %       no_e_R is the number of elements to take in, so it is dividable with number of
        %       "mean_points_R" per specified "level_ice_statistics_days".
        no_e_R = floor(length(t)/mean_points_R)*mean_points_R;
        t_reshape_R = t(1:no_e_R);
        t_reshape_R = reshape(t_reshape_R,mean_points_R,floor(length(t)/mean_points_R));
        
        %       Prelocating an xxx vector to be used for expected maximum ridge calculation
        xxx = 0:0.01:30;
        to_keep = false(1,size(t_reshape_R,2));
        PKS = zeros(5000,100);
        LOCS = zeros(5000,100);
        
        %       looping through weeks
        for n = 1:1:size(t_reshape_R,2)
            % making weekly vectors of relevant variables
            T_R_reshape{n} = T_R(and(T_R>t_reshape_R(1,n),T_R<t_reshape_R(end,n) ));    % time vector for ridges for week "n"
            H_R_reshape{n} = H_R(and(T_R>t_reshape_R(1,n),T_R<t_reshape_R(end,n) ));    % ridge vector for week "n"
            R_no(n) = length(H_R_reshape{n});                                           % number of ridges in week "n"
            R_t(n) = mean(t_reshape_R(:,n));
            Ws(n) = t_reshape_R(1,n);
            We(n) = t_reshape_R(length(t_reshape_R),n);                                          % middle of week time
            
            %       Taking out a subset of raw ULS draft measurement.
            %       Neglecting drafts below a certaing value if necessary (e.g., h>0.2)
            h_SubSet =  h(  (h<3) &(h>0.0) & (t>Ws(n)) & t<We(n) ) ;
            
            
            %       Considering only weeks with number of ridges abouve certain value and if draft
            %       measurement subset is not empty (e.g., if there is a certain minimum value for
            %       draft defined above and it was all below that certain value)
            % if not(isempty(H_R_reshape{n})) &&  not(isempty(h_SubSet))
            if numel(H_R_reshape{n})>5 &&  not(isempty(h_SubSet))
                
                to_keep(n) = 1;
                pd(n) = fitdist(H_R_reshape{n}-h_k_min,'Exponential');   % fit exponential distribution to the ridges
                pd_mean(n) = pd(n).mu;                                   % take out the exp dist parameter (mmu)
                mean_keel_depth(n) = mean(H_R_reshape{n});               % store the mean of all the ridges
                T_R_pd(n) = mean([t_reshape_R(:,n)]);                    % store the time of the exponential distribution estimates
                dmax(n) = max(H_R_reshape{n});                           % deepest weekly ridge
                
                %       calculating the bandwidth parameter of the kernel estimate of the draft PDF
                bw_sigma = std(h_SubSet);
                bw_n = numel(h_SubSet);             
                bw_h(n) = 1*1.06*bw_sigma*bw_n^-0.2;
                
                %       calculating the kernel estimate of the draft PDF
                [f,xi,bw]=ksdensity(h_SubSet(h_SubSet<5),'Bandwidth',bw_h(n),'NumPoints',100 ) ;
                bw_vector(n) = bw;                                      % storing the bandwith parameter
                
                [pks,locs] = findpeaks(f,xi);                           % intensities and locations of all modes
                if not(isempty(max(locs(   (locs<3)&(pks>0.25)    ))))
                    DM(n) = max(locs(   (locs<3)&(pks>0.25)    ));         % deepest mode estimate
                else
                    DM(n) = 0;
                    to_keep(n) = 0;
                end
                PKS(n,1:length(pks)) = pks;
                LOCS(n,1:length(locs)) = locs;
                
                
                
                [pks,locs] = max(f);                                    % intensity and location of the absolute mode
                AM(n) = xi(locs);                                       % absolute mode estimate
                
                Mcdf(n,:) = cdf(pd(n),xxx);                             % CDF of estimated exponential distribution, used later for estimating the expected deepest keel
                
            end
            
        end
        
%         PKS(length(DM)+1:end,:) = [];
%         LOCS(length(DM)+1:end,:) = [];
        
        
        %%      ESTIMATING THE EXPECTED DEEPEST RIDGE
        
        for n = 1:size(Mcdf,1)
            if (sum(Mcdf(n,:))>0) && not(isempty(H_R_reshape{n}))
                [loc val] = intersections(xxx,(1-1/R_no(n))*ones(length(xxx),1),xxx,Mcdf(n,:) );
                HR_100(n) = loc+h_k_min;
            end
        end
        
        if (length(unique([D HR_100(to_keep)]))-length(D))>-20
            LI_DM = [LI_DM DM(to_keep)];                                                            % LI deepest mode estimate
            LI_AM = [LI_AM AM(to_keep)];                                                            % LI absolute mode estimate
            D = [D HR_100(to_keep)];                                                                % expected deepest ridge
            N = [N R_no(to_keep)];                                                                  % number of ridges
            M = [M 5+pd_mean(to_keep)];                                                             % mean keel depth (exp dist parameter)
            WS = [WS Ws(to_keep)];                                                                           % week start timing
            WE = [WE We(to_keep)];                                                                           % week end timing
            ThisYear = [zeros(1,length(LI_DM)-length(DM(to_keep))) ones(1,length(DM(to_keep)))];    % indicating which elemens are from current year/location
            T = [T T_R_pd(to_keep)];                                                                % mean time of weekly keels
            D_all{i} = H_R_reshape(to_keep);                                                        % all individual keel depths
            T_all{i} = T_R_reshape(to_keep);                                                        % all individual keel times
            Dmax = [Dmax dmax(to_keep)];                                                         % weekly deepest ridge
            Year = [Year; (2000+yr)*ones(length(DM(to_keep)),1)];                                   % year of weekly estimates
            Location = [Location; mooring_location*ones(length(DM(to_keep)),1)];                    % location of weekly estimates
            PKSall = [PKSall; PKS(to_keep,:)];
            LOCSall = [LOCSall; LOCS(to_keep,:)];
        end
        
      
        
        % ----------------------------------------------------------------------------------------
        % ----------------------------------------------------------------------------------------
        % ----------------------------------------------------------------------------------------
        % -------------                                                              -------------
        % -------------               PLOTTING THE RESULTS                           -------------
        % -------------                                                              -------------
        % ----------------------------------------------------------------------------------------
        % ----------------------------------------------------------------------------------------
        % ----------------------------------------------------------------------------------------
        
        if plotresults == 1
            %%      h, LI estimate, all ridges, ridge means
            
            myfig(1,1)
            if office_screens==1
                set(gcf,'Position',[2586        1827        1022         199])
            else
                set(gcf,'Position',[10 400 700 200])
            end
            axis([-inf inf 0 30])
            yticks([0:0.5:2 3:5 10:5:30])
            FIG1 = gca;
            reduce_plot(t,h);
            
            if estimate_hourly==1
                stairs(t_LI,h_LI2,'r','LineWidth',2)
            end
            
            scatter(T_R,H_R,'rv','SizeData',10)
            stairs(T_R_pd(to_keep)-3.5,HR_100(to_keep),'k','LineWidth',2)
            stairs(T_R_pd(to_keep)-3.5,DM(to_keep),'k','LineWidth',2)
            
            dynamicDateTicks
            
            %%      Weekly number of ridges
            myfig(2,1)
            FIG2 = gca;
            if office_screens==1
                set(gcf,'Position',[2586        1535        1022         199])
            else
                set(gcf,'Position',[10 100 700 200])
            end
            ylim([0 400])
            yticks([0:25:100 200:100:1000])
            
            stairs(T_R_pd(to_keep)-3.5,R_no(to_keep),'k','LineWidth',2);
            
            dynamicDateTicks
            linkaxes([FIG1,FIG2],'x')
            
            %%
            myfig(33,1)
            if office_screens==1
                set(gcf,'Position',[2930.00         600.00        350.00        240.00])
            else
                set(gcf,'Position',[10 530 300 240])
            end
            caxis([0 1])
            colormap(flipud(othercolor('RdYlBu_11b')))
            axis([0 3 0 30])
            xlabel('LI DM [m]')
            ylabel('Expected deapest ridge during one week')           
            
            delete(CompletePlot3)
            CompletePlot3 = scatter(LI_DM,D,36,ThisYear,'filled','MarkerFaceAlpha',0.4);
            
            %%
            myfig(4,1)
            if office_screens==1
                set(gcf,'Position',[2570.00         250.00        350.00        240.00])
            else
                set(gcf,'Position',[320 530 300 240])
            end
            caxis([0 1])
            colormap(flipud(othercolor('RdYlBu_11b')))
            axis([0 3 5 9])
            xlabel('Level ice thickness [m]')
            ylabel('Mean ridge keel depth [m]')
            
            delete(CompletePlot4)
            CompletePlot4 = scatter(LI_DM,M,36,ThisYear,'filled','MarkerFaceAlpha',0.4);
            
            %%
            myfig(5,1)
            if office_screens==1
                set(gcf,'Position',[2570.00        600.00        350.00        240.00])
            else
                set(gcf,'Position',[630 530 300 240])
            end
            xlim([5 10])
            caxis([0 1])
            colormap(flipud(othercolor('RdYlBu_11b')))
            xlabel('Mean keel depth [m]')
            ylabel('Number of ridges [-]')
            
            delete(CompletePlot5)
            CompletePlot5 = scatter(M,N,36,ThisYear,'filled','MarkerFaceAlpha',0.4);
            
            drawnow
            
            %%
            myfig(6,1)
            if office_screens==1
                set(gcf,'Position',[2930.00        250.00        350.00        240.00])
            else
                set(gcf,'Position',[630 530 300 240])
            end
            xlim([0 3])
            caxis([0 1])
            colormap(flipud(othercolor('RdYlBu_11b')))
            xlabel('LI DM [m]')
            ylabel('Number of ridges [-]')
            
            delete(CompletePlot6)
            CompletePlot6 = scatter(LI_DM,N,36,ThisYear,'filled','MarkerFaceAlpha',0.4);
            
            drawnow
            
            %%
            myfig(7,1)
            if office_screens==1
                set(gcf,'Position',[3286.00        600.00        350.00        240.00])
            else
                set(gcf,'Position',[630 530 300 240])
            end
            xlim([0 3])
            ylim([0 30])
            caxis([0 1])
            colormap(flipud(othercolor('RdYlBu_11b')))
            xlabel('LI DM [m]')
            ylabel('Weekly deepest ridge [-]')
            
            delete(CompletePlot7)
            CompletePlot7 = scatter(LI_DM,Dmax,36,ThisYear,'filled','MarkerFaceAlpha',0.4);
            
            drawnow
            
            %%
            myfig(8,1)
            if office_screens==1
                set(gcf,'Position',[3286.00        250.00        350.00        240.00])
            else
                set(gcf,'Position',[630 530 300 240])
            end
            xlim([0 30])
            ylim([0 30])
            caxis([0 1])
            xticks([0:10:30])
            yticks([0:10:30])
            pbaspect([1 1 1])
            colormap(flipud(othercolor('RdYlBu_11b')))
            xlabel('Expected deepest keel')
            ylabel('Deepest keel')
            plot([0 30],[0 30],'color',[0.7 0.7 0.7]);
            
            delete(CompletePlot8)
            CompletePlot8 = scatter(D,Dmax,36,ThisYear,'filled','MarkerFaceAlpha',0.4);
            
            drawnow
        end
        TocTime = toc;
        fprintf('Time     : %.0f min %.0f s \n',floor(TocTime/60),TocTime-floor(TocTime/60)*60)
        TimeLeft = TocTime/i*(SetsNum-i);
        fprintf('Time left: %.0f min %.0f s \n',floor(TimeLeft/60),TimeLeft-floor(TimeLeft/60)*60)
    end
end

%%
save('results015.mat','LI_DM','LI_AM','D','N','M','WS',...
            'WE','ThisYear','T','D_all','T_all','Dmax','Year',...
            'Location','PKSall','LOCSall','YR','LC','ID')





