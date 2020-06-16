dataset_path = '/home/zhixuan/data1/HUMBI/HUMBI_uploaded/Face_81_140';
subject = 82;
frame = 1;
showAxis = false; % whether show 3D axis when plotting
showKpsIdx = false; % whether plot indices of keypoints
useFitParams = false; % if true, read fit params and reconstruct face vertices/kps 
                     % if false, read reconstructed face vertices/kps directly
vis3D = true; % if true, visualize 3D mesh and kps
               % if false, visualize their reprojections on image
%%%%%%%%%%%% modify above lines accordingly %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
config;

% extract camera params
intrinsics_path = sprintf(intrinsics_path_format, subject);
extrinsics_path = sprintf(extrinsics_path_format, subject);
[M, C, ~, ~] = extractCameraParameters(intrinsics_path, extrinsics_path, num_cam);
[ground_plane_normal, ground_plane_center] = getGroundPlaneFromCameras(C(:, 2:2:66), cameras_to_plane_offset);

% read data
reconstruction_dir = sprintf(recon_dir_format, subject, frame);
if useFitParams
    [~, ~, fitted_params] = read_face_recon(reconstruction_dir);
    [scale, R, t, shape_coefficients, expression_coefficients] = parse_fitted_params(fitted_params);
    vertices_ = reconstruct_face_fitted(meanface_3DMM, shape_basis_3DMM, expression_basis_3DMM, ...
        shape_coefficients, expression_coefficients, scale, R, t);
    kps_ = reconstruct_face_fitted(meanface_v, shape_basis_66, expression_basis_66, ...
        shape_coefficients, expression_coefficients, scale, R, t);
else
    [vertices, kps, ~] = read_face_recon(reconstruction_dir);
end

% visualization
set(gcf, 'OuterPosition', get(0, 'Screensize')); % maximize the figure
if vis3D  % visualize 3D mesh and kps
    subplot(121); setup_vis; camlight('left');
    h = trimesh(tri_list, vertices(:,1), vertices(:,2), vertices(:,3), ...
        'FaceColor', [0 150 230]/255, 'EdgeColor', 'none', 'LineWidth', 0.1);
    h.FaceLighting = 'flat'; % or 'gouraud'
    subplot(122); setup_vis;
    drawFace(kps, showKpsIdx);
    sgtitle(sprintf('subject %d, frame %d', subject, frame));
else  % visualize reprojections of 3D mesh and kps on cropped image
    bboxes = readmatrix([sprintf(img_dir_format, subject, frame), '/list.txt']); % n x 5, bboxes on original image
    for i = 1:size(bboxes, 1)
        % compute reprojections
        cam = bboxes(i, 1);
        bbox = bboxes(i, 2:end); % 1 x 4, [xmin, xmax, ymin, ymax]
        scale_x = (bbox(2) - bbox(1) + 1) / img_size(1); % since cropped image width is 200
        scale_y = (bbox(4) - bbox(3) + 1) / img_size(2); % since cropped image height is 250
        % Notice: scale_x and scale_y may not be exactly the same but should be very close
        rvertices = reproject(vertices, M(:, :, cam+1)); % 3448 x 2
        rvertices = (rvertices - [bbox(1), bbox(3)]) ./ [scale_x, scale_y];
        rkps = reproject(kps, M(:, :, cam+1)); % 66 x 2
        rkps = (rkps - [bbox(1), bbox(3)]) ./ [scale_x, scale_y];
        
        % draw
        img_path = sprintf([img_dir_format, '/image%07d.png'], subject, frame, cam);
        img = imread(img_path);
        subplot(121); imshow(img); hold on
        scatter(rvertices(:,1), rvertices(:,2), 100, '.', 'MarkerEdgeColor', [0 150 230]/255, 'MarkerEdgeAlpha', 0.5);
        subplot(122); imshow(img); hold on
        drawFace(rkps, showKpsIdx);
        sgtitle(sprintf('subject %d, frame %d, cam %d (press "Enter" to go to next view)', subject, frame, cam));
        pause;
    end
end







