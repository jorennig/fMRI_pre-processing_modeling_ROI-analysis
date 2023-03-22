%clear all
close all
clc

cf = pwd;

% Read TPJ ROIs from Huberle & Karnath, 2012; Rennig et al. 2013; Bloechle
% et al. 2018
roi_folder = [cf, filesep, 'TPJ_ROIs_Norm'];
tpj_rois = dir(fullfile(roi_folder, 'rTPJ*.nii'));
tpj_names = {tpj_rois(:).name}';
tpj_names = erase(tpj_names, 'r');
tpj_names = erase(tpj_names, '.nii');
tpj_names = erase(tpj_names, 'Exp1_');

tpj_rois = fullfile(roi_folder, {tpj_rois(:).name}');

for i = 1:numel(tpj_rois)
    
    tpj_hdr = spm_vol(tpj_rois{i}); % get header of image
    tpj_img = spm_read_vols(tpj_hdr); % read image
    tpj_img(tpj_img > 0) = 1;
    tpj_img(tpj_img < 0) = 0;
    
    tpj_img_tot.(tpj_names{i}) = tpj_img;
    tpj_hdr_tot.(tpj_names{i}) = tpj_hdr;
    
end

t_thresh = 1.64;
roi_tot = [];
for i = 1:numel(sub)
    
    % Normalized space
    results_dir_c = [cf '/POF_nifti/' sub{i}, filesep, 'Results_normalized'];

    % Contrast Intact vs. Baseline
    global_baseline = fullfile(results_dir_c, filesep, 'spmT_0001.nii');
    global_baseline_hdr = spm_vol(global_baseline); % get header of image
    global_baseline_img = spm_read_vols(global_baseline_hdr); % read image
    
    global_baseline_img(global_baseline_img < t_thresh) = 0;
    global_baseline_img(global_baseline_img >= t_thresh) = 1;
    
    roi_folder = [cf '/POF_nifti/' sub{i}, filesep,'ROIs_norm'];
    mkdir(roi_folder);
    
    n_vox = [0;0];
    names_tot = cell(2,1);
    for j = 1:numel(tpj_rois)
        
        tpj_img_c = tpj_img_tot.(tpj_names{j});
        
        tpj_roi_img_c = global_baseline_img .* tpj_img_c;
        n_vox(j) = sum(sum(sum(tpj_roi_img_c)));
        
        name_c = [tpj_names{j} '_Intact_Baseline'];
        names_tot(j) = {[sub{i} '_' tpj_names{j}]};
        
        % ROI as .nii
        global_baseline_hdr.fname = [roi_folder, filesep, name_c '.nii'];
        global_baseline_hdr.private.dat.fname = global_baseline_hdr.fname;
        spm_write_vol(global_baseline_hdr, tpj_roi_img_c);
        
        % Marsbar ROI (mat file)
        img_name = [roi_folder, filesep, name_c '.nii'];
        roi_m = maroi_image(struct('vol', spm_vol(img_name), 'binarize',0, 'func', 'img'));
        saveroi(roi_m, [roi_folder, filesep, name_c '_roi.mat'])

    end
    roi_sum_b = table(names_tot, n_vox, 'VariableNames', {'roi', 'n_vox_b'});
    
    % Contrast Intact vs. Scrambled
    global_scrambled = fullfile(results_dir_c, filesep, 'spmT_0003.nii');
    global_scrambled_hdr = spm_vol(global_scrambled); % get header of image
    global_scrambled_img = spm_read_vols(global_scrambled_hdr); % read image
    
    global_scrambled_img(global_scrambled_img < t_thresh) = 0;
    global_scrambled_img(global_scrambled_img >= t_thresh) = 1;
    
    n_vox = [0;0];
    names_tot = cell(2,1);
    for j = 1:numel(tpj_rois)
        
        tpj_img_c = tpj_img_tot.(tpj_names{j});
        
        tpj_roi_img_c = global_scrambled_img .* tpj_img_c;
        n_vox(j) = sum(sum(sum(tpj_roi_img_c)));
        
        name_c = [tpj_names{j} '_Intact_Scrambled'];
        names_tot(j) = {[sub{i} '_' tpj_names{j}]};
        
        % ROI as .nii
        global_scrambled_hdr.fname = [roi_folder, filesep, name_c '.nii'];
        global_scrambled_hdr.private.dat.fname = global_scrambled_hdr.fname;
        spm_write_vol(global_scrambled_hdr, tpj_roi_img_c);
        
        % Marsbar ROI (mat file)
        img_name = [roi_folder, filesep, name_c '.nii'];
        roi_m = maroi_image(struct('vol', spm_vol(img_name), 'binarize',0, 'func', 'img'));
        saveroi(roi_m, [roi_folder, filesep, name_c '_roi.mat'])

    end
    roi_sum_is = table(n_vox, 'VariableNames', {'n_vox_is'});
    
    roi_sum = [roi_sum_b, roi_sum_is];
    
    roi_tot = [roi_tot; roi_sum];
    
end

save('roi_tot.mat', 'roi_tot');

clearvars -except sub
