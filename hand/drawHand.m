% given 3D point set of hand, draw structure of hand in 3D space, or
% given 2D reprojection point set of hand, draw it in corresponding image
function drawHand(KeyPointSet, showKpsIdx)
%   KeyPointSet - 21x2 or 21x3

    dim = size(KeyPointSet, 2); % #col KeyPointSet
    
    % draw connections
    for i = 1:5
       ind = 1 + (i-1)*4 + 1; % index of first joint of finger i
       indices = [1 ind:ind+3]; % indices of current finger (including root joint)
       if dim == 3
           line(KeyPointSet(indices, 1), KeyPointSet(indices, 2), KeyPointSet(indices, 3), 'Color', [0 150 230]/255, 'LineWidth', 3);
       elseif dim == 2
           line(KeyPointSet(indices, 1), KeyPointSet(indices, 2), 'Color', [0 150 230]/255, 'LineWidth', 2);
       end
    end
    
    hold on
    
    % draw kps
    if dim == 3
        scatter3(KeyPointSet(:,1), KeyPointSet(:,2), KeyPointSet(:,3), 500, 'r.');
        if showKpsIdx
            text(KeyPointSet(:,1), KeyPointSet(:,2), KeyPointSet(:,3), num2str((0 : 20)'));
        end
    elseif dim == 2
        scatter(KeyPointSet(:,1), KeyPointSet(:,2), 200, 'r.');
        if showKpsIdx
            text(KeyPointSet(:,1), KeyPointSet(:,2), num2str((0 : 20)'));
        end
    end
end
