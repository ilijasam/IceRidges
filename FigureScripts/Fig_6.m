clear all
addpath('..\Supporting Files\')
load('co.mat')
MatFilesFolder = 'c:\Users\ilijas\OneDrive - NTNU\PhD\IceRidges\MAT files';
load([MatFilesFolder,'\uls', sprintf('%02d',12) ,'b_draft.mat'])

t = Data.dateNUM;
h = Data.draft;

ax = gca;

ax.XLim

dateLim.start = 735300;
dateLim.stop =  735320;

dateLim.start = datenum('20-Dec-2012');
dateLim.stop =  dateLim.start+7;

[c index] = min(abs(t-dateLim.start));
dateLim.startI = index;
[c index] = min(abs(t-dateLim.stop));
dateLim.stopI = index;

clear c index

t_sample = t(dateLim.startI:dateLim.stopI);
h_sample = h(dateLim.startI:dateLim.stopI);


%%

myfig(1,1)

dateLim3.start = datenum('25-Dec-2012 00:00:00');
dateLim3.stop =  datenum('26-Dec-2012 00:00:00');
[c index] = min(abs(t-dateLim3.start));
dateLim3.startI = index;
[c index] = min(abs(t-dateLim3.stop));
dateLim3.stopI = index;


FIG = figure(1);
FIG.Position = [2737.00        728.00        784.00        400.00];

sp1 = subplot(2,3,1:2);
% grid on
box on
hold on
xlabel('Time [days]','FontSize',12)
ylabel('Draft [m]','FontSize',12)
ylim([0 5])
yticks(0:1:15)
sp1.FontName = 'Times New Roman';

p = patch([t(dateLim3.startI) t(dateLim3.stopI) t(dateLim3.stopI) t(dateLim3.startI)],[0 0 5 5],'r','FaceAlpha',0.3,'EdgeColor','none');

D = plot(t_sample,h_sample,'k');

dynamicDateTicks(sp1, 'link', 'dd/mm')

xlim([dateLim.start dateLim.stop])

sp2 = subplot(2,3,3);
hold on
box on
xlim([0 3])
xticks([0:0.5:3])
ylim([0 4])
xlabel('Draft [m]','FontSize',12)
ylabel('Probability mass [-]','FontSize',12)
sp2.FontName = 'Times New Roman';
% H = histogram(h_sample,0:0.1:4,'Normalization','pdf');
% H.FaceColor = 'k';
txt1 = text(1,2.4,{'AM', 'DM'},'FontName','times new roman','FontSize',10,'FontWeight','bold');
txt1.Position = [0.85 3 0];


bw_sigma = std(h_sample);
bw_n = numel(h_sample);
bw_h = 1.06*bw_sigma*bw_n^-0.2;

[f,xi,bw]=ksdensity(h_sample,0:0.01:4,'Bandwidth',bw_h) ;

plot(xi,f,'Color', 'r', 'LineWidth',2)
H = histogram(h_sample,0.05:0.1:4,'Normalization','pdf');
H.FaceColor = 'k';
H.FaceAlpha = 0.3;
legend('PDF','Hist.')

[fmax imax] = max(f);
h_LI = xi(imax);
LI = plot(sp1,sp1.XLim,[h_LI h_LI],'Color', 'r', 'LineWidth',2);

LEG = legend(sp1,[D LI],'Ice draft','AM & DM','Location','northwest' );

[c index] = max(H.BinCounts);
h_LI_mode = mean([H.BinEdges(index) H.BinEdges(index+1)]);

pause(0.2)
sp1.Position = sp1.Position-sp1.Position.*[0 1 0 1]+ sp2.Position.*[0 1 0 1];



%%

sp3 = subplot(2,3,4:6);
box on
hold on
xlabel('Time [hours]','FontSize',12)
ylabel('Draft [m]','FontSize',12)
ylim([0 5])
yticks(0:1:15)
sp3.FontName = 'Times New Roman';

clear c index

t_sample = t(dateLim3.startI:dateLim3.stopI);
h_sample = h(dateLim3.startI:dateLim3.stopI);

plot(t_sample,h_sample,'k')

dynamicDateTicks
plot(sp3,sp3.XLim,[h_LI h_LI],'Color', 'r', 'LineWidth',2);

LEG = legend(sp3,'Ice draft','AM & DM');
xlim([dateLim3.start dateLim3.stop ])



