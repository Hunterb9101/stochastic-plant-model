function plantObjs = spreadLowHigh(center_x, center_y, species, seeds_low, seeds_high, ...
    spread_low, spread_high, spread_distribution)
%SPREADBASIC Summary of this function goes here
%   Detailed explanation goes here
%   seeds: Integer. Number of seeds to spread
%   spreadRad: The radius to spread the seeds

if spread_distribution == "Beta"
    distr = makedist("Beta", 2, 2);
    r = random(distr, seeds_low, 1) * (spread_high - spread_low) + species.mature_rad;
else
    distr = makedist("Uniform", spread_low + species.mature_rad, spread_high + species.mature_rad);
    r = random(distr, seeds_low, 1);
end

theta = (2*pi).*rand(seeds_low, 1);
coords = transpose([r.*sin(theta), r.*cos(theta)]);

plantObjs = [];
for c = coords
    plantObjs = [plantObjs, PlantObj(center_x + c(1), center_y + c(2), species)];
end


end

