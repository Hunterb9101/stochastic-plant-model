function c = filledCircle(x,y,r,col,a)
    hold on
    th = 0:pi/50:2*pi;
    x_circle = r * cos(th) + x;
    y_circle = r * sin(th) + y;
    c = plot(x_circle, y_circle, 'Color', col, 'LineWidth', 1);
    fill(x_circle, y_circle, col, 'LineStyle', 'none', 'FaceAlpha', a);
    hold off
end
