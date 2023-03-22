clear all
close all
clc

sub = {'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR'};

cf = pwd;

path_data = [cf, filesep, 'MVPA_native_ventral'];

for i = 1:numel(sub)
    
    fprintf('-- Subject %d of %d, Sub: %s --\n',i,numel(sub),sub{i})
    
    % Check for subject folder in MVPA directory
    if ~exist(fullfile(path_data, sub{i}), 'dir')
       mkdir(fullfile(path_data, sub{i}))
    end    
    
    % Individual ROIs
    path_fs_rois = [cf '/POF_nifti/' sub{i}, filesep, 'ROIs_native'];
    
    objects = dir(fullfile(path_fs_rois, 'Objects_*.nii'));
    objects = {objects(:).name}';
    
    faces = dir(fullfile(path_fs_rois, 'Faces_*.nii'));
    faces = {faces(:).name}';

    places = dir(fullfile(path_fs_rois, 'Places_*.nii'));
    places = {places(:).name}';
    
    fs_rois = [places; faces; objects];
    
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
        path_beta = [cf '/POF_nifti/' sub{i}, filesep, 'Results_native_MVPA'];
        beta_img = dir(fullfile(path_beta, '*.nii'));
        beta_img = fullfile(path_beta, {beta_img(:).name}');
        
        betas = [];
        cond = [];
        for b = 1:numel(beta_img)
            
            beta_c = beta_img{b};
                        
            num_name = regexp(beta_c, '[0-9]');
            cond_c = [str2double(beta_c(num_name(1:2))), str2double(beta_c(num_name(3:5))), str2double(beta_c(num_name(6:7)))];

            spmVol = spm_read_vols(spm_vol(beta_c));
            data_hdr = spm_vol(beta_c); % get header of image
            
            voxels = spm_sample_vol(data_hdr,x,y,z,0);
            betas = [betas; voxels'];
            cond = [cond; cond_c];       
        end
        
        % Find 0 and NaN values (values outside the brain)
        [~, col_nan] = find(isnan(betas));
        [~, col_zero] = find((betas == 0));
        
        col_nan = unique(col_nan);
        col_zero = unique(col_zero);
        cols = [col_nan; col_zero];
        
        vox_outside(r) = numel(col_nan) + numel(col_zero); % e.g. voxels outside the brain
        
        betas(:,cols) = [];
        cond(:,cols) = [];
        
        betas = [cond, betas];
        betas_t = array2table(betas);
        
        % Save data for ROI and all conditions
        file_name = fs_rois_name{r};
        
        writetable(betas_t,[fullfile([path_data, filesep, sub{i}], file_name) '.txt']);
        
    end
    
    % ROI info per subject
    col_label = {'x','y','z','size','vox_out'};
    roi_info = [roi_com, roi_size, vox_outside];
    
    roi_info = array2table(roi_info, 'VariableNames',col_label,'RowNames',fs_rois_name);
    
    file_name_roi = [sub{i} '_ROI_info'];
    save(fullfile([path_data, filesep,sub{i}], file_name_roi), 'roi_info');
    
end
