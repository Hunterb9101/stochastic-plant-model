classdef Plant
    %PLANT Describes a species of a plant
    
    properties
        name % String: Name of the species
        spread_fun  % Function: Spread function for reproduction step
        mature_rad  % Float: Mature radius of a plant
        mature_age  % Int: Age that a plant survives to
        reproduction_steps % Int: The number of reproductions in a year
        rii_table_idx % Int: Index of plant in the RII table
        col % Color: Color of the plant
    end
    
    properties (Constant)
        riiTable = StaticVar % The RII table to be used in reproduction steps
    end
    
    methods
        function p = Plant(name, spread_fun, mature_rad, mature_age, reproduction_steps, col, rii_table_idx)
            %PLANT Construct an instance of this class
            %   name: String. Name of the species
            %   spreadFun: Function. Spread function for reproduction step
            %   matureRad: Float. Mature radius of a plant
            %   col: Color. The color of the plant when plotted
            %   riiTableIdx: Int. Index of the plant in the RII table
            p.name = name;
            p.spread_fun = spread_fun;
            p.mature_rad = mature_rad;
            p.mature_age = mature_age;
            p.rii_table_idx = rii_table_idx;
            p.reproduction_steps = reproduction_steps;
            p.col = col;
        end
    end
end

