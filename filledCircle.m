function c = filledCircle(x,y,r,col,a)
    % FILLEDCIRCLE: Plots a filled circle at (x,y), with radius r, color
    % `col`, and alpha (transparency) a.
    % Returns: Line, Filled circle plotted at given parameters. 
    hold on
    th = 0:pi/20:2*pi;
    x_circle = r * cos(th) + x;
    y_circle = r * sin(th) + y;
    c = plot(x_circle, y_circle, 'Color', col, 'LineWidth', 1);
    fill(x_circle, y_circle, col, 'LineStyle', 'none', 'FaceAlpha', a);
    hold off
end
