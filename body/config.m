subject_path = [dataset_path, '/subject_%d'];
intrinsics_path_format = [subject_path, '/body/intrinsic.txt'];
extrinsics_path_format = [subject_path, '/body/extrinsic.txt'];
img_dir_format = [subject_path, '/body/%08d/image'];
recon_dir_format = [subject_path, '/body/%08d/reconstruction'];

num_cam = 107;
cams = [0:4, 24:39, 60:68, 74:76, 86:91, 99:104];
cameras_to_plane_offset = 0.85; % determine where is considered as ground plane

% get mesh index triples for constructing triangles
tri_list = load_tri_list('./model/mesh_tri_smpl.txt');
tri_list = tri_list + 1; % 13776 x 3, change indices to start from 1 instead of 0

function meshtri = load_tri_list(filename, startRow, endRow)
if nargin<=2
    startRow = 1;
    endRow = inf;
end
formatSpec = '%24f%25f%f%[^\n\r]';
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
meshtri = [dataArray{1:end-1}];
end


