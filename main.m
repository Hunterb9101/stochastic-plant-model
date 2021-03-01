tic;
clc;
model_dims = [250, 250];  % 100 meters by 100 meters
years = 5; % Number of years to run the model

% We will conduct pairwise experiments of Sisymbrium versus a competitor
% plant
loc = 'GR1';
competitor = 'LP';

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
    Plant(sys.name(1), ...
        @(x,y,species) spreadLowHigh(x, y, species, ...
                                     sys.seeds_lo(1), sys.seeds_hi(1), ...
                                     sys.spread_lo(1)/100, sys.spread_hi(1)/100, ...
                                     sys.spread_method(1)), ...
        sys.width(1)/100, sys.mature_age(1), "r", 1), ...
    Plant(cmp.name(1), ...
        @(x,y,species) spreadLowHigh(x, y, species, ...
                                     cmp.seeds_lo(1), cmp.seeds_hi(1), ...
                                     cmp.spread_lo(1)/100, cmp.spread_hi(1)/100, ...
                                     cmp.spread_method(1)), ...
        cmp.width(1)/100, cmp.mature_age(1), "b", 2), ...
];
  
plant_num = [1, 1];

m = Model(model_dims, years, rii_table, plant_list, plant_num);
m.init();
m.plot_output = 1;
m.run();
toc;