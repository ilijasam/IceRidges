% --- WORK IN PROGRESS ---

% !! Scripts is made for checking the minimum mode intensity treshold
% Once the figure is made, use arrows up and down to adjust the threshold

clear all

load('results1','LI_DM','LI_AM','Dmax','N','LOCSall','PKSall')

myfig(1,1)

fig = figure(1);
fig.Position = [275   168   916   675];

LI_DM(N<15) = [];
LI_AM(N<15) = [];
Dmax(N<15) = [];
LOCSall(N<15,:) = [];
PKSall(N<15,:) = [];

%%

subplot(2,2,1); hold on; grid on;
scatter(LI_AM,Dmax,'k+','sizedata',10)
x = 0:0.0001:3;
plot(x,20*sqrt(x),'k--','LineWidth',2)
plot(x,7.55+4.83*x,'k','LineWidth',2)
xlabel('Level ice thickness according to AM [m]')
ylabel('Weekly maximum ridge keel draft [m]')

subplot(2,2,2); hold on; grid on;
S = scatter(LI_DM,Dmax,'k+','sizedata',10);
plot(x,20*sqrt(x),'k--','LineWidth',2)
plot(x,7.55+4.83*x,'k','LineWidth',2)
xlabel('Level ice thickness according to DM [m]')
ylabel('Weekly maximum ridge keel draft [m]')
title('Threshold as used in S003')

subplot(2,2,4); hold on; grid on;
S = scatter(LI_DM,Dmax,'k+','sizedata',10);
plot(x,20*sqrt(x),'k--','LineWidth',2)
plot(x,7.55+4.83*x,'k','LineWidth',2)
xlabel('Level ice thickness according to DM [m]')
ylabel('Weekly maximum ridge keel draft [m]')

%% Looping through different threshold
br = 0;
Dt = zeros(size(Dmax));
i = 0.2;
while not(br==27)

    LOCSallT = LOCSall;
    LOCSallT(or(  (LOCSallT(:,:)>3) , (PKSall(:,:)<i)    )) = NaN;
    Dt = max(LOCSallT,[],2);
    
    S.XData = Dt;
    title(['Min mode intensity threshold = ',string(i)])
    
    w = waitforbuttonpress;
    br = double(get(gcf,'CurrentCharacter'));
    if br == 31
        i = max(0,i-0.01);
    elseif br == 30
        i = min(0.4,i+0.01);
    end
    drawnow
end



