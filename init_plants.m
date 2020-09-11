function  plantGrid = initPlants(size,numPlants)
% Initially populates the grid with a given amount of plants
% size - The size of the grid
% numPlants - Population of plants within the grid
    plantGrid = zeros(size);

    for i = 1:numPlants
        coord = randi([1 size], 1, 2);
        plantGrid(coord(1, 1), coord(1, 2)) = 1;
    end
end