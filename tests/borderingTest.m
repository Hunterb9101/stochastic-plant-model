addpath('./..');
num_tests = 1000;
model_dims = [100, 100];  % 100 meters by 100 meters
years = 1; % Number of years to run the model
riiTable = [
    +0.000, -0.250, -0.500;
    +0.250, +0.000, -0.750; 
    +0.500, +0.750, +0.000
    ];

for test = 1:num_tests
    m = Model(model_dims, years, riiTable);
    m.plot_output = 0;
    m.init();
    objs = m.run();

    for i = 1:size(objs,2)
        for j = 1:i-1
            assert(~objs(i).isBordering(objs(j)))
        end
    end
end

