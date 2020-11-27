addpath('./..');
% Tests that the mortality rates function works correctly
plantGrid = zeros(5);
plantGrid(3,3) = 1
apply_mortality_rates(plantGrid, .5)

