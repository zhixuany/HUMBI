function [M, C, R, K] = extractCameraParameters(intrinsics_path, extrinsics_path, num_cam)
% intrinsics_path, extrinsics_path - absolute paths to intrinsic and extrinsic files
% num_cam - total number of possible cameras
% M - 3 x 4 x num_cam, projection matrices
% C = 3 x num_cam, camera optical centers
% R = 3 x 3 x num_cam, rotation matrices transforming coordinate system from camera to world
% K = 3 x 3 x num_cam, camera intrinsics
Intrinsic = import_cam_params(intrinsics_path);
Extrinsic = import_cam_params(extrinsics_path);

N = size(Intrinsic,1)/4; % #valid cameras
if N ~= size(Extrinsic,1)/5
    disp('camera intrinsic and extrinsic mismatach!!!\n');
    return;
end
%% extract K
K = zeros(3,3,num_cam);
index = zeros(1, N);

% check format
for i = 1:N
    j = (i-1) * 4 + 1;
    if(Intrinsic(j,1) == 0 && isnan(Intrinsic(j,3)))
        index(i) = Intrinsic(j,2);
    else
        fprintf('Intrinsic format error when i = %d!!!', i);
        return;
    end
end

% check indices
if length(unique(index)) ~= N || max(index) > num_cam-1
    disp('camera indices are not the same as expected in Intrinsic!!!\n');
    return;
end

% reorganize
for i = 1:N
    j = (i-1) * 4 + 1;
    % camera indices start from 0!
    K(:,:,index(i)+1) = Intrinsic(j+1:j+3, :);
end

%% extract R, t
R = zeros(3,3,num_cam);
C = zeros(3,num_cam);
index = zeros(1, N);

% check format
for i = 1:N
    j = (i-1) * 5 + 1;
    if(Extrinsic(j,1) == 0 && isnan(Extrinsic(j,3)))
        index(i) = Extrinsic(j,2);
    else
        fprintf('Extrinsic format error when i = %d!!!', i);
        return;
    end
end

% check indices
if length(unique(index)) ~= N || max(index) > num_cam-1
    disp('Extrinsic camera indices are not the same as expected in Extrinsic!!!\n');
    return;
end

% reorganize
for i = 1:N
    j = (i-1) * 5 + 1;
    % camera indices start from 0!
    C(:,index(i)+1) = Extrinsic(j+1, :)';
    R(:,:,index(i)+1) = Extrinsic(j+2:j+4, :);
end

%% compute M
M = zeros(3,4,num_cam);
for i = 1 : num_cam
    M(:,:,i) = K(:,:,i) * R(:,:,i) * [eye(3) -C(:,i)];
end

end

function cam_params = import_cam_params(filename, startRow, endRow)
delimiter = ' ';
if nargin<=2
    startRow = 4;
    endRow = inf;
end
formatSpec = '%f%f%f%[^\n\r]';

fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

fclose(fileID);
cam_params = [dataArray{1:end-1}];
end