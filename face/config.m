subject_path = [dataset_path, '/subject_%d'];
intrinsics_path_format = [subject_path, '/face/intrinsic.txt'];
extrinsics_path_format = [subject_path, '/face/extrinsic.txt'];
img_dir_format = [subject_path, '/face/%08d/image_cropped'];
recon_dir_format = [subject_path, '/face/%08d/reconstruction'];

num_cam = 107;
cameras_to_plane_offset = 0.85; % determine where is considered as ground plane
img_size = [200, 250]; % size of cropped image, (w, h)

load('./model/model.mat'); % load following variables:
% meanface - 84 x 3
% meanface_inner - 50 x 3
% Basel_vertex_indices - 1 x 3448
% shape_basis_84 - 252 x 63
% expression_basis_84 - 252 x 6,
% shape_basis_3DMM - 10344 x 63
% expression_basis_3DMM - 10344 x 6
% meanface_3Dmm - 10344 X 1
% tri_list - 6736 x 3

inner_kps_indices = 1:50;
left_contour_kps_indices = [67 65 64 62 61 59 56 53];
right_contour_kps_indices = [70 73 76 77 79 81 82 83];

% get 66 landmarks of meanface (50 inner kps + 16 contour kps)
meanface_contour_left_8 = meanface(left_contour_kps_indices, :); % 8 x 3
meanface_contour_right_8 = meanface(right_contour_kps_indices, :); % 8 x 3
meanface_66 = [meanface_inner; meanface_contour_left_8; meanface_contour_right_8]; % 66 x 3
meanface_v = reshape(meanface_66', [], 1);  % 198 x 1 (x1,y1,z1,....)

% get shape and expression basis for 66 landmarks
valid_landmark_indices = [ inner_kps_indices, left_contour_kps_indices, ...
    right_contour_kps_indices]; % 1 x 66 indices of 84 landmarks to be used for pca fitting
valid_landmark_indices_ = reshape([3 * valid_landmark_indices - 2; ...
    3 * valid_landmark_indices - 1; 3 * valid_landmark_indices], [], 1); % 198 x 1
shape_basis_66 = shape_basis_84(valid_landmark_indices_, :); % 198 x 63
expression_basis_66 = expression_basis_84(valid_landmark_indices_, :); % 198 x 6

% get used shape and expression basis
num_used_shapePC = 10;
num_used_expressionPC = 6;
shape_basis_66 = shape_basis_66(:, 1:num_used_shapePC);
expression_basis_66 = expression_basis_66(:, 1:num_used_expressionPC);
shape_basis_3DMM = shape_basis_3DMM(:, 1:num_used_shapePC);
expression_basis_3DMM = expression_basis_3DMM(:, 1:num_used_expressionPC);

% get mesh index triples for constructing triangles
tri_list = tri_list + 1; % change indices to start from 1 instead of 0




