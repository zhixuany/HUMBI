function h = drawPlane(n, center, S, N)
% n - 3x1, normal of plane
% center - 3x1, center of plane
% S - scalar, side length of plane
% N - the plane will have NxN grids

% compute two unit vector v1 & v2 that are parallel the target plane and
% perpendicular with each other
n = n ./ norm(n);

if isequal(n, [1 0 0]')
    v1 = [0 1 0]';
else
    v1 = [1 0 0]';
end
v1 = v1 - (v1'*n)*n;
v1 = v1/norm(v1);
v2 = cross(v1, n);

% compute side length of each grid
s = S / N;

% compute vertices coordinates
[X,Y] = meshgrid(-N/2 : N/2);
VX = center(1) + s * v1(1) * X + s * v2(1) * Y; % (N+1)x(N+1)
VY = center(2) + s * v1(2) * X + s * v2(2) * Y; % (N+1)x(N+1)
VZ = center(3) + s * v1(3) * X + s * v2(3) * Y; % (N+1)x(N+1)

% color
color1 = [1,1,1];
color2 = [0.7, 0.7, 0.7];
Color = zeros(size(VZ));
for i = 1:3
    Color(1:2:end, 1:2:end, i) = color1(i);
    Color(2:2:end, 2:2:end, i) = color1(i);
    Color(1:2:end, 2:2:end, i) = color2(i);
    Color(2:2:end, 1:2:end, i) = color2(i);
end

% plot
h = surf(VX, VY, VZ, Color, 'EdgeColor', 'none');
h.SpecularStrength = 0;
h.DiffuseStrength = 0;
h.AmbientStrength = 1;

end