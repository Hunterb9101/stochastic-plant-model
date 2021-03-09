classdef Model < handle
    %MODEL Stochastic Plant Model (Non-grid).
    
    properties
        dims = [100, 100] % Model dimensions (In meters) 
        years = 1; % Number of years to run the model
        rii_table = []
        plant_list = [] % A list of the different species in the model
        plant_init = [] % The number of each plant to add (in same order as plant_list)
        objects = [] % The model's objects
        ts_now % A timestamp for plotting output
        output = 1 % Set to 1 to get model output
        border_margin = 10
        out_plant_num = [] % A list of plant counts by year
    end
    
    methods
        function obj = Model(dims, years, rii_table, plant_list, plant_init)
            %MODEL Construct an instance of this class
            obj.dims = dims;
            obj.years = years;
            obj.rii_table = rii_table;
            obj.plant_list = plant_list;
            obj.plant_init = plant_init;
            obj.ts_now = now;
            obj.out_plant_num = zeros(years, length(plant_list));
            disp(size(obj.out_plant_num));
        end
        
        function init(obj)
            %INIT Initializes objects/plants for model
            obj.plant_list(1).riiTable.data = obj.rii_table; 

            % Initialize plants
            for plant_idx = 1:size(obj.plant_list, 2)
                r = rand(2, obj.plant_init(plant_idx));
                r(1,:) = obj.dims(1) * r(1,:);
                r(2,:) = obj.dims(2) * r(2,:);
                for coord = r
                    obj.objects = [obj.objects, PlantObj(coord(1), coord(2), obj.plant_list(plant_idx))];
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
                    temp = i.reproduce();
                    for t = temp
                        if (t.x > 0 && t.x < obj.dims(1) && t.y > 0 && ...
                            t.y < obj.dims(2))
                            new_plants = [new_plants, t];
                        end
                    end
                end
                disp("New Plants: " + size(new_plants, 2) + ", Existing Plants: " + length(obj.objects));
                obj.objects = [obj.objects, new_plants];

                disp("Getting bordering plants.");  
                all_x = arrayfun(@(t) t.x, obj.objects);
                all_y = arrayfun(@(t) t.y, obj.objects);
                plant_sz = arrayfun(@(t) t.plant.mature_rad, obj.objects);
                borders_idx = false(length(obj.objects), length(obj.objects));
                no_border_idx = true(size(obj.objects));
                
                for p = 1:length(obj.objects)
                    plant = obj.objects(p);
                    [x_pts, y_pts] = circle_no_plot(plant.x, plant.y, 2*max(plant_sz));
                    
                    [in,on] = inpolygon(all_x, all_y, x_pts, y_pts);
                    in(p) = 0; % Don't count the plant itself in the polygon
                    borders_idx(p,:) = in | on;
                    no_border_idx = no_border_idx & ~(in | on);
                end
                no_borders = obj.objects(no_border_idx);

                disp("Calculating competition");
                borders_idx = triu(borders_idx, 1);
                [b_x, b_y] = find(borders_idx == 1);
                
                for i=1:size(b_x)
                    if ~obj.objects(b_x(i)).isBordering(obj.objects(b_y(i)))
                        borders_idx(b_x(i), b_y(i)) = 0;
                        if sum(borders_idx(:, b_x(i))) == 0 && sum(borders_idx(b_x(i), :)) == 0
                            no_borders = [no_borders, obj.objects(b_x(i))];
                        elseif sum(borders_idx(:, b_y(i))) == 0 && sum(borders_idx(b_y(i), :)) == 0
                            no_borders = [no_borders, obj.objects(b_y(i))];
                        end
                    end
                end
                [b_x, b_y] = find(borders_idx == 1);
                resolved_bounds = competeRIIDiff(b_x, b_y, obj.objects);

                
                disp("Total: " + size(obj.objects,2) + ", Resolved: " + size(resolved_bounds,2) +  ", No Bordering: " + size(no_borders,2));
                
                % List of new objects
                obj.objects = [resolved_bounds, no_borders];
                yr_plant_num = zeros(length(obj.plant_list),1);
                for i=1:length(yr_plant_num)
                    yr_plant_num(i) = sum(arrayfun(@(x) x.plant.name == obj.plant_list(i).name, obj.objects));
                end
                
                obj.out_plant_num(year,:) = yr_plant_num;
                
                if (obj.output)
                    obj.modelOutput(obj.objects, year);
                end
                % Update all plants to next year
                arrayfun(@(x) x.nextYear(), obj.objects); 
            end
            out = obj.objects;
        end

        function modelOutput(obj, objects, year)
            pltname = sprintf("yr%03d-%s.png", year, "out");
            filepath = sprintf("./reports/model-%s/", datestr(obj.ts_now, 'yyyymmddHHMM'));
            if (~isfolder(filepath))
                mkdir(filepath)
            end
            
            plt = plotGrid(obj, objects);
            saveas(plt, filepath+pltname);
            tbl = table(transpose(1:obj.years), obj.out_plant_num);
            tbl.Properties.VariableNames = {'year' 'plant_counts'};
            
            writetable(tbl, filepath+"out.csv", "Delimiter", ",", "QuoteStrings", true);
        end
        
        function plt=plotGrid(obj, objects)
            %PLOTANDSAVE Plots and saves objects.
            clf;
            xlim([0 - obj.border_margin, obj.dims(1) + obj.border_margin]);
            ylim([0 - obj.border_margin, obj.dims(2) + obj.border_margin]);
            yline(0, '--');
            xline(0, '--');
            yline(obj.dims(2), '--');
            xline(obj.dims(1), '--');
            daspect([1 1 1]);
            for i = objects
                i.plot();
            end
            plt=gcf;
            
        end
    end
end

