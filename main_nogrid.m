clc; clf;

% Model Parameters
model_dims = [100, 100];  % 100 meters by 100 meters
save_chart = 0; % Logical. Saves each year's chart if set to 1.
years = 2; % Number of years to run the model
riiTable = [
    0.000, 0.250;
    0.250, 0.000
    ];
plant_list = [
	Plant("InvasivePlant", "SPREAD-FUNCTION", .75, "r", 1), ...
	Plant("NativePlant", "SPREAD-FUNCTION", 1, "b", 2), ...
    Plant("NativePlant2", "SPREAD-FUNCTION", 3, "g", 3)
];
plant_list(1).riiTable.data = riiTable; 
init_plant_num = [10, 50, 25]; % Initial number of plants to spawn

% Plot settings
xlim([0, model_dims(1)])
ylim([0, model_dims(2)])
daspect([1 1 1])

% Initialize plants
objs = [];
for plant_idx = 1:size(plant_list, 2)
    r = rand(2, init_plant_num(plant_idx));
    r(1,:) = model_dims(1) * r(1,:);
    r(2,:) = model_dims(2) * r(2,:);
    for coord = r
        objs = [objs, PlantObj(coord(1), coord(2), plant_list(plant_idx))];
    end
end

for year = 1:years
    for i = objs
        i.plot();
    end
    
    if(save_chart)
        % Saves each year in the reports subdirectory.
        fmt_filename = ["./reports/model-%s/", "yr%03d-out.png"];
        filename = sprintf(fmt_filename(2), year);
        filepath = sprintf(fmt_filename(1), datestr(now, 'yyyymmddHHMM'));
        if (~isfolder(filepath))
            mkdir(filepath)
        end
        saveas(gcf, filepath+filename);
    end
    clf;
end
