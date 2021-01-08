clc;
model_dims = [250, 250];  % 100 meters by 100 meters
years = 5; % Number of years to run the model
rii_table = [
    +0.000, -0.250, -0.500;
    +0.250, +0.000, -0.750; 
    +0.500, +0.750, +0.000
    ];

spread = @(x,y,species) spreadBasic(x, y, species, 2, 50);
plant_list = [
    Plant("InvasivePlant", spread, .75, "r", 1), ...
    Plant("NativePlant", spread, 1, "b", 2), ...
    Plant("NativePlant2", spread, 3, "g", 3)
];
  
plant_num = [10, 50, 25];

m = Model(model_dims, years, rii_table, plant_list, plant_num);
m.init();
m.plot_output = 1;
m.run();