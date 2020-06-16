# HUMBI
This repository contains official code (in MATLAB) for exploring and visualizing HUMBI dataset introduced in the paper "HUMBI: A Large Multiview Dataset of Human Body Expressions" (CVPR 2020).

You can download the data in HUMBI website: https://humbi-data.net/


## Overview
For each human body expression (gaze, face, hand, body), MATLAB code for reading data for a specified subject and time instance (refered to as "frame" in the following) is provided. There is a visualize.m file in each expression folder and you can specify some options of your choice (e.g. subject index, frame index, visualize in 3d or reprojection on images, show 3d axis or not, show keypoint indices or not, etc). The purpose of the code is to help you understand the data structure and how to use them. We will keep updating this github page to add more.


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
