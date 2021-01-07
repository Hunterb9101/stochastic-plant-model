function plantObjs = spreadBasic(center_x, center_y, species, seeds, spreadRad)
%SPREADBASIC Summary of this function goes here
%   Detailed explanation goes here
%   seeds: Integer. Number of seeds to spread
%   spreadRad: The radius to spread the seeds
distr = makedist("Normal", spreadRad/2, spreadRad/6);
r = random(distr, seeds, 1);
theta = (2*pi).*rand(seeds, 1);

coords = transpose([r.*sin(theta), r.*cos(theta)]);
plantObjs = [];

for c = coords
    plantObjs = [plantObjs, PlantObj(center_x + c(1), center_y + c(2), species)];
end


end

