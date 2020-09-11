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
        plantN = init_plants(sizeGrid,numPlantN); % Matrix of native plants
        plantS = init_plants(sizeGrid,numPlantS); % Matrix of invasive plants
        [plantN,plantS] = rm_plant_overlaps(plantN,plantS); % Normalizes to one plant per cell

        for j = 1:years
            % Apply Mortality Rates
            % NOTE: This step is computationally expensive
            %plantN = apply_mortality_rates(plantN,mortalityN);
            %plantS = apply_mortality_rates(plantS,mortalityS);

            % Mid-year reproduction step
            plantS = reproduce(plantS,1);

            % End-year reproduction
            plantN = reproduce(plantN,1);
            plantS = reproduce(plantS,1);
            [plantN,plantS] = run_year_rii(plantN,plantS, rii);

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