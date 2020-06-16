function h = drawCameras(R, C, scale)
    h = hggroup;
    for i = 1:size(C,2)
        Ci = C(:,i);
        Ri = R(:,:,i);
        if ~isequal(Ri, zeros(3))
            drawCamera(Ci, Ri, scale, h);
            text(Ci(1), Ci(2), Ci(3), num2str(i-1), 'Parent', h);
        end
    end
end

function h = drawCamera(C, R, windowScale, handle)
h = hggroup;
% windowScale - scalar, specify the distance between optical center to
% camera frontal face; equal to half of frontal face side length

assert(isequal(size(C), [3,1]), 'size of C must be 3x1!');

window11 = windowScale*[1; 1; 1];
window12 = windowScale*[-1; 1; 1];
window21 = windowScale*[-1;-1;1];
window22 = windowScale*[1; -1; 1];
windowPrime11 = R'*window11+C;
windowPrime12 = R'*window12+C;
windowPrime21 = R'*window21+C;
windowPrime22 = R'*window22+C;
AxisEndPoints = C + windowScale * R'; % 3x3, each column is an endpoint coordinates of each axis
windowVertices = [windowPrime11 windowPrime12 windowPrime22 windowPrime21]; % 3x4, each column is a vertex coornidates of the camera window

% draw three camera axis
line([C(1) AxisEndPoints(1,1)], [C(2) AxisEndPoints(2,1)], [C(3) AxisEndPoints(3,1)], 'Color', 'r', 'LineWidth', 1, 'Parent', h);
line([C(1) AxisEndPoints(1,2)], [C(2) AxisEndPoints(2,2)], [C(3) AxisEndPoints(3,2)], 'Color', 'g', 'LineWidth', 1, 'Parent', h);
line([C(1) AxisEndPoints(1,3)], [C(2) AxisEndPoints(2,3)], [C(3) AxisEndPoints(3,3)], 'Color', 'b', 'LineWidth', 1, 'Parent', h);

% draw square window
line([windowPrime11(1), windowPrime12(1), windowPrime21(1), windowPrime22(1), windowPrime11(1)],...
    [windowPrime11(2), windowPrime12(2), windowPrime21(2), windowPrime22(2), windowPrime11(2)], ...
    [windowPrime11(3), windowPrime12(3), windowPrime21(3), windowPrime22(3), windowPrime11(3)], 'Color', [0.5 0.5 0.5], 'Parent', h);
% draw lines connecting camera center to four vertices of the square window
line([windowPrime11(1) C(1)], [windowPrime11(2) C(2)], [windowPrime11(3) C(3)], 'Color', [0.5 0.5 0.5], 'Parent', h);
line([windowPrime12(1) C(1)], [windowPrime12(2) C(2)], [windowPrime12(3) C(3)], 'Color', [0.5 0.5 0.5], 'Parent', h);
line([windowPrime22(1) C(1)], [windowPrime22(2) C(2)], [windowPrime22(3) C(3)], 'Color', [0.5 0.5 0.5], 'Parent', h);
line([windowPrime21(1) C(1)], [windowPrime21(2) C(2)], [windowPrime21(3) C(3)], 'Color', [0.5 0.5 0.5], 'Parent', h);

if exist('handle', 'var')
    h.Parent = handle;
end

end