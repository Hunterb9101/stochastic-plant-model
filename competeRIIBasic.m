function plant_survived = competeRIIBasic(a, b)
%COMPETERIIBasic A function that determines a winner based on RII values.
%   Returns: The plant that survives the competition (Only PlantObj A or 
%       PlantObj B).
rii_a = a.plant.rii_table_idx;
rii_b = b.plant.rii_table_idx;
prob = .5 * a.plant.riiTable.data(rii_a, rii_b) + .5;

if(a.isBordering(b))
    if(prob > rand(1,1))
        plant_survived = b;
    else
        plant_survived = a;
    end
end
end

