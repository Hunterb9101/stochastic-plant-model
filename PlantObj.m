classdef PlantObj < Obj
    %PLANT_OBJ A physical plant in the model
    
    properties
        plant % Plant: The plant speices 
        age % Int: An integer for the age of a plant
    end
    
    methods
        function obj = PlantObj(x, y, speciesPlant)
            %PLANT_OBJ Construct an instance of this class
            %   x: Float. X location in the model
            %   y: Float. Y location in the model
            %   speciesPlant: Plant. The plant type in the model
            obj@Obj(x, y, speciesPlant.matureRad);
            obj.plant = speciesPlant;
            obj.col = speciesPlant.col;
        end
        
        function out = plot(obj)
            % Plot the object in the model (Overloads Obj .plot() method)
            %     obj: Obj.
            % Returns: Line. A circle plotted with center Obj.x, Obj.y, and
            %     radius Obj.r.
            hold on
            out = filled_circle(obj.x, obj.y, .1, obj.col, 1);
            out = filled_circle(obj.x, obj.y, obj.r, obj.col, .4);
            hold off
        end
    end
end

