% reconstruct face mesh or keypoints according to fitted parameters
function [face_fitted] = reconstruct_face_fitted(meanface_v, shape_basis...
    , expression_basis, shape_coefficients, expression_coefficients, scale, R, t)
    
    % recover shape and expression
    face_fitted_canonical_v = meanface_v + shape_basis * shape_coefficients...
        + expression_basis * expression_coefficients; % 10344/198 x 1 (x1,y1,z1,....)
    
    % recover scale, rotation and orientation
    face_fitted = (R * scale * reshape(face_fitted_canonical_v, 3, []) + t)'; % 3448/66 x 3
    
    % reorder kps
    if size(face_fitted, 1) == 66
        face_fitted = [face_fitted(59:end, :); face_fitted(1, :); ...
        face_fitted(51:58, :); face_fitted(2:50, :)];
    end
end