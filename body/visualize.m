dataset_path = '/home/zhixuan/data1/HUMBI/HUMBI_uploaded/Body_81_140';
subject = 82;
frame = 1;
showAxis = false; % whether show 3D axis when plotting
showKpsIdx = false; % whether plot indices of keypoints
vis3D = true; % if true, visualize 3D mesh and kps
               % if false, visualize their reprojections on image
visGroundPlane = true; % whether or not draw ground plane
visCams = true; % whether or not draw cameras
%%%%%%%%%%%% modify above lines accordingly %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
config;

% extract camera params
intrinsics_path = sprintf(intrinsics_path_format, subject);
extrinsics_path = sprintf(extrinsics_path_format, subject);
[M, C, R, ~] = extractCameraParameters(intrinsics_path, extrinsics_path, num_cam);
[ground_plane_normal, ground_plane_center] = getGroundPlaneFromCameras(C(:, 2:2:66), cameras_to_plane_offset);

% read data
reconstruction_dir = sprintf(recon_dir_format, subject, frame);
[vertices, kps, ~] = read_body_recon(reconstruction_dir);

% visualization
set(gcf, 'OuterPosition', get(0, 'Screensize')); % maximize the figure
if vis3D
    % mesh
    subplot(121); setup_vis;
    camlight('headlight'); cameratoolbar('togglescenelight');
    h = trimesh(tri_list, vertices(:,1), vertices(:,2), vertices(:,3), ...
        'FaceColor', [0 150 230]/255, 'EdgeColor', 'none', 'LineWidth', 0.1);
    h.FaceLighting = 'flat'; % or 'gouraud'
    if visGroundPlane
        drawPlane(ground_plane_normal, ground_plane_center, 2, 10);
%         material dull
    end
    if visCams
        drawCameras(R, C, 0.05);
        drawCoorSys(zeros(3, 1), eye(3), 0.5, 2);
    end
    
    % keypoints
    subplot(122); setup_vis;
    drawPose(kps, showKpsIdx);
    if visGroundPlane
        drawPlane(ground_plane_normal, ground_plane_center, 2, 10);
    end
    if visCams
        drawCameras(R, C, 0.05);
        drawCoorSys(zeros(3, 1), eye(3), 0.5, 2);
    end
    
    sgtitle(sprintf('subject %d, frame %d', subject, frame));
else
    % visualize reprojections of 3D mesh and kps on cropped image
    for cam = cams
        % compute reprojections
        rvertices = reproject(vertices, M(:, :, cam+1)); % 6890 x 2
        rkps = reproject(kps, M(:, :, cam+1)); % 25 x 2

        % draw
        img_path = sprintf([img_dir_format, '/image%07d.jpg'], subject, frame, cam);
        img = imread(img_path);
        subplot(121); cla; imshow(img); hold on
        scatter(rvertices(:,1), rvertices(:,2), 50, '.', 'MarkerEdgeColor', [0 150 230]/255, 'MarkerEdgeAlpha', 0.3);
        subplot(122); cla; imshow(img); hold on
        drawPose(rkps, showKpsIdx);
        sgtitle(sprintf('subject %d, frame %d, cam %d (press "Enter" to go to next view)', subject, frame, cam));
        pause;
    end
end


