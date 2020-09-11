function plantGrid = reproduce(oldPlantGrid,radius)
    % The reproduction step of the plants. Gives the number of potentially
    %     viable plants per each cell
    % oldPlantGrid - The plantGrid (either plantN or plantS) that will see a
    %     reproduction step
    % radius - The radius of the spread of the seeds
    
    [szX, szY] = size(oldPlantGrid);
    plantGrid = zeros(szX,szY);
    
    % Contains the indices where plants exist
    idxs = find(oldPlantGrid >= 1);
    for idx = 1:length(idxs)
        [x, y] = ind2sub(size(oldPlantGrid), idxs(idx));
        for i = -radius:radius
            for j = -radius:radius
                if( 1 <= i+x && i+x <= szX && ...
                    1 <= j+y && j+y <= szY)
                    plantGrid(i+x,j+y) = plantGrid(i+x,j+y) + 1;
                end
            end
        end
    end
end
