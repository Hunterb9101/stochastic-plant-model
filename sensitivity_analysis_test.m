clear;
clc;

outfile = sprintf("reports/sensitivity-analysis-debug-%s.csv", datestr(now, 'yyyymmddHHMM'));
model_dims = [50, 50];  % 50 meters^2
years = 10; % Number of years to run the model


dt_now = datestr(now, 'yyyymmddHHMM');
        
for i = 1:10
    disp([int2str(i),' of ', int2str(10)])
    rii_table = [
        0, 0;
        0, 0; 
    ];

    % Build plants from data.
    plant_list = [
        Plant("Plant A", ...
            @(x,y,species) spreadLowHigh(x, y, species, ...
                                         10, 10, ...
                                         0, 1, ...
                                         "Beta"), ...
            .75, 1, 1, "b", 1), ...
        Plant("Plant B", ...
            @(x,y,species) spreadLowHigh(x, y, species, ...
                                         10, 10, ...
                                         0, 1, ...
                                         "Beta"), ...
            .75, 1, 1, "r", 2), ...
    ];

    plant_num = [35, 35];

    m = Model(model_dims, years, rii_table, plant_list, plant_num);
    m.output_filepath = sprintf("./reports/sensitivity-analysis-%s-debug/model-%s/", dt_now, int2str(i));
    m.init();
    m.run();
end 