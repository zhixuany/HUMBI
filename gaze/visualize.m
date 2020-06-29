dataset_path = '/home/zhixuan/data1/HUMBI/HUMBI_uploaded/Gaze_81_140';
subject = 82;
frame = 1;
showAxis = false; % whether show 3D axis when plotting
vis3D = true; % if true, visualize 3D mesh and kps
               % if false, visualize their reprojections on image
%%%%%%%%%%%% modify above lines accordingly %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
config;

% extract camera params
intrinsics_path = sprintf(intrinsics_path_format, subject);
extrinsics_path = sprintf(extrinsics_path_format, subject);
[M, C, R, ~] = extractCameraParameters(intrinsics_path, extrinsics_path, num_cam);
[ground_plane_normal, ground_plane_center] = getGroundPlaneFromCameras(C(:, 2:2:66), cameras_to_plane_offset);

% read global data
reconstruction_dir = sprintf(recon_dir_format, subject, frame);
[kps, headpose_R, headpose_C, gaze_target] = read_gaze_recon(reconstruction_dir);
right_eye = mean(kps(1:2, :))';  % 3 x 1
left_eye = mean(kps(3:4, :))';  % 3 x 1
mouth = mean(kps(5:6, :))';  % 3 x 1
gaze_direction = (gaze_target - headpose_C) / norm(gaze_target - headpose_C);

