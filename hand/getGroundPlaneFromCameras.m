% estimate up direction and center of ground plane accorindg to a set of
% cameras forming a circle parallel to ground plane
function [normal, center] = getGroundPlaneFromCameras(C, cameras_to_plane_offset, R)
% C - 3 x num_cams, camera optical centers
% R - 3 x 3 x num_cams, rotation matrices transforming coordinate system from camera to world
% cameras_to_plane_offset - scalar, distance between ground plane and camera plane

% determine a rough normal direction of plane
if exist('R', 'var')
    y_dir = mean(squeeze(R(2,:,:)), 2); % 3 x 1, mean y axis direction
    normal_init = -y_dir ./ norm(y_dir); % % 3 x 1
else
    normal_init = [0 -1 0]'; % 3 x 1
end

% get normal direction
cam_center = mean(C, 2); % 3 x 1
A = (C - cam_center)'; % num_cams x 3
[~, ~, V] = svd(A);
normal = V(:, end); % 3 x 1
if normal' * normal_init < 0, normal = -normal; end

% compute plane center location
center = cam_center - normal * cameras_to_plane_offset;

end