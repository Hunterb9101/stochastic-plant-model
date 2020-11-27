addpath('./..');
% Checks that the reproduction script works as intended
plantGrid = zeros(5);
plantGrid(3,3) = 1
reproduce(plantGrid, 1)