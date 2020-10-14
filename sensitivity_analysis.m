clear;clc;
outfile = "reports/sensitivity_analysis.csv";
years = 100; % Number of years for the experiment to run
numModels = 10; % Number of stochastic models to run
sizeGrid = 100; % Size of grid for plants to be grown on

RII = -1:.2:0; % RII Competitive Index. Should be between -1 and 1
numPlantN = 1:50:101; % Number of Native Plants
mortalityN = 0; % Mortality Rate for Native Plants
numPlantS = 1:50:101; % Number of Invasive Plants
mortalityS = 0; % Mortality Rate for Invasive Plants
secondReproductionS = [false, true];
reprRadN = 1:1:3;
reprRadS = 1:1:3;

[rii, npn, mn, nps, ms, sps, rrn, rrs] = ndgrid(RII, numPlantN, mortalityN, ...
    numPlantS, mortalityS, secondReproductionS, reprRadN, reprRadS);

paramHeaders = ["rii", "npn", "mn", "nps", "ms", "sps", "rrn", "rrs"]
param = [rii(:) npn(:), mn(:), nps(:), ms(:), sps(:), rrn(:), rrs(:)];
[szX,szY] = size(param)
for i = 1:szX
    disp([i, ' of ', szX])
    [mByYrN, mByYrS] = model(years, numModels, sizeGrid, param(i, 1), param(i, 2), ...
                             param(i, 3), param(i, 4), param(i, 5), ...
                             param(i, 6), param(i, 7), param(i, 8));
    
    data = [i, param(i, :),transpose(mByYrN), transpose(mByYrS)];
    if ~isfile(outfile)
        headers = ["trial", paramHeaders, strcat("n",string(1:years)), strcat("s",string(1:years))]
        writematrix(headers, outfile)
    end
    writematrix(data, outfile, 'WriteMode', 'append')
    
end