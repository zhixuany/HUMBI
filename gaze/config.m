subject_path = [dataset_path, '/subject_%d'];
intrinsics_path_format = [subject_path, '/gaze/intrinsic.txt'];
extrinsics_path_format = [subject_path, '/gaze/extrinsic.txt'];
img_dir_format = [subject_path, '/gaze/%08d/image_cropped'];
recon_dir_format = [subject_path, '/gaze/%08d/reconstruction'];


num_cam = 107;
cameras_to_plane_offset = 0.85; % determine where is considered as ground plane
img_size = [300, 300]; % size of cropped image, (w, h)