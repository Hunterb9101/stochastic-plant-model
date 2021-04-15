clear;
clc;

outfile = sprintf("reports/sensitivity-analysis-%s.csv", datestr(now, 'yyyymmddHHMM'));
model_dims = [50, 50];  % 50 meters^2
years = 10; % Number of years to run the model


% Grid Approach
rii_diff = 0:0.25:2; % RII Competitive Index. Should be between -1 and 1
seed_diff = 0:25:100;
spread_diff = 0:.5:3;
rep_cyc = [1, 2];
% [rd, sd, spd, rc] = ndgrid(rii_diff, seed_diff, spread_diff, rep_cyc);
% param = [rd(:), sd(:), spd(:), rc(:)];

% All-Else-Equal Approach
def_rii = 0;
def_seed = 0;
def_spread = 0;
def_rep = 1;

dt_now = datestr(now, 'yyyymmddHHMM');

rd = [rii_diff, ...
    zeros(1, size(seed_diff,2)) + def_rii, ...
    zeros(1, size(spread_diff,2)) + def_rii, ...
    zeros(1, size(rep_cyc,2)) + def_rii];

sd = [zeros(1, size(rii_diff,2)) + def_seed, ...
    seed_diff, ...
    zeros(1, size(spread_diff,2)) + def_seed, ...
    zeros(1, size(rep_cyc,2)) + def_seed];
spd = [zeros(1, size(rii_diff,2)) + def_spread, ...
    zeros(1, size(seed_diff,2)) + def_spread, ...
    spread_diff, ...
    zeros(1, size(rep_cyc,2)) + def_spread];
rc = [zeros(1, size(rii_diff,2)) + def_rep, ...
    zeros(1, size(seed_diff,2)) + def_rep, ...
    zeros(1, size(spread_diff,2)) + def_rep, ...
    rep_cyc
    ];

paramHeaders = ["rii_diff","seed_diff", "spread_diff", "rep_cyc"];
param = transpose([rd; sd; spd; rc]);
[szX,szY] = size(param);

writematrix(paramHeaders, outfile);
writematrix(param, outfile, 'WriteMode', 'append');
        
for i = 21:szX
    disp([int2str(i),' of ', int2str(szX)])
    rii_table = [
        0, param(i, 1)/2;
        -param(i, 1)/2 , 0; 
    ];

    % Build plants from data.
    plant_list = [
        Plant("Plant A", ...
            @(x,y,species) spreadLowHigh(x, y, species, ...
                                         10 + param(i, 2), 10 + param(i, 2), ...
                                         0, 1 + param(i, 3), ...
                                         "Beta"), ...
            .75, 1, param(i, 4), "b", 1), ...
        Plant("Plant B", ...
            @(x,y,species) spreadLowHigh(x, y, species, ...
                                         10, 10, ...
                                         0, 1, ...
                                         "Beta"), ...
            .75, 1, 1, "r", 2), ...
    ];

    plant_num = [35, 35];

    m = Model(model_dims, years, rii_table, plant_list, plant_num);
    m.output_filepath = sprintf("./reports/sensitivity-analysis-%s/model-%s/", dt_now, int2str(i));
    m.init();
    m.run();
end 