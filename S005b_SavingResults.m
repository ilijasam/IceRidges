%% This script is saving a .mat file with the resuts from S005 
% and removing points with less ridges than defined in the "Ntreashold variable"

clc
clear all
close all

load('Results\results1.mat')
load('Results\ManualCorrection_3.mat')
addpath('Supporting Files\')

Ntreashold = 15;
LI_DM(N<Ntreashold) = [];
Dmax(N<Ntreashold) = [];
M(N<Ntreashold) = [];
D(N<Ntreashold) = [];
LI_AM(N<Ntreashold) = [];
Location(N<Ntreashold) = [];
LOCSall([N<Ntreashold]',:) = [];
PKSall([N<Ntreashold]',:) = [];
T(N<Ntreashold) = [];
ThisYear(N<Ntreashold) = [];
WE(N<Ntreashold) = [];
WS(N<Ntreashold) = [];
Year(N<Ntreashold) = [];
N(N<Ntreashold) = [];

LI_DM = LI_DM(not(to_delete));
LI_M = LI_M(not(to_delete));
Dmax = Dmax(not(to_delete));
M = M(not(to_delete));
N = N(not(to_delete));
D = D(not(to_delete));
LI_AM = LI_AM(not(to_delete));
Location = Location(not(to_delete));
LOCSall = LOCSall(not(to_delete),:);
PKSall = PKSall(not(to_delete),:);
T = T(not(to_delete));
ThisYear = ThisYear(not(to_delete));
WE = WE(not(to_delete));
WS = WS(not(to_delete));
Year = Year(not(to_delete));

save('Results\FinalResults.mat')
