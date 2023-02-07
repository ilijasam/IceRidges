%%
% This script is calculating the "running level ice (LI) statistics".

% First, it estimates the level ice from the signal by calulating the mode. This is done by taking samples with duration of "level_ice_time".
% Then, with this estimated LI, we do the statistics every "level_ice_statistics_time" days.
% Final plot shows the histograms throughout the year. It is in a way the yearly level ice statistics.

% This script is for producing a figure of the JP1 where two seasons are illustrated. One season is
% purely FYI and the second season has MYI.

clear all
close all
clc

addpath('..\Supporting Files\')
MatFilesFolder = 'c:\Users\ilijas\OneDrive - NTNU\PhD\IceRidges\MAT files';

myfig(16,1)
for yr = 12:13
    keep MatFilesFolder yr 

    office_screens = 1;
    mooring_location = 'b';

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


                %             MLine.XData = [ones(2,1)*h_LI_DM(end)];
                t_LI_TEMP = [t_LI_TEMP; mean(t_LI(n:n+period))];


                ws = [ws; t_LI(n)];
                we = [we; t_LI(n+period)];
            end

        end

        %     drawnow
    end
    hh = HistBins(1:end-1)+diff(HistBins)/2;

    clear HistBins n i
    %%

    myfig(16,0); grid on; box on;
    cf = gcf;
    ca = gca;
    ca.FontSize = 7;
    ca.Position = [0.0500    0.3    0.92    0.65];
    set(gcf, 'Units', 'centimeters', 'Position', [70, 10, 16, 6], 'PaperUnits', 'centimeters', 'PaperSize', [29.7, 21])
    set(gca,'fontname','times new roman')

    xlabel('Time [months]','FontSize',10)
    ylabel('Level ice draft [m]','FontSize',10)

    axis([-inf inf 0 3])
    C = max(max(HHi));
    caxis([0 C/2/169])
    caxis([0 0.4])
    [X,Y] = meshgrid(t_hist,hh-0.00);

    xx = t_hist(1):mean(diff(t_hist))/4:t_hist(end);
    yy = hh(1):mean(diff(hh))/4:hh(end);
    [XX,YY] = meshgrid(xx,yy-0.00);
    Vq = interp2(X,Y,HHi'/169,XX,YY);
    surf(XX,YY,Vq)

    shading interp
    colormap(othercolor('BuOr_10'))
    alpha 0.8
    c = colorbar;
    c.Label.String = 'Frequency [%]';
    c.TickLabels = {'0' '25' '50' '75' '100'};
    c.Location = 'southoutside';
    c.Position = [0.65    0.15    0.3    0.03];
    c.FontSize = 8;
    dynamicDateTicks()

    xlim([min(X(:))-365 max(X(:))])

    P3 = plot3(t_LI_TEMP,  h_LI_DM,50*ones(1,length(h_LI_DM)),'color','k','Marker','square','MarkerSize',6,'LineStyle','none');
    P4 = plot3(t_LI_TEMP,  h_LI_AM,50*ones(1,length(h_LI_DM)),'color','k','Marker','x','MarkerSize',6,'LineStyle','none');

    P3.MarkerSize =4;
    P4.MarkerSize = 4;


end

L = legend([P4 P3],'AM','DM');
L.FontSize = 8;

%%
if exist('Q1')
    delete(Q1)
    delete(Q2)
    delete(Q3)
    delete(Q4)
end

x = [735261.5 735261.5];
y = 2.37229549042507-0.1-[0.8*0.5 0];
ca = gca;
AX=axis(gca); %can use this to get all the current axes
Xrange=AX(2)-AX(1);
Yrange=AX(4)-AX(3);
X=(x-AX(1))/Xrange*ca.Position(3) +ca.Position(1);
Y=(y-AX(3))/Yrange*ca.Position(4) +ca.Position(2);
Q1 = annotation('textarrow', X, Y,'String' , 'E4 ','Fontsize',8,'FontWeight','bold','HeadLength',6,'HeadWidth',6);

x = [735240.5 735240.5];
y = 0.772105947416993+0.1+[0.8*0.5 0];
ca = gca;
AX=axis(gca); %can use this to get all the current axes
Xrange=AX(2)-AX(1);
Yrange=AX(4)-AX(3);
X=(x-AX(1))/Xrange*ca.Position(3) +ca.Position(1);
Y=(y-AX(3))/Yrange*ca.Position(4) +ca.Position(2);
Q2 = annotation('textarrow', X, Y,'String' , 'E1 ','Fontsize',8,'FontWeight','bold','HeadLength',6,'HeadWidth',6);

x = [735492.5 735492.5];
y = 0.801067446334719+0.1+[0.8*0.5 0];
ca = gca;
AX=axis(gca); %can use this to get all the current axes
Xrange=AX(2)-AX(1);
Yrange=AX(4)-AX(3);
X=(x-AX(1))/Xrange*ca.Position(3) +ca.Position(1);
Y=(y-AX(3))/Yrange*ca.Position(4) +ca.Position(2);
Q3 = annotation('textarrow', X, Y,'String' , 'E2 ','Fontsize',8,'FontWeight','bold','HeadLength',6,'HeadWidth',6);

x = [735548.5 735548.5];
y = 0.991556990167737+0.1+[0.8*0.5 0];
ca = gca;
AX=axis(gca); %can use this to get all the current axes
Xrange=AX(2)-AX(1);
Yrange=AX(4)-AX(3);
X=(x-AX(1))/Xrange*ca.Position(3) +ca.Position(1);
Y=(y-AX(3))/Yrange*ca.Position(4) +ca.Position(2);
Q4 = annotation('textarrow', X, Y,'String' , 'E3 ','Fontsize',8,'FontWeight','bold','HeadLength',6,'HeadWidth',6);

f = figure(16);
f.Renderer = 'painters';
