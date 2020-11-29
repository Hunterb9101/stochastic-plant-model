classdef Model < handle
    %MODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dims = [100, 100]
        years = 1;
        riiTable = [
            +0.000, -0.250, -0.500;
            +0.250, +0.000, -0.750; 
            +0.500, +0.750, +0.000
            ];
        objects = []
        ts_now
    end
    
    methods
        function obj = Model(dims, years, riiTable)
            %MODEL Construct an instance of this class
            %   Detailed explanation goes here
            obj.dims = dims;
            obj.years = years;
            obj.riiTable = riiTable;
            obj.ts_now = now;
        end
        
        function init(obj)
            % Initializes objects/plants for model
            spread = @(x,y,species) spreadBasic(x, y, species, 2, 50);
            plant_list = [
                Plant("InvasivePlant", spread, .75, "r", 1), ...
                Plant("NativePlant", spread, 1, "b", 2), ...
                Plant("NativePlant2", spread, 3, "g", 3)
            ];
            plant_list(1).riiTable.data = obj.riiTable; 
            init_plant_num = [10, 50, 25]; % Initial number of plants to spawn

            % Initialize plants
            for plant_idx = 1:size(plant_list, 2)
                r = rand(2, init_plant_num(plant_idx));
                r(1,:) = obj.dims(1) * r(1,:);
                r(2,:) = obj.dims(2) * r(2,:);
                for coord = r
                    obj.objects = [obj.objects, PlantObj(coord(1), coord(2), plant_list(plant_idx))];
                end
            end
        end
        
        function run(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            for year = 1:obj.years
                disp("Year: " + year);
                idx = arrayfun(@(x)x.age < x.plant.mature_age, obj.objects);
                obj.objects = obj.objects(idx);

                % Reproduce
                new_plants = [];
                for i = obj.objects
                    % new_plants = [new_plants, i.reproduce()];
                end
                disp("New Plants: " + size(new_plants, 2));
                obj.objects = [obj.objects, new_plants];

                % Remove Overlaps
                log_no_borders = ones(size(obj.objects));
                borders = [];
                for i = 1:size(obj.objects, 2)
                    for j = 1:i-1
                        if(obj.objects(i).isBordering(obj.objects(j)))
                            borders = [borders; [obj.objects(i), obj.objects(j)]];
                            log_no_borders([i,j]) = 0;
                        end
                    end
                end
                no_borders = obj.objects(logical(log_no_borders));

                resolved_bounds = [];
                for i = 1:size(borders, 1)
                    if (size(resolved_bounds, 2) ~= 0)
                        resolved_bounds(resolved_bounds == borders(i, 1)) = [];
                        resolved_bounds(resolved_bounds == borders(i, 2)) = [];
                    end
                    winner = competeRIIBasic(borders(i, 1), borders(i, 2));
                    resolved_bounds = [resolved_bounds, winner];
                end
                
                borders_plot = reshape(borders, [1, size(borders, 1) * size(borders, 2)]);
                obj.plotAndSave(no_borders, year, "no-borders")
                obj.plotAndSave(borders_plot, year, "borders")
                obj.plotAndSave(resolved_bounds, year, "resolved")
                obj.plotAndSave(obj.objects, year, "all")
                
                obj.objects = [resolved_bounds, no_borders];
                obj.plotAndSave(obj.objects, year, "resolved-all")
                
                % Update all plants to next year
                arrayfun(@(x) x.nextYear(), obj.objects); 
            end
        end

        function plotAndSave(obj, objects, year, timestamped_filename)
            % Plots and saves objects
            clf;
            xlim([0, obj.dims(1)]);
            ylim([0, obj.dims(2)]);
            daspect([1 1 1]);
            for i = objects
                i.plot();
            end

            % Saves each year in the reports subdirectory.
            fmt_filename = ["./reports/model-%s/", "yr%03d-%s.png"];
            filename = sprintf(fmt_filename(2), year, timestamped_filename);
            filepath = sprintf(fmt_filename(1), datestr(obj.ts_now, 'yyyymmddHHMM'));
            if (~isfolder(filepath))
                mkdir(filepath)
            end
            saveas(gcf, filepath+filename);
        end
    end
end

