function h = drawCoorSys(origin, R, length, width)
    % R - orintation of frame
    x_axis = R(:,1);
    y_axis = R(:,2);
    z_axis = R(:,3);
    
    % draw three originamera axis
    h = hggroup;
    line([origin(1) origin(1) + length*x_axis(1)], [origin(2) origin(2) + length*x_axis(2)]...
        , [origin(3) origin(3) + length*x_axis(3)], 'Color', 'r', 'LineWidth', width, 'Parent', h);
    line([origin(1) origin(1) + length*y_axis(1)], [origin(2) origin(2) + length*y_axis(2)]...
        , [origin(3) origin(3) + length*y_axis(3)], 'Color', 'g', 'LineWidth', width, 'Parent', h);
    line([origin(1) origin(1) + length*z_axis(1)], [origin(2) origin(2) + length*z_axis(2)]...
        , [origin(3) origin(3) + length*z_axis(3)], 'Color', 'b', 'LineWidth', width, 'Parent', h);
end
