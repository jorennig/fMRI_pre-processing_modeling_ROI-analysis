%clear all
close all
clc

cf = pwd;

% Read TPJ anatomy
roi_folder = [cf, filesep, 'TPJ_ROIs_Norm'];
tpj_roi_l = fullfile(roi_folder, 'tpj_anatomy_l.nii');
tpj_roi_l_hdr = spm_vol(tpj_roi_l); % get header of image
tpj_roi_l_img = spm_read_vols(tpj_roi_l_hdr); % read image

tpj_roi_r = fullfile(roi_folder, 'tpj_anatomy_r.nii');
tpj_roi_r_hdr = spm_vol(tpj_roi_r); % get header of image
tpj_roi_r_img = spm_read_vols(tpj_roi_r_hdr); % read image

t_thresh = 1.64;
n_vox = [];
for i = 1:numel(sub)
    
    % Normalized space
    results_dir_c = [cf '/POF_nifti/' sub{i}, filesep, 'Results_normalized'];
    
    % Contrast Intact vs. Baseline
    global_baseline = fullfile(results_dir_c, filesep, 'spmT_0001.nii');
    global_baseline_hdr = spm_vol(global_baseline); % get header of image
    global_baseline_img = spm_read_vols(global_baseline_hdr); % read image
    
    global_baseline_img(global_baseline_img < t_thresh) = 0;
    global_baseline_img(global_baseline_img >= t_thresh) = 1;
    
    ominbus_mask = fullfile(results_dir_c, filesep, 'Omnibus_GM_Mask_norm.nii');
    ominbus_mask_hdr = spm_vol(ominbus_mask); % get header of image
    ominbus_mask_img = spm_read_vols(ominbus_mask_hdr); % read image
    
    global_baseline_img = global_baseline_img .* ominbus_mask_img;
    
    roi_folder = [cf '/POF_nifti/' sub{i}, filesep,'ROIs_norm'];
    
    %% TPJ left
    tpj_roi_img_c = global_baseline_img .* tpj_roi_l_img;
    n_vox(i,1) = sum(sum(sum(tpj_roi_img_c)));
    
    tpj_nonroi_img_c = (tpj_roi_l_img - tpj_roi_img_c) .* ominbus_mask_img;
    n_vox(i,2) = sum(sum(sum(tpj_nonroi_img_c)));
    
    % ROI as .nii
    global_baseline_hdr.fname = [roi_folder, filesep, 'TPJ_Anatomy_Intact_Baseline_L.nii'];
    global_baseline_hdr.private.dat.fname = global_baseline_hdr.fname;
    spm_write_vol(global_baseline_hdr, tpj_roi_img_c);
    
    global_baseline_hdr.fname = [roi_folder, filesep, 'TPJ_Anatomy_NonROI_L.nii'];
    global_baseline_hdr.private.dat.fname = global_baseline_hdr.fname;
    spm_write_vol(global_baseline_hdr, tpj_nonroi_img_c);
    
    % Marsbar ROI (mat file)
    img_name = [roi_folder, filesep, 'TPJ_Anatomy_Intact_Baseline_L.nii'];
    roi_m = maroi_image(struct('vol', spm_vol(img_name), 'binarize',0, 'func', 'img'));
    saveroi(roi_m, [roi_folder, filesep, 'TPJ_Anatomy_Intact_Baseline_L_roi.mat']);
    
    img_name = [roi_folder, filesep, 'TPJ_Anatomy_NonROI_L.nii'];
    roi_m = maroi_image(struct('vol', spm_vol(img_name), 'binarize',0, 'func', 'img'));
    saveroi(roi_m, [roi_folder, filesep, 'TPJ_Anatomy_NonROI_L_roi.mat']);
    
    %% TPJ right
    tpj_roi_img_c = global_baseline_img .* tpj_roi_r_img;
    n_vox(i,3) = sum(sum(sum(tpj_roi_img_c)));

    tpj_nonroi_img_c = (tpj_roi_r_img - tpj_roi_img_c) .* ominbus_mask_img;
    n_vox(i,4) = sum(sum(sum(tpj_nonroi_img_c)));

    % ROI as .nii
    global_baseline_hdr.fname = [roi_folder, filesep, 'TPJ_Anatomy_Intact_Baseline_R.nii'];
    global_baseline_hdr.private.dat.fname = global_baseline_hdr.fname;
    spm_write_vol(global_baseline_hdr, tpj_roi_img_c);

    global_baseline_hdr.fname = [roi_folder, filesep, 'TPJ_Anatomy_NonROI_R.nii'];
    global_baseline_hdr.private.dat.fname = global_baseline_hdr.fname;
    spm_write_vol(global_baseline_hdr, tpj_nonroi_img_c);

    % Marsbar ROI (mat file)
    img_name = [roi_folder, filesep, 'TPJ_Anatomy_Intact_Baseline_R.nii'];
    roi_m = maroi_image(struct('vol', spm_vol(img_name), 'binarize',0, 'func', 'img'));
    saveroi(roi_m, [roi_folder, filesep, 'TPJ_Anatomy_Intact_Baseline_R_roi.mat']);
    
    img_name = [roi_folder, filesep, 'TPJ_Anatomy_NonROI_R.nii'];
    roi_m = maroi_image(struct('vol', spm_vol(img_name), 'binarize',0, 'func', 'img'));
    saveroi(roi_m, [roi_folder, filesep, 'TPJ_Anatomy_NonROI_R_roi.mat']);
            
end

clearvars -except sub
