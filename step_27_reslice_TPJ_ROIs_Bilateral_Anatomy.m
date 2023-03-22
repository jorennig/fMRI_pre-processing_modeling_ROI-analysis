clear all
close all
clc

sub = {'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR'};

cf = pwd;

for i = 1:numel(sub)

    roi_folder = [cf '/POF_nifti/' sub{i}, filesep, 'ROIs_norm'];

    mean_t1 = {fullfile(roi_folder, 'wT1_mean.nii')};
    
    tpj_rois = {fullfile(roi_folder, 'TPJ_ROIs_Bilateral.nii')};
    
    % List of images into reslice
    list_images = [mean_t1; tpj_rois];
    
    spm_reslice(list_images);
    
end
