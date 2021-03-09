function [x_circle, y_circle] = circle_no_plot(x,y,r)
    % CIRCLE: Plots a circle at (x,y) with radus r and color `col`.
    % Returns: Line, Circle plotted at given location.
    th = 0:pi/20:2*pi;
    x_circle = r * cos(th) + x;
    y_circle = r * sin(th) + y;
end
