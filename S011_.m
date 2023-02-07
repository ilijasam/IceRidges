% clean simulation of all ridge keels
clear all
close all
clc

office_screens = 1;

%% loading and trimming the data 
load('results1.mat')
load('ManualCorrection_3.mat')
load('distributions.mat')

Ntreashold = 15;
LI_DM(N<Ntreashold) = [];
Dmax(N<Ntreashold) = [];
M(N<Ntreashold) = [];
N(N<Ntreashold) = [];
T(N<Ntreashold) = [];


LI_DM = LI_DM(not(to_delete));
LI_M = LI_M(not(to_delete));
Dmax = Dmax(not(to_delete));
M = M(not(to_delete));
N = N(not(to_delete));
T = T(not(to_delete));

DAll = [];
for n = 1:37
    for nn = 1:numel(D_all{n})
        DAll = [DAll; D_all{n}{nn}];
    end
end

%%
% figure for tracking steps of calculations on subplots
myfig(2,1); clf;
if office_screens == 1
    set(gcf,'Position',[2561         249        1080        1803])
end


subplot(6,3,1); hold on; box on; grid on; axis([0 3 5 9]); title('1.')
xlabel('Level ice draft [m]')
ylabel('Weekly mean keel draft [m]')
scatter(LI_M, M,'filled','MarkerFaceAlpha',0.2,'SizeData',20)
[p,a,b] = linreg(LI_M,M,1);
p.Color = 'k';


% % N weights
% a = 0.5869;
% b = 5.984;
% 
% % LAR
% a = 0.5217;
% b = 8.5;


subplot(6,3,2); hold on; box on; grid on; title('2')
xlabel('Level ice draft [m]')
ylabel('Normalized weekly mean keel draft [-]')
R = M./(b+LI_M*a);
scatter(LI_M, R,'filled','MarkerFaceAlpha',0.2,'SizeData',20)

