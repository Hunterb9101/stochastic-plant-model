% Tests that the RII value set at 0, all things equal, will create a 50/50 ratio between the two species.
clear;clc;
% Model Parameters
years = 25; % Number of years for the experiment to run
numModels = 10; % Number of stochastic models to run
sizeGrid = 100; % Size of grid for plants to be grown on

% RII Competitive Index. Should be between -1 and 1
% where -1 is weighted towards the invasive species, and +1 is
% weighted towards the native species. 
rii = 0;

numPlantN = 30; % Number of Native Plants
mortalityN = .00; % Mortality Rate for Native Plants

numPlantS = 30; % Number of Invasive Plants
mortalityS = .00; % Mortality Rate for Invasive Plants
secondReproductionS = true;
[mByYrN, mByYrS] = model(years, numModels, sizeGrid, rii, numPlantN, ...
                         mortalityN, numPlantS, mortalityS, ... 
                         secondReproductionS, 1, 1);
mByYrN
mByYrS
