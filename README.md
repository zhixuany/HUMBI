# HUMBI
This repository contains official code (in MATLAB) for exploring and visualizing HUMBI dataset introduced in the paper ["HUMBI: A Large Multiview Dataset of Human Body Expressions"](http://openaccess.thecvf.com/content_CVPR_2020/html/Yu_HUMBI_A_Large_Multiview_Dataset_of_Human_Body_Expressions_CVPR_2020_paper.html) (CVPR 2020, [spotlight video](https://www.youtube.com/watch?v=bHc0CmXRUO4)).

## Overview
HUMBI is a large multiview dataset for human body expressions with natural clothing, captured by 107 GoPro HD cameras from 772 distinctive subjects at 60Hz. During capture, each subject was invited into the capture stage and performing a series of tasks for each expression session (i.e. gaze, face, hand, body) sequentially, guided by an instructinal video (about 2.5 minutes).

HUMBI is organized in subject-session-frame-representation hierarchy, i.e. partitioned subject by subject first -> each subject contains 4 expression sessions -> each expression session contains a sequence of frames (time instances) -> each frame contains up to 4 representations: multiview images, 3D keypoints, 3D mesh and appearance(texture) maps. For data sharing, multiple subjects of a certain session are bundled together (appearance and cloth are bundled separately but expected to be merged with image/kps/mesh if you additionally download them). You can download the data in [HUMBI website](https://humbi-data.net/).

For each human body expression session, MATLAB code for reading data of a specified subject and time instance (refered to as "frame" in the following) is provided. There is a visualize.m file in each expression folder and you can specify some options of your choice (e.g. subject index, frame index, visualize in 3d or reprojection on images, show 3d axis or not, show keypoint indices or not, etc). The purpose of the code is to help you understand the data structure and how to use them. 

We will keep updating HUMBI website and github page to add more things.

## Gaze
During gaze capture session, subject was asked to find and staring at the 4 requested number tag (with known location) posted on the camera stage one by one. We manually check offline and remove cases when subjects failed to look at requested tags.

Within "gaze" folder, there are up to 4 frames as well as "intrinsic.txt", "extrinsic.txt" and "project.txt" storing intrinsic parameters (K), extrinsic parameters (R and C) and projection matrices (M) respectively (see [here](#camera-calibration)). Each frame folder contains "image_cropped" folder and "reconstruction" foler:
 - "image_cropped" folder contains cropped multiview images (300 x 300) and a "list.txt" file (each line means [cam_idx, xmin, xmax, ymin, ymax]) describing bounding boxes on original images (1920 x 1080) where they were cropped and resized.
 - "reconstruction" folder contains a "common.json" file storing global annotation common for both eyes, "left.txt"/"right.txt" storing gaze direction and headpose w.r.t. virtual cameras corresponding to left/right eyes, and "left"/"right" folder with ready-to-train normalized multiview left/right eye patches inside. Data in "reconstruction" folder are in a format similar to UT-Multiview Dataset and you may refer to this [document](https://drive.google.com/file/d/1TIGdADEO4n87slNjSG0WruZng2Ch3re8/view) (see section "3 Annotation Format"). If you additionally download textures, this folder will contains "landmarks_fitted.txt", "vertices.txt" and "fit_params.txt" with same meaning as those in [face](#face_reconstruction) (You can visualize eye meshes alongside face mesh using visualize_mesh.m).
 - "appearance" folder contains "left" and "right" folder, each of which contains view dependent texture maps (cam_\*.png) with corresponding visibility masks (cam_\*_mask.mat), merged texture maps (mean_map.png and median_map.png) and variance maps (std_map_hot.png and var_map_hot.png) for left or right eye. You can visualize the canonical uv texture coordinates and topology for eyes using visualize_uvmap.m.

## Face
During face capture session, subject was asked to follow 20 distinctive dynamic facial expressions (e.g., eye rolling, frowning, and jaw opening).

Within "face" folder, there are multiple frames as well as "intrinsic.txt", "extrinsic.txt" and "project.txt" storing intrinsic parameters (K), extrinsic parameters (R and C) and projection matrices (M) respectively (see [here](#camera-calibration)). Each frame folder contains "image_cropped" folder and "reconstruction" foler:
 - "image_cropped" folder contains cropped multiview images (200 x 250) and "list.txt" (each line means [cam_idx, xmin, xmax, ymin, ymax]) describing bounding boxes on original images (1920 x 1080) where they were cropped and resized.
 -  <span id="face_reconstruction">"reconstruction"</span> folder contains "landmarks_fitted.txt" storing 66 face keypoints, "vertices.txt" storing 3448 face mesh vertices and "fit_params.txt" storing 23 parameters (1 for scale, 2-4 for rotation, 5-7 for translation, 8-17 for shape coefficients of first 10 components used, 18-23 for expression coefficients) that can be used to recover face mesh using [Surrey Face Model](https://cvssp.org/faceweb/3dmm/facemodels/).
 - "appearance" folder contains view dependent texture maps (cam_\*.png) with corresponding visibility masks (cam_\*_mask.mat), merged texture maps (mean_map.png and median_map.png) and variance maps (std_map_hot.png and var_map_hot.png) for face. You can visualize the canonical uv texture coordinates and topology for face using visualize_uvmap.m.

## Hand
During hand capture session, subject was asked to follow a series of American sign languages (e.g., counting one to ten, greeting, and daily used words).

Within "hand" folder, there are multiple frames as well as "intrinsic.txt", "extrinsic.txt" and "project.txt" storing intrinsic parameters (K), extrinsic parameters (R and C) and projection matrices (M) respectively (see [here](#camera-calibration)). Each frame folder contains "image_cropped" folder and "reconstruction" foler:
 - "image_cropped" folder contains cropped multiview images (250 x 250) and "list.txt" (each line means [cam_idx, xmin, xmax, ymin, ymax]) describing bounding boxes on original images (1920 x 1080) where they were cropped and resized. Notice that left and right hand may have different number of images, since it is possible that one hand is visible from a certain camera while the other is not .
 - "reconstruction" folder contains "keypoints_l.txt"/"keypoints_r.txt" storing [21 hand keypoints](https://github.com/CMU-Perceptual-Computing-Lab/openpose/blob/master/doc/media/keypoints_hand.png) for left/right hand, "vertices_l.txt"/"vertices_r.txt" storing 778 hand mesh vertices and "mano_params_l.txt"/"mano_params_r.txt" storing 36 parameters (1-3 for translation, 4-26 for mano pose params (first 3 for rotation, rest for 20 first components used), 27-36 for mano shape params (actually we only use first component)) that can be used to recover hand mesh using [MANO](https://mano.is.tue.mpg.de/en) hand model.

## Body & Cloth
During body capture session, subject was asked to firstly follow a range of full-body movements, and then a slow and full speed dance performances curated by a professional choreographer.

Within "body" folder, there are multiple frames as well as "intrinsic.txt", "extrinsic.txt" and "project.txt" storing intrinsic parameters (K), extrinsic parameters (R and C) and projection matrices (M) respectively (see [here](#camera-calibration)). Each frame folder contains "image_cropped" folder and "reconstruction" foler:
 - "image" folder contains original multiview images (1920 x 1080).
 - "reconstruction" folder contains "keypoints.txt" storing [25 body keypoints](https://github.com/CMU-Perceptual-Computing-Lab/openpose/blob/master/doc/media/keypoints_pose_25.png), "smpl_vertex.txt" storing 6890 body mesh vertices and "smpl_parameter.txt" storing 86 parameters (1 for scale, 2-4 for translation, 5-76 for smpl pose params, 77-86 for smpl shape params) that can be used to recover body mesh using [SMPL](https://smpl.is.tue.mpg.de/) model. (We prepared a simple python code [hello_smpl_for_humbi.py](https://github.com/zhixuany/HUMBI/tree/master/body/hello_smpl_for_humbi.py) for this, but you need to [download the related library from official SMPL webpage](https://psfiles.is.tuebingen.mpg.de/downloads/smpl/SMPL_python_v-1-0-0-zip))
 - "reconstruction_cloth" folder contains "top_vertex.txt" storing top(clothing) mesh vertices and "bottom_vertex.txt" storing bottom(clothing) mesh vertices.
 - "appearance" folder contains view dependent texture maps (cam_\*.png) with corresponding visibility masks (cam_\*_mask.mat), merged texture maps (mean_map.png and median_map.png) and variance maps (std_map_hot.png and var_map_hot.png) for body. You can visualize the canonical uv texture coordinates and topology for body using visualize_uvmap.m.

## Camera Calibration
#### Intrinsic parameters (stored in "intrinsic.txt") format:
Numcam: (ignore)  
numframes: (number of cameras)  
numP: (number of cameras)  
(ignore) (camer_id, e.g., 4=image0000004.jpg)  
(3x3: camera intrinsic matrix)  
...iterate for each camera  

#### Extrinsic parameters (stored in "extrinsic.txt") format:
Numcam: (ignore)  
numframes: (number of cameras)  
numP: (number of cameras)  
(ignore) (camer_id, e.g., 4=image0000004.jpg)  
(1x3:camera center, where translation matrix can be obtained by T = -RC)  
(3x3: camera rotation matrix)  
...iterate for each camera  

#### Projection parameters (stored in "intrinsic.txt") format:
Numcam: (ignore)  
numframes: (number of cameras)  
numP: (number of cameras)  
(ignore) (camer_id, e.g., 4=image0000004.jpg)  
(3x4: camera projection matrix)  
...iterate for each camera  

## Citation
```bibtex
@InProceedings{Yu_2020_CVPR,
author = {Yu, Zhixuan and Yoon, Jae Shin and Lee, In Kyu and Venkatesh, Prashanth and Park, Jaesik and Yu, Jihun and Park, Hyun Soo},
title = {HUMBI: A Large Multiview Dataset of Human Body Expressions},
booktitle = {IEEE/CVF Conference on Computer Vision and Pattern Recognition (CVPR)},
month = {June},
year = {2020}
}
```
## Question?
You can send an email to: humbi.data [at] gmail [dot] com, and we will be happy to answer your questions :blush:
