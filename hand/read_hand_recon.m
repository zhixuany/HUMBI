function [vertices, hand3D_fitted, mano_params] = read_hand_recon(reconstruction_dir, side)
    if strcmp(side, 'left')
        vertices = import_vertices_keypoints([reconstruction_dir, '/vertices_l.txt']);
        hand3D_fitted = import_vertices_keypoints([reconstruction_dir, '/keypoints_l.txt']);
        mano_params = import_params([reconstruction_dir, '/mano_params_l.txt']);
    elseif strcmp(side, 'right')
        vertices = import_vertices_keypoints([reconstruction_dir, '/vertices_r.txt']);
        hand3D_fitted = import_vertices_keypoints([reconstruction_dir, '/keypoints_r.txt']);
        mano_params = import_params([reconstruction_dir, '/mano_params_r.txt']);
    else
        fprintf('must be either left or right!!!\n')
    end
end

function vertices = import_vertices_keypoints(filename, dataLines)
if nargin < 2
    dataLines = [1, Inf];
end
opts = delimitedTextImportOptions("NumVariables", 3);
opts.DataLines = dataLines;
opts.Delimiter = " ";
opts.VariableNames = ["e01", "e02", "e00"];
opts.VariableTypes = ["double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";
opts.LeadingDelimitersRule = "ignore";
vertices = readtable(filename, opts);
vertices = table2array(vertices);
end

function params = import_params(filename, dataLines)
if nargin < 2
    dataLines = [1, Inf];
end
opts = delimitedTextImportOptions("NumVariables", 1);
opts.DataLines = dataLines;
opts.Delimiter = ",";
opts.VariableNames = "e00";
opts.VariableTypes = "double";
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
params = readtable(filename, opts);
params = table2array(params);
end