% given 3D point set of face, draw structure of face in 3D space, or
% given 2D reprojection point set of face, draw it in corresponding image
function drawFace(KeyPointSet, showKpsIdx)
%   KeyPointSet - 66x2 or 66x3

    dim = size(KeyPointSet, 2);
    
    % 9 sets of keypoints(outlines) to be draw using line function
    sets = {0:16; 17:21; 22:26; 27:30; 31:35;... % face, eyebrows(r,l), nose(t,b)
        [36:41 36]; [42:47 42]; [48:59 48]; [48, 60:62, 54, 63:65, 48]}; % eyes(r,l), mouth(o,i)
    % notice: 0 indexed here

    % draw connections
    for i = 1:size(sets,1)
        indices = sets{i} + 1; % convert to 1-indexed
        if dim == 3
            line(KeyPointSet(indices, 1), KeyPointSet(indices, 2), KeyPointSet(indices, 3)...
                , 'Color', [0 150 230]/255, 'LineWidth', 3);
        elseif dim == 2
            line(KeyPointSet(indices, 1), KeyPointSet(indices, 2), 'Color', [0 150 230]/255, 'LineWidth', 2);
        end
    end
    
    hold on
    
    % draw kps
    if dim == 3
        scatter3(KeyPointSet(:,1), KeyPointSet(:,2), KeyPointSet(:,3), 500, 'r.');
        if showKpsIdx
            text(KeyPointSet(:,1), KeyPointSet(:,2), KeyPointSet(:,3), num2str((0 : 65)'));
        end
    elseif dim == 2
        scatter(KeyPointSet(:,1), KeyPointSet(:,2), 200, 'r.');
        if showKpsIdx
            text(KeyPointSet(:,1), KeyPointSet(:,2), num2str((0 : 65)'));
        end
    end
end


