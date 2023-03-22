%clear all
close all
clc

cf = pwd;

thresh_gm = 0.6;
thresh_f = 1.65;

for i = 1:numel(sub)
    
    %% Native space
    % Contrast image
    results_dir_c = [cf '/POF_nifti/' sub{i}, filesep, 'Results_native'];
    
    omnibus_con = dir(fullfile(results_dir_c, 'spmF_0012.nii'));
    omnibus_con = char(fullfile(results_dir_c, {omnibus_con(:).name}));
    con_hdr = spm_vol(omnibus_con); % get header of image
    con_img = spm_read_vols(con_hdr); % read image
    
    con_img(isnan(con_img)) = 0;
    con_img(con_img < thresh_f) = 0;
    con_img(con_img >= thresh_f) = 1;
        
    con_hdr.fname = [results_dir_c, filesep, 'Omnibus_Mask_native.nii'];
    con_hdr.private.dat.fname = con_hdr.fname;
    spm_write_vol(con_hdr, con_img);
    
    
    % Gray matter
    t1_dir_c = [cf '/POF_nifti/' sub{i}, filesep, 'T1'];
    
    gray_matter = dir(fullfile(t1_dir_c, 'c1T1_mean.nii'));
    gray_matter = char(fullfile(t1_dir_c, {gray_matter(:).name}));
    gray_matter_hdr = spm_vol(gray_matter); % get header of image    
    gray_matter_img = spm_read_vols(gray_matter_hdr); % read image
    
    gray_matter_img(gray_matter_img >= thresh_gm) = 1; 
    gray_matter_img(gray_matter_img < thresh_gm) = 0; 
    
    gray_matter_hdr.fname = [t1_dir_c, filesep, 'Gray_Matter_native_thresh.nii'];
    gray_matter_hdr.private.dat.fname = gray_matter_hdr.fname;
    spm_write_vol(gray_matter_hdr, gray_matter_img);
    
    % Reslice gray matter onto omnibus mask
    gray_matter = fullfile(t1_dir_c, 'Gray_Matter_native_thresh.nii');
    omnibus_mask = fullfile(results_dir_c, 'Omnibus_Mask_native.nii');

    list_images = {omnibus_mask; gray_matter};
    spm_reslice(list_images);
    
    % Read resliced gray matter
    gray_matter = fullfile(t1_dir_c, 'rGray_Matter_native_thresh.nii');
    gray_matter_hdr = spm_vol(gray_matter); % get header of image
    gray_matter_img = spm_read_vols(gray_matter_hdr); % read image
    gray_matter_img(gray_matter_img >= 0.8) = 1;
    gray_matter_img(gray_matter_img < 0.8) = 0;
    
    % Mask omnibus mask with gray matter mask
    omnibus_gm = con_img .* gray_matter_img;
    
    con_hdr.fname = [results_dir_c, filesep, 'Omnibus_GM_Mask_native.nii'];
    con_hdr.private.dat.fname = con_hdr.fname;
    spm_write_vol(con_hdr, omnibus_gm);

        
    %% Normalized space
    results_dir_c = [cf '/POF_nifti/' sub{i}, filesep, 'Results_normalized'];
    
    omnibus_con = dir(fullfile(results_dir_c, 'spmF_0012.nii'));
    omnibus_con = char(fullfile(results_dir_c, {omnibus_con(:).name}));
    con_hdr = spm_vol(omnibus_con); % get header of image    
    con_img = spm_read_vols(con_hdr); % read image
    
    con_img(isnan(con_img)) = 0;
    con_img(con_img < thresh_f) = 0;
    con_img(con_img >= thresh_f) = 1;
        
    con_hdr.fname = [results_dir_c, filesep, 'Omnibus_Mask_norm.nii'];
    con_hdr.private.dat.fname = con_hdr.fname;
    spm_write_vol(con_hdr, con_img);
    
    
    % Gray matter
    t1_dir_c = [cf '/POF_nifti/' sub{i}, filesep, 'T1'];
    
    gray_matter = dir(fullfile(t1_dir_c, 'wc1T1_mean.nii'));
    gray_matter = char(fullfile(t1_dir_c, {gray_matter(:).name}));
    gray_matter_hdr = spm_vol(gray_matter); % get header of image    
    gray_matter_img = spm_read_vols(gray_matter_hdr); % read image
    
    gray_matter_img(gray_matter_img >= thresh_gm) = 1; 
    gray_matter_img(gray_matter_img < thresh_gm) = 0; 
    
    gray_matter_hdr.fname = [t1_dir_c, filesep, 'Gray_Matter_norm_thresh.nii'];
    gray_matter_hdr.private.dat.fname = gray_matter_hdr.fname;
    spm_write_vol(gray_matter_hdr, gray_matter_img);
    
    % Reslice gray matter onto omnibus mask
    gray_matter = fullfile(t1_dir_c, 'Gray_Matter_norm_thresh.nii');
    omnibus_mask = fullfile(results_dir_c, 'Omnibus_Mask_norm.nii');

    list_images = {omnibus_mask; gray_matter};
    spm_reslice(list_images);
    
    % Read resliced gray matter
    gray_matter = fullfile(t1_dir_c, 'rGray_Matter_norm_thresh.nii');
    gray_matter_hdr = spm_vol(gray_matter); % get header of image
    gray_matter_img = spm_read_vols(gray_matter_hdr); % read image
    gray_matter_img(gray_matter_img >= 0.8) = 1;
    gray_matter_img(gray_matter_img < 0.8) = 0;
    
    % Mask omnibus mask with gray matter mask
    omnibus_gm = con_img .* gray_matter_img;
    
    con_hdr.fname = [results_dir_c, filesep, 'Omnibus_GM_Mask_norm.nii'];
    con_hdr.private.dat.fname = con_hdr.fname;
    spm_write_vol(con_hdr, omnibus_gm);
    
    
    
end

clearvars -except sub
