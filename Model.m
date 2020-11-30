classdef Model < handle
    %MODEL Stochastic Plant Model (Non-grid).
    
    properties
        dims = [100, 100] % Model dimensions (In meters) 
        years = 1; % Number of years to run the model
        riiTable = [
            +0.000, -0.250, -0.500;
            +0.250, +0.000, -0.750; 
            +0.500, +0.750, +0.000
            ];
        objects = [] % The model's objects
        ts_now % A timestamp for plotting output
        plot_output = 1 % Set to 1 to get plot output
    end
    
    methods
        function obj = Model(dims, years, riiTable)
            %MODEL Construct an instance of this class
            obj.dims = dims;
            obj.years = years;
            obj.riiTable = riiTable;
            obj.ts_now = now;
        end
        
        function init(obj)
            %INIT Initializes objects/plants for model
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
        
        function out = run(obj)
            %RUN runs the model for the number of iterations
            %   Returns: List of objects in the final iteration of model
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
                dead_plants = [];
                for i = 1:size(borders, 1)
                    % If a plant is dead, don't check it, and add the other
                    % plant to the resolved list if it isn't already?
                    if (ismember(borders(i, 1), dead_plants) && ismember(borders(i, 2), dead_plants))
                        continue
                    elseif (ismember(borders(i, 1), dead_plants))
                        if ~ismember(borders(i, 2), resolved_bounds)
                            resolved_bounds = [resolved_bounds, borders(i, 2)];
                        end
                        continue
                    elseif (ismember(borders(i, 2), dead_plants))
                        if ~ismember(borders(i, 1), resolved_bounds)
                            resolved_bounds = [resolved_bounds, borders(i, 1)];
                        end
                        continue
                    end
                    
                    % If a plant has multiple bordering plants, remove it
                    % from the resolved list, and have it compete with the
                    % next plant.
                    if (size(resolved_bounds, 2) ~= 0)
                        resolved_bounds(resolved_bounds == borders(i, 1)) = [];
                        resolved_bounds(resolved_bounds == borders(i, 2)) = [];
                    end
                    
                    winner = competeRIIBasic(borders(i, 1), borders(i, 2));
                    
                    % Keep track of plants that lost (Useful for asserting
                    % that the model is working correctly)
                    if (winner == borders(i, 1))
                        loser = borders(i, 2);
                    else
                        loser = borders(i, 1);
                    end
                    
                    % Update lists
                    dead_plants = [dead_plants, loser];
                    resolved_bounds = [resolved_bounds, winner];
                end
                disp("Total: " + size(obj.objects,2) + ", Resolved: " + size(resolved_bounds,2) + ", Dead: " + size(dead_plants,2) + ", No Bordering: " + size(no_borders,2));
                assert(size(obj.objects,2) == size(resolved_bounds,2) + size(dead_plants,2) + size(no_borders,2));
                
                % List of new objects
                obj.objects = [resolved_bounds, no_borders];
                
                % Plot visual output
                if (obj.plot_output)
                    % borders_plot = reshape(borders, [1, size(borders, 1) * size(borders, 2)]);
                    % obj.plotAndSave(no_borders, year, "no-borders")
                    % obj.plotAndSave(borders_plot, year, "borders")
                    % obj.plotAndSave(resolved_bounds, year, "resolved")
                    % obj.plotAndSave(obj.objects, year, "all")
                    obj.plotAndSave(obj.objects, year, "resolved-all")
                end
                % Update all plants to next year
                arrayfun(@(x) x.nextYear(), obj.objects); 
            end
            out = obj.objects;
        end

        function plotAndSave(obj, objects, year, timestamped_filename)
            %PLOTANDSAVE Plots and saves objects.
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

