%% This script shows an example for usage of RC.m script
% RC.m script is running the Rayleigh criteria for finding individual ridges
MatFilesFolder = 'c:\Users\ilijas\OneDrive - NTNU\PhD\IceRidges\MAT files';

load([MatFilesFolder,'\uls17a_draft.mat'])

h_tres = 2.5;       % Rayleigh criteria parameter
h_k_min = 5;        % Rayleigh criteria parameter

h = Data.draft;     % Draft variable
t = Data.dateNUM;   % Time variable

 % there were some errors in time steps for some years, I need it equidistant in order for some routines to work
dt1 = mean(diff(t));
if not(min(diff(t))>0)
    t = [t(1):dt1:t(end)]';
end

[T_R,H_R] = RC(t,h,h_tres,h_k_min); % Running the RC.m script for findig the individual ridges with Rayleigh criteria

%% Plotting the draft signal and individual ridge peaks

FIG = myfig(1,1);
reduce_plot(t, h)
scatter(T_R,H_R)

ylim([0 25])
dynamicDateTicks

