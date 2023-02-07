% --- WORK IN PROGRESS ---

% This script is made for testing various distributions for the ratio M/M_regression

% load the color matrix
load('co.mat')

% initialization of the figure
myfig(11,1)
subplot(5,3,7:12); hold on; grid on; box on
set(gca,'yscale','log')
axis([5 45 1E-6 1 ])

% define the distributions to be tested
clear dist
dist{1} = 'normal';
dist{2} = 'lognormal';
dist{3} = 'gamma';
dist{4} = 'logistic';
dist{5} = 'generalized extreme value';
dist{6} = 't location scale';

load('distributions.mat')
load('R_set.mat')

nnn = 0;
for i = 1:1
    
    pd = fitdist(R',dist{i});
    
    clear DEVELOPE_max
    clear DENVELOPE_min
    
    xi = [(200000:-1:1)/200000]';
    
    nS = 50;
    YI = zeros(200000,nS);
    % for n = 1:nS
    for n = 1:nS
        Msimulated = (b+LI_M_VS*a).*random(pd_h2m,size(LI_M_VS));
%         Nsimulated = (a1*abs(Msimulated-5).^b1).*random(pdN,size(LI_M));
        
        R_h2n_s = random(pd_h2n,size(LI_M_VS));
        Nsimulated = 84.69*LI_M_VS'.^1.318.*R_h2n_s';
        Nsimulated = round(Nsimulated);
        %         nnn = nnn+Nsimulated;
        
        DAllSimulated = nan(250000,1);
        DAllSimulated = 5+exprnd(abs(Msimulated(1)-5),round(Nsimulated(1)),1);
        for nn = 2:numel(Msimulated)
            i1 = sum(Nsimulated(1:nn-1))+1;
            i2 = sum(Nsimulated(1:nn));
            DAllSimulated(i1:i2) =  (5+exprnd(abs(Msimulated(nn)-5),round(Nsimulated(nn)),1));
        end
        
        DAllSimulated(isnan(DAllSimulated)) = [];
        
        
        
        
        disp(['Step: ' , num2str(n), '/' num2str(nS)])
        
        x = [(numel(DAllSimulated):-1:1)/numel(DAllSimulated)]';
        DAllSimulated_sorted = sort(DAllSimulated);
        yi = interp1(x,DAllSimulated_sorted,xi);
        
        YI(:,n) = yi;
%         set(gca,'yscale','log')
        %     plot(yi,xi)
        
   
    end
    
    
    %%
    
    subplot(5,3,i); hold on; grid on; box on
    title(dist{i})
    set(gca,'yscale','log')
    axis([5 45 1E-6 1 ])
    
    MM = mean(YI,2);
    STD = std(YI,[],2);
    
    LL = prctile(YI,5,2);
    UL = prctile(YI,95,2);
    ML = prctile(YI,50,2);
    
    plot(UL,xi,'b-')
    plot(LL,xi,'b-')
    plot(ML,xi,'k-')
    
    epa = epp(DAll);
    epa.MarkerEdgeColor = 'r';
    
    subplot(5,3,7:12);
    plot(UL,xi,'-','Color',co(i,:))
    plot(LL,xi,'-','Color',co(i,:))
    
    drawnow
    
end


epa = epp(DAll);
epa.MarkerEdgeColor = 'r';

distl{1} = 'normal';
distl{2} = 'normal';
distl{3} = 'lognormal';
distl{4} = 'lognormal';
distl{5} = 'gamma';
distl{6} = 'gamma';
distl{7} = 'logistic';
distl{8} = 'logistic';
distl{9} = 'generalized extreme value';
distl{10} = 'generalized extreme value';
distl{11} = 't location scale';
distl{12} = 't location scale';
legend(distl)

