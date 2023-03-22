clear all
close all
clc

cf = pwd;

sub = {'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR'};

%% Create individual TPJ ROI
% posterior third of the superior temporal gyrus (Freesurfer Label 11174 and 12174)
% sulcus intermedius primus (Freesurfer Label 11156, 12156)
% angular gyrus (Freesurfer Labels 11125, 12125) 
% posterior half of the supramarginal gyrus (Freesurfer Label 11126, 12126). 

for i = 1:numel(sub)

    % Read APARC
    dir_roi = [cf '/POF_nifti/' sub{i} '/ROIs_native'];
    aparc = fullfile(dir_roi, 'aparc.a2009s+aseg.nii');
    aparc_hdr = spm_vol(aparc); % get header of image
    aparc_img = spm_read_vols(aparc_hdr); % read image
    
    ag_l = double(aparc_img == 11125); % supramarginal gyrus left
    ag_r = double(aparc_img == 12125); % supramarginal gyrus right
    
    sip_l = double(aparc_img == 11156); % sulcus intermedius left
    sip_r = double(aparc_img == 12156); % sulcus intermedius left
    
    
    % ST L (superior temporal gyrus)
    st_l = double(aparc_img == 11174); % superior temporal left

    st_l_sum = sum(sum(st_l,1));
    st_l_sum = st_l_sum(:);
    st_l_sum(st_l_sum >= 1) = 1;

    third_st_l = round(sum(st_l_sum)/2);

    st_l_post = find(st_l_sum == 1);
    st_l_post = st_l_post(1);
    st_l_ant = find(st_l_sum == 1);
    st_l_ant = st_l_ant(end);

    st_l_post_third_end = st_l_post + third_st_l;

    st_l(:,:,st_l_post_third_end:st_l_ant) = 0;

    % ST R (superior temporal gyrus)
    st_r = double(aparc_img == 12174); % superior temporal right

    st_r_sum = sum(sum(st_r,1));
    st_r_sum = st_r_sum(:);
    st_r_sum(st_r_sum >= 1) = 1;

    third_st_r = round(sum(st_r_sum)/2);

    st_r_post = find(st_r_sum == 1);
    st_r_post = st_r_post(1);
    st_r_ant = find(st_r_sum == 1);
    st_r_ant = st_r_ant(end);

    st_r_post_third_end = st_r_post + third_st_r;

    st_r(:,:,st_r_post_third_end:st_r_ant) = 0;


    % SM L
    sm_l = double(aparc_img == 11126); % supramarginal gyrus left

    sm_l_sum = sum(sum(sm_l,1));
    sm_l_sum = sm_l_sum(:);
    sm_l_sum(sm_l_sum >= 1) = 1;

    half_sm_l = round(sum(sm_l_sum)/2);

    sm_l_post = find(sm_l_sum == 1);
    sm_l_post = sm_l_post(1);
    sm_l_ant = find(sm_l_sum == 1);
    sm_l_ant = sm_l_ant(end);

    sm_l_post_half_end = sm_l_post + half_sm_l;

    %sm_l(:,:,sm_l_post_half_end:sm_l_ant) = 0;

    % SM R
    sm_r = double(aparc_img == 12126); % supramarginal gyrus right

    sm_r_sum = sum(sum(sm_r,1));
    sm_r_sum = sm_r_sum(:);
    sm_r_sum(sm_r_sum >= 1) = 1;

    half_sm_r = round(sum(sm_r_sum)/2);

    sm_r_post = find(sm_r_sum == 1);
    sm_r_post = sm_r_post(1);
    sm_r_ant = find(sm_r_sum == 1);
    sm_r_ant = sm_r_ant(end);

    sm_r_post_half_end = sm_r_post + half_sm_r;

    %sm_r(:,:,sm_r_post_half_end:sm_r_ant) = 0;


    % TPJ anatomy ROI
    tpj_anatomy_l = sm_l + sip_l + ag_l + st_l;
    tpj_anatomy_l(tpj_anatomy_l < 1) = 0;
    tpj_anatomy_l(tpj_anatomy_l >= 1) = 1;

    aparc_hdr.fname = [dir_roi, filesep, 'tpj_anatomy_l.nii'];
    aparc_hdr.private.dat.fname = aparc_hdr.fname;
    spm_write_vol(aparc_hdr, tpj_anatomy_l);

    tpj_anatomy_r = sm_r + sip_r + ag_r + st_r;
    tpj_anatomy_r(tpj_anatomy_r < 1) = 0;
    tpj_anatomy_r(tpj_anatomy_r >= 1) = 1;

    aparc_hdr.fname = [dir_roi, filesep, 'tpj_anatomy_r.nii'];
    aparc_hdr.private.dat.fname = aparc_hdr.fname;
    spm_write_vol(aparc_hdr, tpj_anatomy_r);

    %% Reslice tpj anatomy
    results_dir = [cf '/POF_nifti/' sub{i} '/Results_native'];
    omnibus_mask = {fullfile(results_dir, 'Omnibus_Mask_native.nii')};

    tpj_rois = dir(fullfile(dir_roi,'tpj*.nii'));
    tpj_rois = fullfile(dir_roi, {tpj_rois(:).name}');
    
    list_images = [omnibus_mask; tpj_rois];
    
    spm_reslice(list_images);
    
    % Load re-sliced image and binarize
    tpj_roi_l = fullfile(dir_roi, 'rtpj_anatomy_l.nii');
    tpj_roi_l_hdr = spm_vol(tpj_roi_l); % get header of image
    tpj_roi_l_img = spm_read_vols(tpj_roi_l_hdr); % read image
    
    tpj_roi_l_img(isnan(tpj_roi_l_img)) = 0;
    
    thresh = 0.40;
    tpj_roi_l_img(tpj_roi_l_img < thresh) = 0;
    tpj_roi_l_img(tpj_roi_l_img >= thresh) = 1;
    
    spm_write_vol(tpj_roi_l_hdr, tpj_roi_l_img);
    
    
    tpj_roi_r = fullfile(dir_roi, 'rtpj_anatomy_r.nii');
    tpj_roi_r_hdr = spm_vol(tpj_roi_r); % get header of image
    tpj_roi_r_img = spm_read_vols(tpj_roi_r_hdr); % read image
    
    tpj_roi_r_img(isnan(tpj_roi_r_img)) = 0;
    
    tpj_roi_r_img(tpj_roi_r_img < thresh) = 0;
    tpj_roi_r_img(tpj_roi_r_img >= thresh) = 1;
    
    spm_write_vol(tpj_roi_r_hdr, tpj_roi_r_img);
    
end
