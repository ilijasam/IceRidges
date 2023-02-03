%% This function loads my personal preferences for MATLAB FIGURES
% Created by: IS, 02.03.2023

function fig = myfig(num,c)
pause(0.1)
    fig = figure(num);
    if c == 1
        clf
    end
    set(gcf,'color','w')
    hold on
    grid on
    box on
end