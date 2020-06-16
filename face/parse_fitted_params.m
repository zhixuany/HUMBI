function [scale, R, t, shape_coefficients, expression_coefficients] = parse_fitted_params(fitted_params)
    scale = fitted_params(1);
    R = rotationVectorToMatrix(fitted_params(2:4));
    t = fitted_params(5:7);
    shape_coefficients = fitted_params(8:17);
    expression_coefficients = fitted_params(18:23);
end