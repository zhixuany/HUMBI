function h = drawCameras(R, C, scale, cams)
    h = hggroup;
    for i = 1:size(C,2)
        Ci = C(:,i);
        Ri = R(:,:,i);
        if ~isequal(Ri, zeros(3))
            drawCamera(Ci, Ri, scale, h);
            text(Ci(1), Ci(2), Ci(3), num2str(cams(i)), 'Parent', h);
        end
    end
end