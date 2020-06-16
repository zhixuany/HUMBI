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

if visCams
    if showAxis, camva(80); else camva(60); end
    campos(C(:, 33) - [0 0 1]');
else
    campos(C(:, 33));
    camva(50);
end