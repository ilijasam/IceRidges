% This script makes various plots for analysis of the results
% Some simulation attempts are also performed here. Note that not all simulations presented here are in accordance with
% the methodology in Samardžija & Høyland (2023), but rather a trial-and-error attempts. More specific, here I was
% attempting to make a correlation between the mean ridge keel draft and the number of ridges, while in the paper we use
% corelation between level ice thickness and number of ridges to simulate the number of ridges.

myfig(11,1)
set(gcf,'Units','normalized')
set(gcf,'Position',[0         0         0.5        1])

load('Results\results1.mat')
load('Results\ManualCorrection_3.mat')
addpath('Supporting Files\')

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
subplot(6,3,1); cla; hold on; grid on; box on
axis([0 3 5 9])
xlabel('LI DM [m]')
ylabel('Mean ridge keel depth [m]')
title('Data')
scatter(LI_DM,M,'filled','MarkerFaceAlpha',0.4);

x = LI_DM';
y = M';
X = [ones(length(x),1) x];
b = X\y;
xx = 0:3;
plot(xx,b(1)+b(2)*xx)

%%
subplot(6,3,2); cla; hold on; grid on; box on
xlabel('M/regression [-]')
ylabel('Probability distribution [-]')
R1 = M./(b(1)+b(2)*LI_DM);
histogram(R1,0.79:0.02:1.2,'Normalization','pdf')
pd1 = fitdist(R1','normal');
plot(0.8:0.01:1.2,pdf(pd1,0.8:0.01:1.2))

%%
subplot(6,3,3); cla; hold on; grid on; box on
axis([0 3 5 9])
xlabel('LI DM [m]')
ylabel('Mean ridge keel depth [m]')
title('Simulation')
Ms = (b(1)+b(2)*LI_DM).*random(pd1,1,numel(M));
scatter(LI_DM,Ms,'filled','MarkerFaceAlpha',0.4);
plot(xx,b(1)+b(2)*xx)



%% --------------------------------------------------------------------
subplot(6,3,4); cla; hold on; grid on; box on
axis([0 5 5 1200])
xlabel('LI DM [m]')
ylabel('Mean ridge keel depth [m]')
title('Data')
scatter(LI_DM,N,'filled','MarkerFaceAlpha',0.4);

xx = 0:0.001:3;
plot(xx,84.69*xx.^1.318)


%%
subplot(6,3,5); cla; hold on; grid on; box on
axis([0 3 0 5])
xlabel('M/regression [-]')
ylabel('Probability distribution [-]')
R2 = N(LI_DM>0)./(91.74*LI_DM(LI_DM>0).^1.048);
scatter(LI_DM(LI_DM>0),R2,'filled','MarkerFaceAlpha',0.2)
pd2 = fitdist(R2','normal');

%% --------------------------------------------------------------------
subplot(6,3,7); cla; hold on; grid on; box on
axis([0 5 5 1200])
xlabel('M-5 [m]')
ylabel('Number of ridges [m]')
title('Data')
scatter(M-5,N,'filled','MarkerFaceAlpha',0.4);

xx = 0:0.001:5;
a = [38.78 2.047];
plot(xx,a(1)*xx.^a(2));

%%
subplot(6,3,8); cla; hold on; grid on; box on
axis([0 3 0 1])
xlabel('N/regression [-]')
ylabel('Probability distribution [-]')
R2 = N./(a(1)*(M-5).^a(2));
histogram(R2,0:0.2:3,'Normalization','pdf')
pd2 = fitdist(R2','nakagami');
% pd2 = fitdist(R2','rayleigh');
plot(0:0.01:3,pdf(pd2,0:0.01:3))

%%
subplot(6,3,9); cla; hold on; grid on; box on
axis([0 5 0 1200])
xlabel('M-5 [m]')
ylabel('Number of ridges [m]')
title('Simulation')
Ns = a(1)*(M-5).^a(2).*random(pd2,1,numel(M));
scatter((M-5),Ns,'filled','MarkerFaceAlpha',0.4);
plot(xx,a(1)*xx.^a(2))

%%
subplot(6,3,10); cla; hold on; grid on; box on
xlabel('N / regression [-]')
ylabel('Exceedence probability [-]')
epp(R2)
plot(0:0.01:3,1-cdf(pd2,0:0.01:3))

%%
subplot(6,3,11); cla; hold on; grid on; box on
axis([0 4 0 5])
xlabel('M - 5')
ylabel('N / regression [-]')
scatter(M-5,R2,'filled','MarkerFaceAlpha',0.2)


%%
subplot(6,3,12); cla; hold on; grid on; box on
xlabel('LI DM [m]')
ylabel('Number of ridges [m]')
axis([0 5 0 1200])
title('Simulation')
scatter(LI_DM,Ns,'filled','MarkerFaceAlpha',0.4);

%%
subplot(6,3,13); cla; hold on; grid on; box on
xlim([0 40])
xlabel('Keel depth [m]')
ylabel('Exceedence probability []')
DALL = [];
Dmaxs = [];

Mss = (b(1)+b(2)*LI_DM).*random(pd1,1,numel(M));
Nss = a(1)*(Mss-5).^a(2).*random(pd2,1,numel(Mss));


for n = 1:length(D_all)
    DALL = [DALL; cell2mat(D_all{n}')];
end
epp(DALL)

DALLs = [];
for n = 1:length(Mss)
    DW = 5+exprnd(Mss(n)-5,ceil(Nss(n)),1);
    DALLs = [DALLs; DW];
    Dmaxs = [Dmaxs max(DW)];
end
epp(DALLs)

%%
subplot(6,3,14); cla; hold on; grid on; box on
set(gca,'YScale','log')
xlabel('Keel depth [m]')
ylabel('Probability density [-]')
histogram(DALL,0:1:30,'Normalization','pdf')
histogram(DALLs,0:1:30,'Normalization','pdf')

%%
subplot(6,3,16); cla; hold on; grid on; box on
axis([0 3 5 40])
title('Data')
xlabel('LI DM [m]')
ylabel('Weekly deepest keel depth [m]')
scatter(LI_DM,Dmax,'filled','MarkerFaceAlpha',0.4);

x = LI_DM';
y = Dmax';
X = [ones(length(x),1) x];
bb = X\y;
xx = 0:3;
plot(xx,bb(1)+bb(2)*xx)

%%
subplot(6,3,17); cla; hold on; grid on; box on
axis([0 3 5 40])
title('Simulation')
xlabel('LI DM [m]')
ylabel('Weekly deepest keel depth [m]')
scatter(LI_DM,Dmaxs,'filled','MarkerFaceAlpha',0.4);
plot(xx,bb(1)+bb(2)*xx)

x = LI_DM';
y = Dmaxs';
X = [ones(length(x),1) x];
bb = X\y;
xx = 0:3;
plot(xx,bb(1)+bb(2)*xx)

%%
subplot(6,3,18); cla; hold on; grid on; box on
set(gca,'YScale','linear')
pbaspect([1 1 1])
title('Weekly deepest keel depth')
xlabel('data')
ylabel('simulated')
axis([0 35 0 35])
yticks([0 10 20 30])
scatter(Dmax,Dmaxs,'filled','MarkerFaceAlpha',0.4);
plot([0 35],[0 35])
