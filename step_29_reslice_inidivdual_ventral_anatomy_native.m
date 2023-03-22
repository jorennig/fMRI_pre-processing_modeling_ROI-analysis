clear all
close all
clc

cf = pwd;

sub = {'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR'};

for i = 1:numel(sub)

    dir_roi = [cf '/POF_nifti/' sub{i} '/ROIs_native'];

    results_dir = [cf '/POF_nifti/' sub{i} '/Results_native'];
    omnibus_mask = {fullfile(results_dir, 'Omnibus_Mask_native.nii')};

    loc_rois = dir(fullfile(dir_roi,'loc*.nii'));
    loc_rois = fullfile(dir_roi, {loc_rois(:).name}');

    ffa_rois = dir(fullfile(dir_roi,'ffa*.nii'));
    ffa_rois = fullfile(dir_roi, {ffa_rois(:).name}');

    ppa_rois = dir(fullfile(dir_roi,'ppa*.nii'));
    ppa_rois = fullfile(dir_roi, {ppa_rois(:).name}');
    
    list_images = [omnibus_mask; loc_rois; ffa_rois; ppa_rois];
    
    spm_reslice(list_images);
        
end

rois = {'rloc_anatomy_l.nii', 'rloc_anatomy_r.nii', 'rffa_anatomy_l.nii', 'rffa_anatomy_r.nii', 'rppa_anatomy_l.nii', 'rppa_anatomy_r.nii'};
thresh = 0.40;

for i = 1:numel(rois)
    
    % Load re-sliced image and binarize
    roi_c = fullfile(dir_roi, rois{i});
    roi_c_hdr = spm_vol(roi_c); % get header of image
    roi_c_img = spm_read_vols(roi_c_hdr); % read image
    
    roi_c_img(isnan(roi_c_img)) = 0;    
    roi_c_img(roi_c_img < thresh) = 0;
    roi_c_img(roi_c_img >= thresh) = 1;
    
    spm_write_vol(roi_c_hdr, roi_c_img);
    
end