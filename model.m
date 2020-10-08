function [mByYrN, mByYrS] = model(years, numModels, sizeGrid, rii, ... 
                                      numPlantN, mortalityN, numPlantS, ...
                                      mortalityS, secondReproductionS, ...
                                      reprRadN, reprRadS)
    % Analysis Variablaes
    pctPlantN = zeros(years, numModels); % Percent of native plants in the matrix
    pctPlantS = zeros(years, numModels); % Percent of invasive plants in the matrix
    mByYrN = zeros(years,1); % The mean percent by year of the native plants
    mByYrS = zeros(years,1); % The mean percent by year of the invasive plants

    % Set RNG seed and generator. (Uncomment to create reproducible
    % results. Keep commented to get randomized results):
    % rng(2,'twister'); % Random Number Generation Setup
    tic
    for i = 1:numModels
        plantN = init_plants(sizeGrid,numPlantN); % Matrix of native plants
        plantS = init_plants(sizeGrid,numPlantS); % Matrix of invasive plants
        [plantN,plantS] = rm_plant_overlaps(plantN,plantS); % Normalizes to one plant per cell

        for j = 1:years
            % Apply Mortality Rates
            % NOTE: This step is computationally expensive
            plantN = apply_mortality_rates(plantN,mortalityN);
            plantS = apply_mortality_rates(plantS,mortalityS);

            % Mid-year reproduction step
            if secondReproductionS
                plantS = reproduce(plantS,reprRadS);
            end

            % End-year reproduction
            plantN = reproduce(plantN,reprRadN);
            plantS = reproduce(plantS,reprRadS);
            [plantN,plantS] = run_year_rii(plantN,plantS, rii);

            numPlants = [sum(plantN(:)), sum(plantS(:))];
            pctPlantN(j,i) = numPlants(1) / sum(numPlants); % Collect percentage of native plants
            pctPlantS(j,i) = numPlants(2) / sum(numPlants); % Collect percentage of invasive plants
        end %Time Step
    end %Stochastic Model
    
    % Analysis
    for i = 1:years
        mByYrN(i) = mean2(pctPlantN(i,:));
        mByYrS(i) = mean2(pctPlantS(i,:));
    end
    toc
end