set(gcf, 'OuterPosition', get(0, 'Screensize')); % maximize the figure
if vis3D
    % read per view data
    cams = read_valid_views([reconstruction_dir, '/left.txt']);
    cams_ = read_valid_views([reconstruction_dir, '/right.txt']);
    assert(isequal(cams, cams_), 'valid views for left and right eye should be the same!');
    gazedata_l = read_per_view_data([reconstruction_dir, '/left.txt']);
    gazedata_r = read_per_view_data([reconstruction_dir, '/right.txt']);
    assert(isequal(size(gazedata_l), [length(cams), 9]) && isequal(size(gazedata_r), [length(cams), 9]));
    vR_l = zeros(3, 3, length(cams)); vC_l = zeros(3, length(cams)); % to store extrinsics of virtual cameras corresponding to left eye
    vR_r = zeros(3, 3, length(cams)); vC_r = zeros(3, length(cams)); % to store extrinsics of virtual cameras corresponding to right eye
    for i = 1:length(cams)
        cam = cams(i);
        [vR_l_i, vC_l_i] = recover_virtual_camera(left_eye, headpose_R(:, 1), C(:, cam+1), gazedata_l(i, 7:9)');
        vR_l(:, :, i) = vR_l_i; vC_l(:, i) = vC_l_i;
        [vR_r_i, vC_r_i] = recover_virtual_camera(right_eye, headpose_R(:, 1), C(:, cam+1), gazedata_r(i, 7:9)');
        vR_r(:, :, i) = vR_r_i; vC_r(:, i) = vC_r_i;
    end

    % visualization
    set(gcf, 'OuterPosition', get(0, 'Screensize')); % maximize the figure
    setup_vis;
    drawCoorSys(headpose_C, headpose_R, 0.05, 3);
    scatter3(kps(:,1), kps(:,2), kps(:,3), 'kx');
    patch(mean(reshape(kps(:,1), 2, 3)), mean(reshape(kps(:,2), 2, 3))...
        , mean(reshape(kps(:,3), 2, 3)), 'yellow', 'EdgeAlpha', 0);
    drawCameras(R(:, :, cams+1), C(:, cams+1), 0.03, cams);
    scatter3(gaze_target(1), gaze_target(2), gaze_target(3), 100, 'o', ...
        'LineWidth', 0.5, 'MarkerFaceColor','red', 'MarkerEdgeColor', 'none');
    drawArrow3D(headpose_C, headpose_C + 2.5 * gaze_direction, ...
            'color', [0.8, 0.8, 0], 'stemWidth', 0.003);  % draw reconstruted gaze direction w.r.t this eye (should intersec with gaze_target)

    for i = 1:length(cams)
        cam = cams(i);
        sgtitle(sprintf('subject %d, frame %d, cam %d', subject, frame, cam));

        % for left eye
        gaze_l = gazedata_l(i, 1:3)';  % unit vector represent gaze direction w.r.t. corresponding camera frame
        rot_l = rotationVectorToMatrix(gazedata_r(i, 4:6)');  % rotation that rotate head frame to correspondin camera frame (inverse of head pose orientation w.r.t camera)
        h_cam_l = drawCamera(vC_l(:, i), vR_l(:, :, i), 0.02); % virtual camera corresponding to this eye
        h_txt_l = text(vC_l(1, i), vC_l(2, i), vC_l(3, i), num2str(cam));
        h_dash_l = plot3([C(1, cam+1), left_eye(1)], [C(2, cam+1), left_eye(2)], [C(3, cam+1), left_eye(3)], ...
            'k--', 'LineWidth', 1);  % dash line connecting pair of real and virtual cam and corresponding eye
        h_arrow_l = drawArrow3D(left_eye, left_eye + 2.5 * vR_l(:,:,i)' * gaze_l, ...
            'color', [0, 0.8, 0.8], 'stemWidth', 0.002);  % draw reconstruted gaze direction w.r.t this eye (should intersect with gaze_target)
        h_frame_l = drawCoorSys(left_eye, vR_l(:,:,i)' * rot_l', 0.03, 1);  % draw reconstruted head frame sit on this eye (should align with global head frame)

        % for right eye
        gaze_r = gazedata_r(i, 1:3)';  % unit vector represent gaze direction w.r.t. corresponding camera frame
        rot_r = rotationVectorToMatrix(gazedata_r(i, 4:6)');  % rotation that rotate head frame to correspondin camera frame (inverse of head pose orientation w.r.t camera)
        h_cam_r = drawCamera(vC_r(:, i), vR_r(:, :, i), 0.02); % virtual camera corresponding to this eye
        h_txt_r = text(vC_r(1, i), vC_r(2, i), vC_r(3, i), num2str(cam));
        h_dash_r = plot3([C(1, cam+1), right_eye(1)], [C(2, cam+1), right_eye(2)], [C(3, cam+1), right_eye(3)], ...
            'k--', 'LineWidth', 1);  % dash line connecting pair of real and virtual cam and corresponding eye
        h_arrow_r = drawArrow3D(right_eye, right_eye + 2.5 * vR_r(:,:,i)' * gaze_r, ...
            'color', [0, 0.8, 0.8], 'stemWidth', 0.002);  % draw reconstruted gaze direction w.r.t this eye (should intersec with gaze_target)
        h_frame_r = drawCoorSys(right_eye, vR_r(:,:,i)' * rot_r', 0.03, 1);  % draw reconstruted head frame sit on this eye (should align with global head frame)

        pause;
        delete(h_cam_l); delete(h_txt_l); delete(h_dash_l); delete(h_arrow_l); delete(h_frame_l);
        delete(h_cam_r); delete(h_txt_r); delete(h_dash_r); delete(h_arrow_r); delete(h_frame_r);
    end
else
    bboxes = readmatrix([sprintf(img_dir_format, subject, frame), '/list.txt']); % n x 5, bboxes on original image
    for i = 1:size(bboxes, 1)
        % compute reprojections
        cam = bboxes(i, 1);
        bbox = bboxes(i, 2:end); % 1 x 4, [xmin, xmax, ymin, ymax]
        scale_x = (bbox(2) - bbox(1) + 1) / img_size(1);
        scale_y = (bbox(4) - bbox(3) + 1) / img_size(2);
        % Notice: scale_x and scale_y may not be exactly the same but should be very close
        rkps = reproject(kps, M(:, :, cam+1)); % 6 x 2
        rkps = (rkps - [bbox(1), bbox(3)]) ./ [scale_x, scale_y];
        rheadpose_C = reproject(headpose_C', M(:, :, cam+1)); % 1 x 2
        rheadpose_C = (rheadpose_C - [bbox(1), bbox(3)]) ./ [scale_x, scale_y];
        rgaze_target = reproject(gaze_target', M(:, :, cam+1)); % 1 x 3
        rgaze_target = (rgaze_target - [bbox(1), bbox(3)]) ./ [scale_x, scale_y];
        gaze_dir = (rgaze_target - rheadpose_C) / norm(rgaze_target - rheadpose_C); % 1 x 2
        
        % draw
        img_path = sprintf([img_dir_format, '/image%07d.png'], subject, frame, cam);
        img = imread(img_path);
        img_l = imread([reconstruction_dir, sprintf('/left/image%07d.jpg', cam)]);
        img_r = imread([reconstruction_dir, sprintf('/right/image%07d.jpg', cam)]);
        subplot(121); imshow(img); title('reprojection of face keypoints and gaze direction'); hold on
        scatter(rkps(:,1), rkps(:,2), 200, 'rx');
        quiver(rheadpose_C(1), rheadpose_C(2), gaze_dir(1)*80, ... % gaze
                gaze_dir(2)*80, 'MaxHeadSize', 5, 'LineWidth', 3, 'Color', 'y');
        subplot(122); imshow([img_r, img_l]); title('normalized eye patches (right, left)');
        sgtitle(sprintf('subject %d, frame %d, cam %d (press "Enter" to go to next view)', subject, frame, cam));
        pause;
    end
end


function cams = read_valid_views(filename)
    dataLines = [2, Inf]; % read from second line
    opts = delimitedTextImportOptions("NumVariables", 10);
    opts.DataLines = dataLines;
    opts.Delimiter = " ";
    opts.VariableNames = ["VarName1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10"];
    opts.SelectedVariableNames = "VarName1";
    opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "string", "string", "string", "string"];
    opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], "EmptyFieldRule", "auto");
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    opts.ConsecutiveDelimitersRule = "join";
    opts.LeadingDelimitersRule = "ignore";
    left = readtable(filename, opts);
    img_list = table2array(left);
    cams = nan(1, length(img_list));
    for i = 1:length(cams)
        img_path = char(img_list(i));
        cams(i) = str2double(img_path(end-6:end-4));
    end
end

function left = read_per_view_data(filename)
    dataLines = [2, Inf]; % read from second line
    opts = delimitedTextImportOptions("NumVariables", 10);
    opts.DataLines = dataLines;
    opts.Delimiter = " ";
    opts.VariableNames = ["Var1", "image_path", "gaze_x", "gaze_y", "gaze_z", "headpose_rx", "headpose_ry", "headpose_rz", "headpose_tx", "headpose_ty"];
    opts.SelectedVariableNames = ["image_path", "gaze_x", "gaze_y", "gaze_z", "headpose_rx", "headpose_ry", "headpose_rz", "headpose_tx", "headpose_ty"];
    opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
    opts = setvaropts(opts, 1, "WhitespaceRule", "preserve");
    opts = setvaropts(opts, 1, "EmptyFieldRule", "auto");
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    opts.ConsecutiveDelimitersRule = "join";
    opts.LeadingDelimitersRule = "ignore";
    left = readtable(filename, opts);
    left = table2array(left);
end

