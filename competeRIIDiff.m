function surv_plants = competeRIIDiff(a, b, objects)
%COMPETERIIBasic A function that determines a winner based on RII values.
%   Returns: The plant that survives the competition (Only PlantObj A or 
%       PlantObj B).
    function gen_resolve_matrix(a, b, surv)
        if (surv == 1)
            survived = 1; % The row plant won
        else 
            survived = 2; % The column plant won
        end
        resolution_matrix(a, b) = survived;
    end
    function resolve(row)
        % Get wins and losses for plant row
        win = resolution_matrix(row, :) == 1;
        lose = resolution_matrix(row, :) == 2;
        
        % Get tertiary plants that lost to the loser of this row.
        mask = resolution_matrix == 2;
        mask(:, ~win) = 0;

        % Remove plants that lost (and apply the mask)
        resolution_matrix(mask) = 1;
        resolution_matrix(win, :) = 0;
        
        % If the plant lost any round, kill it.
        if sum(lose) > 0
            resolution_matrix(lose, row) = 1;
            resolution_matrix(row, :) = 0;
        end 
    end
% Get RII values from table
rii_a = arrayfun(@(x) objects(1).plant.riiTable.data(objects(x).plant.rii_table_idx), a);   
rii_b = arrayfun(@(x) objects(1).plant.riiTable.data(objects(x).plant.rii_table_idx), a);  

% Probability function
prob_diff = .25 * (rii_a - rii_b) + .5;

rand_grid = rand(size(prob_diff, 1), 1);
surv = rand_grid > prob_diff; % If 1, plant B wins. Else, plant A wins.

% Resolve bordering plants here.
resolution_matrix = zeros(size(objects,2), size(objects,2));
arrayfun(@gen_resolve_matrix, a, b, surv);
arrayfun(@resolve, (1:size(resolution_matrix,1)).');

surv_plants = objects(max(resolution_matrix, [], 2) == 1);
end


