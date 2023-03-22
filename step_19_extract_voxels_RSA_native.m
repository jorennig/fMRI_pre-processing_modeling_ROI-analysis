clear all
close all
clc

sub = {'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR'};

cf = pwd;

path_data = [cf, filesep, 'RSA_native'];

%% Analysis per subject
t_val_tot_l = [];
t_val_tot_r = [];

rsa_l = [];
rsa_r = [];

for i = 1:numel(sub)
    
    fprintf('-- Subject %d of %d, Sub: %s --\n',i,numel(sub),sub{i})
        
    % Individual ROIs
    path_fs_rois = [cf '/POF_nifti/' sub{i}, filesep, 'ROIs_native'];
    
    fs_rois = dir(fullfile(path_fs_rois, 'TPJ_intact*.nii'));
    fs_rois =  {fs_rois(:).name}';
    
    % Create ROI names
    fs_rois_name = strrep(fs_rois,'.nii','');
    
    %% Analysis per ROI
    roi_com = zeros(numel(fs_rois),3);
    roi_size = zeros(numel(fs_rois),1);
    vox_outside = zeros(numel(fs_rois),1);
    
    for r = 1:numel(fs_rois)
        
        fprintf('ROI: %s \n',fs_rois_name{r})
        
        roi_c = fullfile(path_fs_rois,fs_rois{r});
        
        roi_hdr = spm_vol(roi_c); % get header of image
        sz = roi_hdr.dim(1:3);
        
        mask_img = spm_read_vols(roi_hdr); % get mask
        %mask_img = ~isnan(mask_img) &  mask_img > 0;
        roi_size(r) = sum(mask_img(:));
        
        mask_index = find(mask_img);
        [x,y,z] = ind2sub(sz,mask_index); % list of x/y/z coordinates for all voxels in mask (needed for read_voxels)
        x_y_z = [x,y,z];
        
        roi_com(r,:) = [mean(x), mean(y), mean(z)]; % center of mass
        
        % Get beta images
        path_beta = [cf '/POF_nifti/' sub{i}, filesep, 'Results_native'];
        beta_img = dir(fullfile(path_beta, 'spmT*.nii'));
        beta_img = fullfile(path_beta, {beta_img(:).name}');
        beta_keep = [1, 5, 6, 7]; % Global, Places, Objects, Faces
        beta_img = beta_img(beta_keep);
        
        betas = [];
        for b = 1:numel(beta_img)
            
            beta_c = beta_img{b};
                        
            spmVol = spm_read_vols(spm_vol(beta_c));
            data_hdr = spm_vol(beta_c); % get header of image
            
            voxels = spm_sample_vol(data_hdr,x,y,z,0);
            betas = [betas; voxels'];
        end
        
        % Find 0 and NaN values (values outside the brain)
        [~, col_nan] = find(isnan(betas));
        [~, col_zero] = find((betas == 0));
        
        col_nan = unique(col_nan);
        col_zero = unique(col_zero);
        cols = [col_nan; col_zero];
        
        vox_outside(r) = numel(col_nan) + numel(col_zero); % e.g. voxels outside the brain
        
        betas(:,cols) = [];        
        betas = betas';
        
        if size(betas,1) < 4
            rsa = NaN(4,4);
            t_val_mean = NaN(1,4);
        elseif isempty(betas)
            rsa = NaN(4,4);
            t_val_mean = NaN(1,4);
        else
            rsa = corr(betas);
            t_val_mean = nanmean(betas);
        end
    
        if r == 1
            t_val_tot_l(i,:) = t_val_mean;
            rsa_l(:,:,i) = rsa;
        else
            t_val_tot_r(i,:) = t_val_mean;
            rsa_r(:,:,i) = rsa;
        end
                
    end
        
end

%% Summarize and save data
col_label = {'Global', 'Places', 'Objects', 'Faces'};
t_val_tot_l = array2table(t_val_tot_l, 'VariableNames',col_label);
t_val_tot_r = array2table(t_val_tot_r, 'VariableNames',col_label);

writetable(t_val_tot_l,[fullfile(path_data, 't_val_tot_l') '.txt']);
writetable(t_val_tot_r,[fullfile(path_data, 't_val_tot_r') '.txt']);

rsa_mean_l = nanmean(rsa_l,3);
rsa_mean_r = nanmean(rsa_r,3);

rsa_r_vals_l = [squeeze(rsa_l(1,2,:)), squeeze(rsa_l(1,3,:)), squeeze(rsa_l(1,4,:)), squeeze(rsa_l(2,3,:)), squeeze(rsa_l(2,4,:)), squeeze(rsa_l(3,4,:))]; % global*places, global*objects, global*faces, places*objects, places*faces, objects*faces
rsa_r_vals_r = [squeeze(rsa_r(1,2,:)), squeeze(rsa_r(1,3,:)), squeeze(rsa_r(1,4,:)), squeeze(rsa_r(2,3,:)), squeeze(rsa_r(2,4,:)), squeeze(rsa_r(3,4,:))]; % global*places, global*objects, global*faces, places*objects, places*faces, objects*faces

col_r_label = {'global_places', 'global_objects', 'global_faces', 'places_objects', 'places_faces', 'objects_faces'};

rsa_r_vals_l = array2table(rsa_r_vals_l, 'VariableNames', col_r_label);
rsa_r_vals_r = array2table(rsa_r_vals_r, 'VariableNames', col_r_label);

% subplot(1,2,1)
% imagesc(rsa_mean_l)
% colorbar
% subplot(1,2,2)
% imagesc(rsa_mean_r)
% colorbar

rsa_mean_l = array2table(rsa_mean_l, 'VariableNames', col_label, 'RowNames', col_label);
rsa_mean_r = array2table(rsa_mean_r, 'VariableNames', col_label, 'RowNames', col_label);

writetable(rsa_mean_l,[fullfile(path_data, 'rsa_mean_l') '.txt'], 'WriteRowNames',true);
writetable(rsa_mean_r,[fullfile(path_data, 'rsa_mean_r') '.txt'], 'WriteRowNames',true);

writetable(rsa_r_vals_l,[fullfile(path_data, 'rsa_r_vals_l') '.txt']);
writetable(rsa_r_vals_r,[fullfile(path_data, 'rsa_r_vals_r') '.txt']);
