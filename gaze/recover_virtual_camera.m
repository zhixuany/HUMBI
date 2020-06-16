% This function recover a virtual cameras that face towards target object
% from a certain distance by rotate and then tranlate original camera
function [vR, vC] = recover_virtual_camera(eye, headpose_Rx, cam_center, eye_loc_rel)
% eye - 3 x 1, location of the eye that virtual camera face towards
% headpose_Rx - 3 x 1, x axis direction of head pose
% cam_center - 3 x 1, optical location of original camera
% eye_loc_rel - 3 x 1, location of the eye w.r.t. virtual camera frame
vRz = eye - cam_center; vRz = vRz / norm(vRz);
vRy = cross(vRz, headpose_Rx); vRy = vRy / norm(vRy);
vRx = cross(vRy, vRz); vRx = vRx / norm(vRx);
vR = [vRx, vRy, vRz]';
vC = eye - [vRx, vRy, vRz] * eye_loc_rel;
end