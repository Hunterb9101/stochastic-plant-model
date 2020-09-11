function plantGrid = applyMortalityRates(oldPlantGrid,mortalityRate)
    [szX,szY] = size(oldPlantGrid); %Get grid size
    plantGrid = zeros(szX,szY);
    
    % Find indices where there are more than 1 plants
    idxs = find(oldPlantGrid >= 1);
    for idx = 1:length(idxs)
        for k = 1:oldPlantGrid(idxs)
            if rand(1,1) > mortalityRate
                plantGrid(idx) = plantGrid(idx) + 1;
            end
        end 
    end
end