subplot(6,3,3); hold on; box on; grid on; axis([0.8 1.2 0 10]); title('3.')
xlabel('Normalized weekly deepest keel draft [-]')
ylabel('Probability density [-]')
H = histogram(R,0.8:0.01:1.2,'Normalization','pdf')
% pd = fitdist(R','t location scale');                                    % Mean draft ratio
pd = fitdist(R','normal' );                                       
x = 0:0.001:2;
y = pdf(pd,x);
plot(x,y,'k')
legend('Hist.','PDF')

subplot(6,3,4); hold on; box on; grid on; axis([5 9 0 1200]); title('4.')
xlabel('Weekly mean keel draft [m]')
ylabel('Weekly number of ridges [-]')
scatter(M, N,'filled','MarkerFaceAlpha',0.2,'SizeData',20)

a1 = 37.21;
b1 = 2.16;
x = 5:0.001:9;
y = a1*(x-5).^b1;

% a = 6.885e-05;
% b = 7.535;
% x = 5:0.001:9;
% y = a*x.^b;

plot(x,y,'k')

subplot(6,3,5); hold on; box on; grid on;  title('5.')
axis([5 9 0 4])
xlabel('Weekly mean keel draft [m]')
ylabel('Normalized weekly number of ridges [-]')
RN = N./(a1*(M-5).^b1+1);
% RN = N./(a*(M).^b);
scatter(M, RN,'filled','MarkerFaceAlpha',0.2,'SizeData',20)

subplot(6,3,6); hold on; box on; grid on; axis([0 4 0 1]); title('6.')
histogram(RN,0:0.18:4,'Normalization','pdf')
pdN = fitdist(RN','Weibull');                                              % ridge number ratio
x = 0:0.001:4;
y = pdf(pdN,x);
plot(x,y,'k')

%%
subplot(6,3,7); cla; hold on; box on; grid on; axis([0 3 5 9]);
Msimulated = (b+LI_M*a).*random(pd,size(LI_M));
xlabel('Level ice draft [m]')
ylabel('Weekly mean keel draft [m]')
title('7. SIMULATED')
scatter(LI_M, Msimulated,'filled','MarkerFaceAlpha',0.2,'SizeData',20)
xRN = 0:3;
yRN = b+xRN*a;
plot(xRN,yRN,'k')

subplot(6,3,10); cla; hold on; box on; grid on; title('10.')
qqplot(M,Msimulated)
title('Weekly mean keel draft')
xlabel('Data')
ylabel('Simulated')

subplot(6,3,8); cla; hold on; box on; grid on; axis([5 9 0 1200]);
Nsimulated = (a1*(Msimulated-5).^b1).*random(pdN,size(LI_M));
xlabel('Weekly mean keel draft [m]')
ylabel('Weekly number of ridges [-]')
title('8. SIMULATED')
scatter(Msimulated, Nsimulated,'filled','MarkerFaceAlpha',0.2,'SizeData',20)
x = 5:0.001:9;
y = a1*(x-5).^b1;
plot(x,y,'k')

subplot(6,3,11); cla; hold on; box on; grid on;
qqplot(N,Nsimulated)
title('11. Weekly number of ridges')
xlabel('Data')
ylabel('Simulated')
%%

DAllSimulated = [];
MAllSimulated = [];
NAllSimulated = [];

MALL = [];
NALL = [];
Dsimsim = [];
nS = 100;
disp('Starting simulation...')
Dsimsim = nan(nS*200000,1);
ii = 0;
tic
for n = 1:nS
    Msimulated = (b+LI_M*a).*random(pd,size(LI_M));
%     Nsimulated = (a1*(Msimulated-5).^b1).*random(pdN,size(LI_M));
    %         MAllSimulated = [MAllSimulated Msimulated];
    %         NAllSimulated = [NAllSimulated Nsimulated];
    
    R_h2n_s = random(pd_h2n,size(LI_M));
    Nsimulated = 84.69*LI_M'.^1.318.*R_h2n_s';
    Nsimulated = round(Nsimulated);
    
    DAllSimulated = nan(250000,1);
    i=0;
    for nn = 1:numel(Msimulated)
%         DAllSimulated = [DAllSimulated; 5+exprnd(Msimulated(nn)-5,round(Nsimulated(nn)),1)];
        dsima = 5+exprnd(Msimulated(nn)-5,Nsimulated(nn),1);
        DAllSimulated(i+1:i+numel(dsima)) =dsima;
        i = i+numel(dsima);
        %         MALL = [MALL; ones(round(Nsimulated(n)),1)*Msimulated(n)];
        %         NALL = [NALL; ones(round(Nsimulated(n)),1)*round(Nsimulated(n))];
    end
    DAllSimulated(isnan(DAllSimulated)) = [];
    
    
    Dsimsim(ii+1:ii+numel(DAllSimulated)) = DAllSimulated;
    ii = ii + numel(DAllSimulated);
%     Dsimsim = [Dsimsim; DAllSimulated];
%     disp(['Step: ' , num2str(n), '/' num2str(nS)])
    
     if mod(n,10)==0
        tt = toc/n*(nS-n);
%         fprintf('Step: %.0d / %.0d | %s \n',n,nS,toc,datestr(seconds(121.6),'MM:SS '))
        fprintf('Step: %.0d / %.0d | TP: %s TL: %s \n',n,nS,datestr(seconds(toc),'MM:SS '),datestr(seconds(tt),'MM:SS '))
        
    end
end
Dsimsim(isnan(Dsimsim)) = [];
disp('Simulation done!')

%%

subplot(6,3,9); cla; hold on; box on; grid on; 
axis([0 40 0.000001 1])
epp(DAll);
epp(Dsimsim);

subplot(6,3,12); cla; hold on; box on; grid on;
qqplot(DAll,Dsimsim)
title('12. All ridges')
xlabel('Data')
ylabel('Simulated')

subplot(6,3,10); cla; hold on; box on; grid on;
qqplot(M,Msimulated)
title('10. Weekly mean keel draft')
xlabel('Data')
ylabel('Simulated')

subplot(6,3,11); cla; hold on; box on; grid on;
qqplot(N,Nsimulated)
title('11. Weekly number of ridges')
xlabel('Data')
ylabel('Simulated')

subplot(6,3,13); cla; hold on; box on; grid on;  title('13. SIMULATED'); axis([5 9 0 4])
xlabel('Weekly mean keel draft [m]')
ylabel('Normalized weekly number of ridges [-]')
RNsimulated = Nsimulated./(a1*(Msimulated'-5).^b1+1);
% RN = N./(a*(M).^b);
scatter(Msimulated, RNsimulated,'filled','MarkerFaceAlpha',0.2,'SizeData',20)


%%



subplot(6,3,[14:15 17:18]); cla; hold on; box on; grid on; 
histogram(DAll,5:0.5:40,'Normalization','pdf')
histogram(DAllSimulated,5:0.5:40,'Normalization','pdf')
set(gca,'yscale','log')


[h,p] = kstest2(DAll,DAllSimulated)


        























