function [vertices, keypoints, smpl_parameter] = read_body_recon(reconstruction_dir)
    vertices = import_vertices_keypoints([reconstruction_dir, '/smpl_vertex.txt']);
    keypoints = import_vertices_keypoints([reconstruction_dir, '/keypoints.txt']);
    smpl_parameter = import_params([reconstruction_dir, '/smpl_parameter.txt']);
end

function vertices = import_vertices_keypoints(filename)
dataLines = [1, Inf];
opts = delimitedTextImportOptions("NumVariables", 3);
opts.DataLines = dataLines;
opts.Delimiter = " ";
opts.VariableNames = ["VarName1", "VarName2", "VarName3"];
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
opts.VariableNames = "VarName1";
opts.VariableTypes = "double";
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
params = readtable(filename, opts);
params = table2array(params);
end