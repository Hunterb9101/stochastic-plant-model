function [plantN,plantS] = rm_plant_overlaps(plantN, plantS)
    [szX,szY] = size(plantN); %Get grid size
    idxs = find(plantN > 0);
    for idx = 1:size(idxs)
        % Remove overlaps between plantS and plantN.
        % PlantN should get priority.
        plantS(idxs(idx)) = 0;
    end
end