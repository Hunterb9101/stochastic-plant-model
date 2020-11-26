classdef Obj
    %OBJECT A generic object to plot in the model
    
    properties
        x {mustBeNumeric} % Float: The x location of the object
        y {mustBeNumeric} % Float: The y location of the object
        r {mustBeNumeric} % Float: The radius of the object
        col % Color: The color of the object
    end
    
    methods
        function obj = Obj(x, y, r)
            %OBJECT Construct an instance of this class
            %   x: Float. The x location in the model
            %   y: Float. The y location in the model
            %   r: Float. The radius of the object in the model
            obj.x = x;
            obj.y = y;
            obj.r = r;
            obj.col = 'cyan';
        end
        
        function bool = isBordering(obj, obj2)
            % Is an object bordering another object?
            %    obj: Obj. The object to compare 
            %    obj2: Obj. Another object to compare
            % Returns: Logical. 1 if obj is bordering obj2.
            bool = norm([obj.x, obj.y] - [obj2.x, obj2.y]) < obj.r + obj2.r;
        end
        
        function out = areaBordering(obj, obj2)
            % The area of overlap between two objects
            %     obj and obj2: Obj.
            % Returns: Float. An area of overlap between two objects
            % Formula found at:
            %     https://www.researchgate.net/figure/Area-of-overlapping-between-two-circles-of-different-sizes_fig3_275550769
            d = norm([obj.x, obj.y] - [obj2.x, obj2.y]);
            if (d < obj.r + obj2.r)
                out = obj.r  ^ 2 * acos((d ^ 2 +  obj.r ^ 2 - obj2.r ^ 2) / (2 * d * obj.r)) + obj2.r ^ 2 * acos((d ^ 2 + obj2.r ^ 2 - obj.r  ^ 2) / (2 * d * obj2.r)) - .5 * sqrt((-d + obj.r + obj2.r) * (d + obj.r - obj2.r) * (d - obj.r + obj2.r) * (d + obj.r + obj2.r));
                return
            end
            out = 0;
        end
        
        function frac = fracBordering(obj, obj2)
            % Get the fraction of overlap between two objects
            %     obj and obj2: Obj.
            % Returns: Float (between 0 and 1). The fraction of overlap 
            %     between two objects, in reference to obj.
            frac = obj.areaBordering(obj2) / (pi * obj.r ^ 2); 
        end
        
        function out = plot(obj)
            % Plot the object in the model
            %     obj: Obj.
            % Return: Line. A circle plotted with center Obj.x, Obj.y, and
            %     radius Obj.r.
            hold on
            out = filled_circle(obj.x, obj.y, obj.r, obj.col, .4);
            hold off
        end
    end
end

