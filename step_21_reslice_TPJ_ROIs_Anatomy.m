clear all
close all
clc

sub = {'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR'};

cf = pwd;

for i = 1:numel(sub)
    
    folder_t1 = [cf, filesep, 'POF_nifti', filesep, sub{i}, filesep, 'T1/'];
    mean_t1 = {fullfile(folder_t1, 'wT1_mean.nii')};

    folder_c = [cf, filesep, 'POF_nifti', filesep, sub{i}, filesep, 'ROIs_native/'];
    
    tpj_rois = dir(fullfile(folder_c, 'wTPJ_Intact*.nii'));
    tpj_rois = {tpj_rois(:).name}';
    tpj_rois = fullfile(folder_c, tpj_rois);

    tpj_nonrois = dir(fullfile(folder_c, 'wTPJ_Non*.nii'));
    tpj_nonrois = {tpj_nonrois(:).name}';
    tpj_nonrois = fullfile(folder_c, tpj_nonrois);

    anatomy = dir(fullfile(folder_c, 'wrtpj_anatomy*.nii'));
    anatomy = {anatomy(:).name}';
    anatomy = fullfile(folder_c, anatomy);
    
    % List of images into reslice
    list_images = [mean_t1; tpj_rois; tpj_nonrois; anatomy];
    
    spm_reslice(list_images);
    
end
