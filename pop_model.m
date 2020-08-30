function pop_model
    clear;clc;

    % Model Parameters
    years = 25; % Number of years for the experiment to run
    k = 10; % Number of stochastic models to run
    sizeGrid = 100; % Size of grid for plants to be grown on

    % RII Competitive Index. Should be between -1 and 1
    % where -1 is weighted towards the invasive species, and +1 is
    % weighted towards the native species. 
    rii = -0.3464334;
    
    numPlantN = 30; % Number of Native Plants
    mortalityN = .05; % Mortality Rate for Native Plants

    numPlantS = 5; % Number of Invasive Plants
    mortalityS = .05; % Mortality Rate for Invasive Plants

    % Analysis Variablaes
    pctPlantN = zeros(years,k); % Percent of native plants in the matrix
    pctPlantS = zeros(years,k); % Percent of invasive plants in the matrix
    mByYearPlantN = zeros(years,1); % The mean percent by year of the native plants
    mByYearPlantS = zeros(years,1); % The mean percent by year of the invasive plants

    % Set RNG seed and generator. (Uncomment to create reproducible
    % results. Keep commented to get randomized results):
    % rng(2,'twister'); % Random Number Generation Setup

    tic
    for i = 1:k
        plantN = initPlants(sizeGrid,numPlantN); % Matrix of native plants
        plantS = initPlants(sizeGrid,numPlantS); % Matrix of invasive plants
        [plantN,plantS] = initRemovePlantOverlaps(plantN,plantS); % Normalizes to one plant per cell

        for j = 1:years
            % Apply Mortality Rates
            % NOTE: This step is computationally expensive
            %plantN = applyMortalityRates(plantN,mortalityN);
            %plantS = applyMortalityRates(plantS,mortalityS);

            % Mid-year reproduction step
            plantS = reproduce(plantS,1);

            % End-year reproduction
            plantN = reproduce(plantN,1);
            plantS = reproduce(plantS,1);
            [plantN,plantS] = runYearRII(plantN,plantS, rii);

            numPlants = [sum(plantN(:)), sum(plantS(:))];
            pctPlantN(j,i) = numPlants(1) / sum(numPlants); % Collect percentage of native plants
            pctPlantS(j,i) = numPlants(2) / sum(numPlants); % Collect percentage of invasive plants
        end %Time Step
    end %Stochastic Model

    % Analysis
    for i = 1:years
        mByYearPlantN(i) = mean2(pctPlantN(i,:));
        mByYearPlantS(i) = mean2(pctPlantS(i,:));
    end
    mByYearPlantN
    mByYearPlantS
    toc
end

% Initially populates the grid with a given amount of plants
% size - The size of the grid
% numPlants - Population of plants within the grid
function  plantGrid = initPlants(size,numPlants)
    plantGrid = zeros(size);

    for i = 1:numPlants
        coord = randi([1 size], 1, 2);
        plantGrid(coord(1, 1), coord(1, 2)) = 1;
    end
end

% The reproduction step of the plants. Gives the number of potentially
%     viable plants per each cell
% oldPlantGrid - The plantGrid (either plantN or plantS) that will see a
%     reproduction step
% radius - The radius of the spread of the seeds
function plantGrid = reproduce(oldPlantGrid,radius)
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

function [plantN,plantS] = initRemovePlantOverlaps(plantN, plantS)
    [szX,szY] = size(plantN); %Get grid size
    idxs = find(plantN > 0);
    for idx = 1:size(idxs)
        % Remove overlaps between plantS and plantN.
        % PlantN should get priority.
        plantS(idxs(idx)) = 0;
    end
end


function [plantN,plantS] = runYearRII(plantN, plantS, rii)    
    % Looking for function with following properties:
    % 50% chance of either species winning at RII = 0
    % 100% chance of Native winning at RII = 1
    % 100% chance of Invasive winning at RII = -1
    % Symmetric at RII = 0
    prob = .5 * rii + .5;
    [plantN, plantS] = runYearProbability(plantN, plantS, prob);
end

% Runs a year and sees which plants repopulate
% Version 1 - Runs completely off of a competitive advantage for invasive
%     species, the sCompetitiveAdvantage. Any percentage below the number
%     will result in the invasive species gaining the plot
% PlantN - the native plant matrix
% PlantS - the invasive plant matrix
% sCompetitiveAdvantage - The likelihood of an invasive plant gaining the
%     plot
function [plantN,plantS] = runYearProbability(plantN,plantS,probNativeWinning)
    [szX,szY] = size(plantN); %Get grid size (Both plantN and plantS should be the same size)
    pctSurvival = rand(szX,szY); %Creates a grid of random probabilities of plants surviving
    for x = 1:szX
        for y = 1:szY
            %If only native plant is in the plot
            if(plantN(x,y) > 0 && plantS(x,y) == 0) 
                plantN(x,y) = 1;

            %If only invasive plant is in the plot
            elseif(plantS(x,y) > 0 && plantN(x,y) == 0) 
                plantS(x,y) = 1;

            %If both plants are in the same plot
            else
                if(pctSurvival(x,y) < probNativeWinning)
                    plantN(x,y) = 1; %The native plant beats out the invasive plant
                    plantS(x,y) = 0;
                else
                    plantN(x,y) = 0;
                    plantS(x,y) = 1; %Invasive plant beats out the native plant
                end
            end
        end
    end
end
