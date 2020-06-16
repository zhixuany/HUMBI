function [kps, headpose_R, headpose_C, gaze_target] = read_gaze_recon(reconstruction_dir)
    txt = fileread([reconstruction_dir, '/common.json']);
    gazedata = jsondecode(txt);
    kps = gazedata.face_keypoints;  % 6 x 3
    headpose_R = gazedata.headpose_R; % 3 x 3
    headpose_C = gazedata.headpose_C; % 3 x 1
    gaze_target = gazedata.gaze_target; % 3 x 1
end