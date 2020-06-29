texture_uv_coor = load_texture_uv_coor('../face/model/text_uv_coor_sfm.txt'); % n x 2, in range [0, 1]

% left
left_eye_tri_list = load_tri_list('./model/mesh_tri_left_eye.txt');
left_eye_vertex_indices = unique(left_eye_tri_list(:));
texture_uv_coor_l = find_text_uv_coor_eye(left_eye_vertex_indices, texture_uv_coor);

% right
right_eye_tri_list = load_tri_list('./model/mesh_tri_right_eye.txt');
right_eye_vertex_indices = unique(right_eye_tri_list(:));
texture_uv_coor_r = find_text_uv_coor_eye(right_eye_vertex_indices, texture_uv_coor);

subplot(121); imshow(zeros(128, 128)); title('left'); hold on;
trimesh(left_eye_tri_list, texture_uv_coor_l(:,1), texture_uv_coor_l(:,2), 'Color', 'w');
subplot(122); imshow(zeros(128, 128)); title('right'); hold on;
trimesh(right_eye_tri_list, texture_uv_coor_r(:,1), texture_uv_coor_r(:,2), 'Color', 'w');

function text_uv_coor_eye = find_text_uv_coor_eye(eye_vertex_indices, text_uv_coor_sfm)
    uv_xmin = min(text_uv_coor_sfm(eye_vertex_indices, 1));
    uv_xmax = max(text_uv_coor_sfm(eye_vertex_indices, 1));
    uv_ymin = min(text_uv_coor_sfm(eye_vertex_indices, 2));
    uv_ymax = max(text_uv_coor_sfm(eye_vertex_indices, 2));
    text_uv_coor_eye_x = (text_uv_coor_sfm(:,1) - uv_xmin) / (uv_xmax - uv_xmin) * 128;
    text_uv_coor_eye_y = (text_uv_coor_sfm(:,2) - uv_ymin) / (uv_ymax - uv_ymin) * 128;
    text_uv_coor_eye = [text_uv_coor_eye_x, text_uv_coor_eye_y];
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

function load_texture_uv = load_texture_uv_coor(filename)
dataLines = [1, Inf];
opts = delimitedTextImportOptions("NumVariables", 2);
opts.DataLines = dataLines;
opts.Delimiter = " ";
opts.VariableNames = ["e01", "e01_1"];
opts.VariableTypes = ["double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";
opts.LeadingDelimitersRule = "ignore";
textureuvcoordinates = readtable(filename, opts);
load_texture_uv = table2array(textureuvcoordinates);
end