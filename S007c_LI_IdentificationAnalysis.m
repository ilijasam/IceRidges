% This script makes a plot of level ice evloution for multiple seasons.

office_screens = 0;
myfig(9,1); grid on; box on;
cf = gcf;
set(cf,'WindowState','maximized');

level_ice_time = 1;             %   duration of sample for LI estimate (in hours)
level_ice_statistics_days = 7;  %   duration of sample of estimated LI for LI statistics (in days)

MatFilesFolder = 'c:\Users\ilijas\OneDrive - NTNU\PhD\IceRidges\MAT files';

% defining strings abcd for corresponding 1234 locations

Location_vector = ['a';'b';'c';'d'];

% defining which years to be analysed for 4 different locations
loc_yrs{1} = [03:08 10:15 16 17];
loc_yrs{2} = [03 04 06 08 10 12 13 15 16 17];
loc_yrs{3} = [03 04 05 07];
loc_yrs{4} = [06 07 08 10 12 13 14 16 17];

SP = 0;
for mooring_location = 2
    loc_mooring = Location_vector(mooring_location,1);
    for yr = loc_yrs{mooring_location}
        SP = SP+1;
        %     for yr = 17
        load([MatFilesFolder,'\uls', sprintf('%02d',yr) ,loc_mooring,'_draft.mat'])
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
        HistBins = [-0.1:0.1:8];

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


        subaxis(4,1,ceil((loc_yrs{mooring_location}(SP)-2)/4),'S',0.05,'M',0.05); hold on; grid on; box on;

        axis([-inf inf 0 3])
        C = max(max(HHi));
        clim([0 C/2/169]);

        [X,Y] = meshgrid(t_hist,hh-0.00);
        surf(X,Y,HHi'/169)
        shading interp
        colormap(othercolor('BuOr_10'))
        dynamicDateTicks()
        xl = xlim
        xlim([xl(1) max(X(:))])
        P3 = plot3(t_LI_TEMP,  h_LI_DM,50*ones(1,length(h_LI_DM)),'color',[0.2 0.2 0.2],'Marker','square','MarkerSize',6,'LineStyle','none');
        P3 = plot3(t_LI_TEMP,  h_LI_AM,50*ones(1,length(h_LI_DM)),'color',[0.2 0.2 0.2],'Marker','x','MarkerSize',4,'LineStyle','none');
        drawnow
    end
end


%%
subaxis(4,1,1,'S',0.05,'M',0.05); hold on; grid on; box on;
xlim([datenum('01-Aug-2003') datenum('01-Aug-2007')])
subaxis(4,1,2,'S',0.05,'M',0.05); hold on; grid on; box on;
xlim([datenum('01-Aug-2007') datenum('01-Aug-2011')])
subaxis(4,1,3,'S',0.05,'M',0.05); hold on; grid on; box on;
xlim([datenum('01-Aug-2011') datenum('01-Aug-2015')])
subaxis(4,1,4,'S',0.05,'M',0.05); hold on; grid on; box on;
xlim([datenum('01-Aug-2015') datenum('01-Aug-2019')])


