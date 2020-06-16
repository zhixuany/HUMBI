subject_path = [dataset_path, '/subject_%d'];
intrinsics_path_format = [subject_path, '/hand/intrinsic.txt'];
extrinsics_path_format = [subject_path, '/hand/extrinsic.txt'];
recon_dir_format = [subject_path, '/hand/%08d/reconstruction'];

num_cam = 107;
cameras_to_plane_offset = 0.85; % determine where is considered as ground plane
img_size = [250, 250]; % size of cropped image, (w, h)

% get mesh index triples for constructing triangles
if strcmp(side, 'left')
    img_dir_format = [subject_path, '/hand/%08d/image_cropped/left'];
    load('./model/MANO_LEFT.mat');
    tri_list = MANO_LEFT.f + 1; % 1538 x 3, change indices to start from 1 instead of 0
elseif strcmp(side, 'right')
    img_dir_format = [subject_path, '/hand/%08d/image_cropped/right'];
    load('./model/MANO_RIGHT.mat');
    tri_list = MANO_RIGHT.f + 1; % 1538 x 3, change indices to start from 1 instead of 0
else
    error('side must be either left or right');
end
% num_frames = 290;
