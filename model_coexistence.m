% Run with and without mortality rates to see how it affects coexistence
%
% The steady state was around 68% for Invasive species with the parameters
% below as of 9/27/20 with a 5% mortality rate on both plants (Takes ~10
% mins to run)
%
% The steady state was around 68% for Invasive species with the parameters
% as of 9/27/20 without mortality (Takes 27s to run)
clear;clc;

% Model Parameters
years = 100; % Number of years for the experiment to run
numModels = 10; % Number of stochastic models to run
sizeGrid = 100; % Size of grid for plants to be grown on

% RII Competitive Index. Should be between -1 and 1
% where -1 is weighted towards the invasive species, and +1 is
% weighted towards the native species. 
rii = -0.3464334;

numPlantN = 30; % Number of Native Plants
mortalityN = .05; % Mortality Rate for Native Plants

numPlantS = 5; % Number of Invasive Plants
mortalityS = .05; % Mortality Rate for Invasive Plants
secondReproductionS = true;

disp("With a 5% Mortality Rate:")
[mByYrN, mByYrS] = model_old(years, numModels, sizeGrid, rii, numPlantN, ...
                         mortalityN, numPlantS, mortalityS, ...
                         secondReproductionS, 1, 1);
mByYrN
mByYrS

disp("Without Mortality Rates:")
mortalityN = 0;
mortalityS = 0;
[mByYrN, mByYrS] = model_old(years, numModels, sizeGrid, rii, numPlantN, ...
                         mortalityN, numPlantS, mortalityS, ...
                         secondReproductionS, 1, 1);
mByYrN
mByYrS