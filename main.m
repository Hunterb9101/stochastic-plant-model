tic;
clc;
model_dims = [50, 50];  % 100 meters by 100 meters
years = 10; % Number of years to run the model
seed_scale = .1; % What fraction of seeds are left out?

% We will conduct pairwise experiments of Sisymbrium versus a competitor
% plant
loc = 'GR1';
competitor = 'PS';

% Build RII table from `loc` and `competitor`
rii_pairs = readtable("data/model_input/rii_pairs.csv");
rii_data = rii_pairs(ismember(rii_pairs.competitor_species,competitor) ...
                     & ismember(rii_pairs.loc,loc), :);
rii_table = [
    0, rii_data.rii_tb_s(1);
    rii_data.rii_tb(1) , 0; 
    ];

% Build plants from data.
plant_data = readtable("data/model_input/plant_data.csv");
cmp = plant_data(ismember(plant_data.plant_id, competitor), :);
sys = plant_data(ismember(plant_data.plant_id, 'SL'), :);
plant_list = [
    Plant(string(sys.name), ...
        @(x,y,species) spreadLowHigh(x, y, species, ...
                                     int16(seed_scale*sys.seeds_lo(1)), int16(seed_scale*sys.seeds_hi(1)), ...
                                     sys.spread_lo(1)/100, sys.spread_hi(1)/100, ...
                                     sys.spread_method(1)), ...
        sys.width(1)/100, sys.mature_age(1), sys.rep_cyc(1), "r", 1), ...
    Plant(string(cmp.name), ...
        @(x,y,species) spreadLowHigh(x, y, species, ...
                                     int16(seed_scale*cmp.seeds_lo(1)), int16(seed_scale*cmp.seeds_hi(1)), ...
                                     cmp.spread_lo(1)/100, cmp.spread_hi(1)/100, ...
                                     cmp.spread_method(1)), ...
        cmp.width(1)/100, cmp.mature_age(1), cmp.rep_cyc(1), "b", 2), ...
];
  
plant_num = [10, 10];

m = Model(model_dims, years, rii_table, plant_list, plant_num);
m.init();
m.run();
toc;