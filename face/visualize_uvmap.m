load('./model/model.mat', 'tri_list');
texture_uv_coor = load_texture_uv_coor('./model/text_uv_coor_sfm.txt'); % n x 2, in range [0, 1]
texture_uv_coor = texture_uv_coor * 1024;
imshow(zeros(1024, 1024)); hold on;
trimesh(tri_list+1, texture_uv_coor(:,1), texture_uv_coor(:,2), 'Color', 'w');

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