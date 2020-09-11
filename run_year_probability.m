function [plantN,plantS] = run_year_probability(plantN,plantS,probNativeWinning)
% Runs a year and sees which plants repopulate
% Version 1 - Runs completely off of a competitive advantage for invasive
%     species, the sCompetitiveAdvantage. Any percentage below the number
%     will result in the invasive species gaining the plot
% PlantN - the native plant matrix
% PlantS - the invasive plant matrix
% sCompetitiveAdvantage - The likelihood of an invasive plant gaining the
%     plot
    [szX,szY] = size(plantN); % Get grid size (Both plantN and plantS should be the same size)
    pctSurvival = rand(szX,szY); % Creates a grid of random probabilities of plants surviving
    for x = 1:szX
        for y = 1:szY
            % If only native plant is in the plot
            if(plantN(x,y) > 0 && plantS(x,y) == 0) 
                plantN(x,y) = 1;

            % If only invasive plant is in the plot
            elseif(plantS(x,y) > 0 && plantN(x,y) == 0) 
                plantS(x,y) = 1;

            % Don't add a plant if it there are no seeds in the cell
            elseif(plantS(x,y) == 0 && plantN(x,y) == 0)
                continue
                
            % If both plants are in the same plot
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