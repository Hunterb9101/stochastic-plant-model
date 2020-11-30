clc;
model_dims = [100, 100];  % 100 meters by 100 meters
years = 1; % Number of years to run the model
riiTable = [
    +0.000, -0.250, -0.500;
    +0.250, +0.000, -0.750; 
    +0.500, +0.750, +0.000
    ];

m = Model(model_dims, years, riiTable);
m.init();
m.plot_output = 1;
m.run();



