clear all
close all
clc

cf = pwd;

sub = {'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR'};
save('sub.mat','sub');

step_01_meanT1;

step_02_meanSBREF;

% step_03_coreg_allImages;
% 
% step_04_norm_allImages;
% 
% step_05_smooth_norm_native_EPIs;
% 
% step_06_first_level_model;
% 
% step_07_contrast_manager;
% 
% step_08_segment_T1mean;
% 
% step_09_ominbus_mask;
% 
% step_10_individual_tpj_rois_norm;
% 
% step_11_individual_tpj_rois_norm_anatomy;
% 
% step_12_roi_analysis_marsbar_norm;
% 
% step_13_roi_analysis_marsbar_norm_anatomy;
% 
% step_17_first_level_model_MVPA_native;
