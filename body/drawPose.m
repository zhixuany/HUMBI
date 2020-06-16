% given 3D point set of pose, draw structure of body pose in 3D space, or
% given 2D reprojection point set of pose, draw it in corresponding image
function drawPose(KeyPointSet, showKpsIdx)
%   KeyPointSet - 25x2 or 25x3

    dim = size(KeyPointSet, 2);
    
    % define connections to be draw using line function
    left_arm = [1 5 6 7] + 1;
    right_arm = [1 2 3 4] + 1;
    left_leg = [8 12 13 14] + 1;
    right_leg = [8 9 10 11] + 1;
    left_feet = [21 14 19 20] + 1;
    right_feet = [24 11 22 23] + 1;
    left_eye_ear = [0 16 18] + 1;
    right_eye_ear = [0 15 17] + 1;
    nose_neck = [1 0] + 1;
    torso = [8 1] + 1;
    limbs = {nose_neck, torso, left_arm, right_arm, left_leg, right_leg, left_eye_ear, right_eye_ear, left_feet, right_feet};
    Colors = {[0.3,0.3,0.3], 'black', 'red', 'blue', 'yellow', 'green', [1,0.5,0], [0.5, 0, 1], 'magenta', 'cyan'};   
    
    % draw connections
    for i = 1:length(limbs)
        if dim == 3
            line(KeyPointSet(limbs{i}, 1), KeyPointSet(limbs{i}, 2), KeyPointSet(limbs{i}, 3), 'Color', Colors{i}, 'LineWidth', 6);
        elseif dim == 2
            line(KeyPointSet(limbs{i}, 1), KeyPointSet(limbs{i}, 2), 'Color', Colors{i}, 'LineWidth', 4, 'AlignVertexCenters', 'on');
        end
    end
    
    % draw kps
    if dim == 3
        scatter3(KeyPointSet(:,1), KeyPointSet(:,2), KeyPointSet(:,3), 1200, '.', 'MarkerEdgeColor', [0.5 0.5 0.5]);
        if showKpsIdx
            text(KeyPointSet(:,1), KeyPointSet(:,2), KeyPointSet(:,3), num2str((0:24)'));
        end
    elseif dim == 2
        scatter(KeyPointSet(:,1), KeyPointSet(:,2), 200, '.', 'MarkerEdgeColor', [0.9 0.9 0.9]);
        if showKpsIdx
            text(KeyPointSet(:,1), KeyPointSet(:,2), num2str((0:24)'));
        end
    end
end
