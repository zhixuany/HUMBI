[texture_uv_coor, tri_list_uv, ~, ~] = read_obj('./model/text_uv_coor_smpl.obj'); % n x 2, in range (0, 1)
texture_uv_coor(:, 2) = 1 - texture_uv_coor(:, 2);
texture_uv_coor = texture_uv_coor * 1024;
imshow(zeros(1024, 1024)); hold on;
trimesh(tri_list_uv, texture_uv_coor(:,1), texture_uv_coor(:,2), 'Color', 'w');

function [texture_uv_coor, tri_list_uv, vertices, tri_list_vertex] = read_obj(path)
file = fopen(path, 'r');
for i = 1:4, fgetl(file); end
temp = textscan(file, '%s %f %f %f', 6890);
vertices = [temp{2} temp{3} temp{4}];
temp = textscan(file, '%s %f %f', 7576);
texture_uv_coor = [temp{2} temp{3}];
for i = 1:6893, fgetl(file); end
temp = textscan(file, '%s %d %d %d %d %d %d %d %d %d', 13776, 'Delimiter', [' ', '/']);
tri_list_vertex = [temp{2} temp{5} temp{8}];
tri_list_uv = [temp{3} temp{6} temp{9}];
end
