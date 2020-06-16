function [vertices, landmarks_fitted, fit_params] = read_face_recon(reconstruction_dir)
    vertices = import_vertices_keypoints([reconstruction_dir, '/vertices.txt']);
    landmarks_fitted = import_vertices_keypoints([reconstruction_dir, '/landmarks_fitted.txt']);
    landmarks_fitted = [landmarks_fitted(59:end, :); landmarks_fitted(1, :); ...
        landmarks_fitted(51:58, :); landmarks_fitted(2:50, :)]; % reorder
    fit_params = import_params([reconstruction_dir, '/fit_params.txt']);
end

function vertices = import_vertices_keypoints(filename)
dataLines = [1, Inf];
opts = delimitedTextImportOptions("NumVariables", 3);
opts.DataLines = dataLines;
opts.Delimiter = ",";
opts.VariableNames = ["VarName1", "VarName2", "VarName3"];
opts.VariableTypes = ["double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
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
opts.VariableNames = "VarName1";
opts.VariableTypes = "double";
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
params = readtable(filename, opts);
params = table2array(params);
end