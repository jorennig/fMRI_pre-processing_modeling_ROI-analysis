clear all
close all
clc

cf = pwd;

sub = {'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR'};

for i = 1:numel(sub)

    roi_folder = [cf '/POF_nifti/' sub{i}, filesep, 'ROIs_norm'];
    
    anatomy_l = fullfile(roi_folder, 'rwtpj_anatomy_l.nii');
    anatomy_l_hdr = spm_vol(anatomy_l); % get header of image
    anatomy_l_img = spm_read_vols(anatomy_l_hdr); % read image
   
    roi_l = fullfile(roi_folder, 'TPJ_Intact_Baseline_L.nii');
    roi_l_hdr = spm_vol(roi_l); % get header of image
    roi_l_img = spm_read_vols(roi_l_hdr); % read image
    
    anatomy_r = fullfile(roi_folder, 'rwtpj_anatomy_r.nii');
    anatomy_r_hdr = spm_vol(anatomy_r); % get header of image
    anatomy_r_img = spm_read_vols(anatomy_r_hdr); % read image
   
    roi_r = fullfile(roi_folder, 'TPJ_Intact_Baseline_R.nii');
    roi_r_hdr = spm_vol(roi_r); % get header of image
    roi_r_img = spm_read_vols(roi_r_hdr); % read image
    
    rois_bilateral_img = anatomy_l_img + roi_l_img + anatomy_r_img + roi_r_img;
    
    rois_bilateral_hdr = anatomy_l_hdr;
    rois_bilateral_hdr.fname = [roi_folder, filesep, 'TPJ_ROIs_Bilateral.nii'];
    rois_bilateral_hdr.private.dat.fname = rois_bilateral_hdr.fname;
    spm_write_vol(rois_bilateral_hdr, rois_bilateral_img);

end
