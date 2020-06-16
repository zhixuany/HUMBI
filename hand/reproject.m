function rPointSet2D = reproject(PointSet3D, CameraMatrix)
%   PointSet3D - n x 3
%   CameraMatrix - 3 x 4
%   rPointSet2D - n x 2
    n = size(PointSet3D, 1);
    Rp = CameraMatrix * [PointSet3D'; ones(1, n)]; % 3 x n
    Rp = Rp(1:2, :) ./ Rp(3, :); % 2 x n
    rPointSet2D = Rp'; % n x 2
end
