% Set up axis and view

% Axis
ax = gca;
axis equal;
ax.NextPlot = 'add';
ax.Clipping = 'off';
ax.Box = 'off';
xlabel('X'); ylabel('Y'); zlabel('Z');
grid off;
if ~showAxis
	axis off;
end

% View
cameratoolbar('Show') % show camera toolbar
cameratoolbar('SetCoordSys', 'y')
camup(ground_plane_normal);
campos(C(:, 33));
camva(5);
