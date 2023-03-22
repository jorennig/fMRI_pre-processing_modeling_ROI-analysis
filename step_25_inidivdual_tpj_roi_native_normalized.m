clear all
close all
clc

cf = pwd;

sub = {'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR'};

t_thresh = 1.64;
roi_info = [];
for i = 1:numel(sub)

    results_dir_c = [cf '/POF_nifti/' sub{i}, filesep, 'Results_normalized'];

    % Contrast Intact vs. Baseline
    global_baseline = fullfile(results_dir_c, filesep, 'spmT_0001.nii');
    global_baseline_hdr = spm_vol(global_baseline); % get header of image
    global_baseline_img = spm_read_vols(global_baseline_hdr); % read image
    
    global_baseline_img(global_baseline_img < t_thresh) = 0;
    global_baseline_img(global_baseline_img >= t_thresh) = 1;
        
    roi_folder = [cf '/POF_nifti/' sub{i}, filesep,'ROIs_norm'];
    
    %% TPJ left
    tpj_roi_l = fullfile(roi_folder, 'rwtpj_anatomy_l.nii');
    tpj_roi_l_hdr = spm_vol(tpj_roi_l); % get header of image
    tpj_roi_l_img = spm_read_vols(tpj_roi_l_hdr); % read image
    
    tpj_roi_img_c = global_baseline_img .* tpj_roi_l_img;
    
    tpj_nonroi_img_c = tpj_roi_l_img - tpj_roi_img_c;
    
    % ROI as .nii
    global_baseline_hdr.fname = [roi_folder, filesep, 'TPJ_Intact_Baseline_L.nii'];
    global_baseline_hdr.private.dat.fname = global_baseline_hdr.fname;
    spm_write_vol(global_baseline_hdr, tpj_roi_img_c);
    
    global_baseline_hdr.fname = [roi_folder, filesep, 'TPJ_NonROI_L.nii'];
    global_baseline_hdr.private.dat.fname = global_baseline_hdr.fname;
    spm_write_vol(global_baseline_hdr, tpj_nonroi_img_c);
    
    name = 'TPJ_Intact_L';
    [v, x, y, z] = summary_vol(tpj_roi_img_c);
    roi_info = [roi_info; {sub{i}, name, v, x, y, z}];
    
    name = 'TPJ_NonROI_L';
    [v, x, y, z] = summary_vol(tpj_nonroi_img_c);
    roi_info = [roi_info; {sub{i}, name, v, x, y, z}];

    name = 'TPJ_Anatomy_L';
    [v, x, y, z] = summary_vol(tpj_roi_l_img);
    roi_info = [roi_info; {sub{i}, name, v, x, y, z}];
    
    %% TPJ right
    tpj_roi_r = fullfile(roi_folder, 'rwtpj_anatomy_r.nii');
    tpj_roi_r_hdr = spm_vol(tpj_roi_r); % get header of image
    tpj_roi_r_img = spm_read_vols(tpj_roi_r_hdr); % read image
    
    tpj_roi_img_c = global_baseline_img .* tpj_roi_r_img;
    
    tpj_nonroi_img_c = tpj_roi_r_img - tpj_roi_img_c;
    
    % ROI as .nii
    global_baseline_hdr.fname = [roi_folder, filesep, 'TPJ_Intact_Baseline_R.nii'];
    global_baseline_hdr.private.dat.fname = global_baseline_hdr.fname;
    spm_write_vol(global_baseline_hdr, tpj_roi_img_c);
    
    global_baseline_hdr.fname = [roi_folder, filesep, 'TPJ_NonROI_R.nii'];
    global_baseline_hdr.private.dat.fname = global_baseline_hdr.fname;
    spm_write_vol(global_baseline_hdr, tpj_nonroi_img_c);

    name = 'TPJ_Intact_R';
    [v, x, y, z] = summary_vol(tpj_roi_img_c);
    roi_info = [roi_info; {sub{i}, name, v, x, y, z}];
    
    name = 'TPJ_NonROI_R';
    [v, x, y, z] = summary_vol(tpj_nonroi_img_c);
    roi_info = [roi_info; {sub{i}, name, v, x, y, z}];

    name = 'TPJ_Anatomy_R';
    [v, x, y, z] = summary_vol(tpj_roi_r_img);
    roi_info = [roi_info; {sub{i}, name, v, x, y, z}];
    
end

roi_info = cell2table(roi_info, 'VariableNames', {'subject_id', 'ROI', 'Volume_Size', 'X', 'Y', 'Z'});

writetable(roi_info, 'ROI_Info.txt')

function [v, x, y, z] = summary_vol(vol)
    v = sum(sum(sum(vol)));
    [ii, jj, kk] = ndgrid(1:size(vol,1), 1:size(vol,2), 1:size(vol,3));
    x = round(sum(ii(:).*vol(:))/v);
    y = round(sum(jj(:).*vol(:))/v);
    z = round(sum(kk(:).*vol(:))/v);
end
