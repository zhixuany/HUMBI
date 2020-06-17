# HUMBI
This repository contains official code (in MATLAB) for exploring and visualizing HUMBI dataset introduced in the paper ["HUMBI: A Large Multiview Dataset of Human Body Expressions"](http://openaccess.thecvf.com/content_CVPR_2020/html/Yu_HUMBI_A_Large_Multiview_Dataset_of_Human_Body_Expressions_CVPR_2020_paper.html) (CVPR 2020).

## Overview
HUMBI is a large multiview dataset for human body expressions with natural clothing, captured by 107 GoPro HD cameras from 772 distinctive subjects at 60Hz. During capture, each subject was invited into the capture stage and performing a series of tasks for each expression session (i.e. gaze, face, hand, body) sequentially, guided by an instructinal video (about 2.5 minutes).

HUMBI is organized in subject-session-frame-representation hierarchy, i.e. partitioned subject by subject first -> each subject contains 4 expression sessions -> each expression session contains a sequence of frames (time instances) -> each frame contains up to 4 representations: multiview images, 3D keypoints, 3D mesh and appearance maps. For data sharing, multiple subjects of a certain session are bundled together (appearance is bundled separately). You can download the data in [HUMBI website](https://humbi-data.net/).

For each human body expression session, MATLAB code for reading data of a specified subject and time instance (refered to as "frame" in the following) is provided. There is a visualize.m file in each expression folder and you can specify some options of your choice (e.g. subject index, frame index, visualize in 3d or reprojection on images, show 3d axis or not, show keypoint indices or not, etc). The purpose of the code is to help you understand the data structure and how to use them. 

We will keep updating HUMBI website and github page to add more things.

## Gaze
During gaze capture session, subject was asked to find and staring at the 4 requested number tag (with known location) posted on the camera stage one by one. We manually check offline and remove cases when subjects failed to look at requested tags.

Within "gaze" folder, there are up to 4 frames as well as "intrinsic.txt", "extrinsic.txt" and "project.txt" storing intrinsic parameters (K), extrinsic parameters (R and C) and projection matrices (M) respectively. Each frame folder contains "image_cropped" folder and "reconstruction" foler:
 - "image_cropped" folder contains cropped multiple images (300 x 300) and a "list.txt" file (each line means [cam_idx, xmin, xmax, ymin, ymax]) describing bounding boxes on original images (1980 x 1080) where they were cropped and resized.
 - "reconstruction" folder contains a "common.json" file storing global annotation common for both eyes, "left.txt"/"right.txt" storing gaze direction and headpose w.r.t. virtual cameras corresponding to left/right eyes, and "left"/"right" folder with ready-to-train normalized multiview left/right eye patches inside. Data in "reconstruction" folder are in a format similar to UT-Multiview Dataset and you may refer to this [document](https://drive.google.com/file/d/1TIGdADEO4n87slNjSG0WruZng2Ch3re8/view) (see section "3 Annotation Format").

## Face
During face capture session, subject was asked to follow 20 distinctive dynamic facial expressions (e.g., eye rolling, frowning, and jaw opening).

Within "face" folder, there are multiple frames as well as "intrinsic.txt", "extrinsic.txt" and "project.txt" storing intrinsic parameters (K), extrinsic parameters (R and C) and projection matrices (M) respectively. Each frame folder contains "image_cropped" folder and "reconstruction" foler:
 - "image_cropped" folder contains cropped multiple images (200 x 250) and "list.txt" (each line means [cam_idx, xmin, xmax, ymin, ymax]) describing bounding boxes on original images (1980 x 1080) where they were cropped and resized.
 - "reconstruction" folder contains "landmarks_fitted.txt" storing 66 face keypoints, "vertices.txt" storing 3448 face mesh vertices and "fit_params.txt" storing 23 parameters (1 for scale, 2-4 for rotation, 5-7 for translation, 8-17 for shape coefficients of first 10 components used, 18-23 for expression coefficients) that can be used to recover face mesh using [Surrey Face Model](https://cvssp.org/faceweb/3dmm/facemodels/).

## Hand
During hand capture session, subject was asked to follow a series of American sign languages (e.g., counting one to ten, greeting, and daily used words).

Within "hand" folder, there are multiple frames as well as "intrinsic.txt", "extrinsic.txt" and "project.txt" storing intrinsic parameters (K), extrinsic parameters (R and C) and projection matrices (M) respectively. Each frame folder contains "image_cropped" folder and "reconstruction" foler:
 - "image_cropped" folder contains cropped multiple images (250 x 250) and "list.txt" (each line means [cam_idx, xmin, xmax, ymin, ymax]) describing bounding boxes on original images (1980 x 1080) where they were cropped and resized. Notice that left and right hand may have different number of images, since it is possible that one hand is visible from a certain camera while the other is not .
 - "reconstruction" folder contains "keypoints_l.txt"/"keypoints_r.txt" storing 21 left/right hand keypoints, "vertices_l.txt"/"vertices_r.txt" storing 778 hand mesh vertices and "mano_params_l.txt"/"mano_params_r.txt" storing 36 parameters (1-3 for translation, 4-26 for mano pose params (first 3 for rotation, rest for 20 first components used), 27-36 for mano shape params (actually we only use first component)) that can be used to recover hand mesh using [MANO](https://mano.is.tue.mpg.de/en) hand model.

## Body
During body capture session, subject was asked to firstly follow a range of full-body movements, and then a slow and full speed dance performances curated by a professional choreographer.

Within "body" folder, there are multiple frames as well as "intrinsic.txt", "extrinsic.txt" and "project.txt" storing intrinsic parameters (K), extrinsic parameters (R and C) and projection matrices (M) respectively. Each frame folder contains "image_cropped" folder and "reconstruction" foler:
 - "image" folder contains multiple original images (1980 x 1080).
 - "reconstruction" folder contains "keypoints.txt" storing 25 body keypoints, "smpl_vertex.txt" storing 6890 body mesh vertices and "smpl_parameter.txt" storing 86 parameters (1 for scale, 2-4 for translation, 5-76 for smpl pose params, 77-86 for smpl shape params) that can be used to recover body mesh using [SMPL](https://smpl.is.tue.mpg.de/) model.

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
