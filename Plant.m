classdef Plant
    %PLANT Describes a species of a plant
    
    properties
        name % String: Name of the species
        spreadFun  % Function: Spread function for reproduction step
        matureRad  % Float: Mature radius of a plant
        matureAge  % Int: Age that a plant survives to
        riiTableIdx % Int: Index of plant in the RII table
        col % Color: Color of the plant
    end
    
    properties (Constant)
        riiTable = StaticVar % The RII table to be used in reproduction steps
    end
    
    methods
        function p = Plant(name, spreadFun, matureRad, col, riiTableIdx)
            %PLANT Construct an instance of this class
            %   name: String. Name of the species
            %   spreadFun: Function. Spread function for reproduction step
            %   matureRad: Float. Mature radius of a plant
            %   col: Color. The color of the plant when plotted
            %   riiTableIdx: Int. Index of the plant in the RII table
            p.name = name;
            p.spreadFun = spreadFun;
            p.matureRad = matureRad;
            p.riiTableIdx = riiTableIdx;
            p.col = col;
        end
    end
end

