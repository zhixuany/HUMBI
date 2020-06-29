dataset_path = '/home/zhixuan/data1/HUMBI/HUMBI_uploaded/Gaze_81_140';
subject = 82;
frame = 1;
showAxis = false; % whether show 3D axis when plotting
useFitParams = false; % if true, read fit params and reconstruct face vertices/kps 
                     % if false, read reconstructed face vertices/kps directly
vis3D = true; % if true, visualize 3D mesh and kps
               % if false, visualize their reprojections on image
%%%%%%%%%%%% modify above lines accordingly %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
config;
addpath('../face');
load('../face/model/model.mat', 'tri_list', 'shape_basis_3DMM', 'expression_basis_3DMM');
left_eye_tri_list = load_tri_list('./model/mesh_tri_left_eye.txt');
right_eye_tri_list = load_tri_list('./model/mesh_tri_right_eye.txt');
left_eye_vertex_indices = unique(left_eye_tri_list(:));
right_eye_vertex_indices = unique(right_eye_tri_list(:));

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
    vertices = reconstruct_face_fitted(meanface_3DMM, shape_basis_3DMM(:, 1:10), expression_basis_3DMM, ...
        shape_coefficients, expression_coefficients, scale, R, t);
else
    [vertices, ~, ~] = read_face_recon(reconstruction_dir);
end

% visualization
set(gcf, 'OuterPosition', get(0, 'Screensize')); % maximize the figure
if vis3D  % visualize 3D mesh and kps
    setup_vis; campos(C(:, 33)); camva(7); camlight('left');
    h = trimesh(tri_list+1, vertices(:,1), vertices(:,2), vertices(:,3), ...
        'FaceColor', [0 150 230]/255, 'EdgeColor', 'none', 'LineWidth', 0.1);
    h.FaceLighting = 'flat'; % or 'gouraud'
    hl = trimesh(left_eye_tri_list, vertices(:,1), vertices(:,2), vertices(:,3), ...
        'FaceColor', 'r', 'EdgeColor', 'none', 'LineWidth', 0.1);
    hl.FaceLighting = 'flat'; % or 'gouraud'
    hr = trimesh(right_eye_tri_list, vertices(:,1), vertices(:,2), vertices(:,3), ...
        'FaceColor', 'r', 'EdgeColor', 'none', 'LineWidth', 0.1);
    hr.FaceLighting = 'flat'; % or 'gouraud'
    title(sprintf('subject %d, frame %d', subject, frame));
else
    bboxes = readmatrix([sprintf(img_dir_format, subject, frame), '/list.txt']); % n x 5, bboxes on original image
    for i = 1:size(bboxes, 1)
        % compute reprojections
        cam = bboxes(i, 1);
        bbox = bboxes(i, 2:end); % 1 x 4, [xmin, xmax, ymin, ymax]
        scale_x = (bbox(2) - bbox(1) + 1) / img_size(1);
        scale_y = (bbox(4) - bbox(3) + 1) / img_size(2);
        % Notice: scale_x and scale_y may not be exactly the same but should be very close
        rvertices = reproject(vertices, M(:, :, cam+1)); % 3448 x 2
        rvertices = (rvertices - [bbox(1), bbox(3)]) ./ [scale_x, scale_y];
        rvertices = rvertices([left_eye_vertex_indices, right_eye_vertex_indices], :);

        % draw
        img_path = sprintf([img_dir_format, '/image%07d.png'], subject, frame, cam);
        img = imread(img_path);
        imshow(img); hold on
        scatter(rvertices(:,1), rvertices(:,2), 100, '.', 'MarkerEdgeColor', 'r', 'MarkerEdgeAlpha', 0.5);
        title(sprintf('subject %d, frame %d, cam %d (press "Enter" to go to next view)', subject, frame, cam));
        pause;
    end
end


function tri_list = load_tri_list(filename, startRow, endRow)
if nargin<=2
    startRow = 1;
    endRow = inf;
end
formatSpec = '%16f%16f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end
fclose(fileID);
tri_list = [dataArray{1:end-1}];
end
