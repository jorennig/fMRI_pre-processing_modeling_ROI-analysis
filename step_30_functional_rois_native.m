clear all
close all
clc

cf = pwd;

sub = {'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR'};
    
rois = {'Places', 'L', 'spmT_0008.nii', 'rppa_anatomy_l.nii';
        'Places', 'R', 'spmT_0008.nii', 'rppa_anatomy_r.nii';
        'Faces', 'L', 'spmT_0009.nii', 'rffa_anatomy_l.nii';
        'Faces', 'R', 'spmT_0009.nii', 'rffa_anatomy_r.nii';
        'Objects', 'L', 'spmT_0010.nii', 'rloc_anatomy_l.nii';
        'Objects', 'R', 'spmT_0010.nii', 'rloc_anatomy_r.nii'};

t_thresh = 1.64;
n_vox = {};
for i = 1:numel(sub)

    % functional
    results_dir_c = [cf '/POF_nifti/' sub{i}, filesep, 'Results_native'];
    
    for j = 1:length(rois)
        
        roi_c = rois(j,:);
        
        functional = fullfile(results_dir_c, filesep, roi_c{3});
        functional_hdr = spm_vol(functional); % get header of image
        functional_img = spm_read_vols(functional_hdr); % read image

        functional_img(functional_img < t_thresh) = 0;
        functional_img(functional_img >= t_thresh) = 1;

        %% anatomy
        roi_folder = [cf '/POF_nifti/' sub{i}, filesep,'ROIs_native'];

        anatomy = fullfile(roi_folder, roi_c{4});
        anatomy_hdr = spm_vol(anatomy); % get header of image
        anatomy_img = spm_read_vols(anatomy_hdr); % read image

        roi_img = functional_img .* anatomy_img;
        vol = sum(sum(sum(roi_img)));
        
        n_vox = [n_vox; [sub(i), roi_c(1:2), {vol}]];

        % ROI as .nii
        roi_name = [roi_c{1} '_', roi_c{2}, '.nii'];
        functional_hdr.fname = [roi_folder, filesep, roi_name];
        functional_hdr.private.dat.fname = functional_hdr.fname;
        spm_write_vol(functional_hdr, roi_img);

        % Marsbar ROI (mat file)
        img_name = [roi_folder, filesep, roi_name];
        roi_m = maroi_image(struct('vol', spm_vol(img_name), 'binarize',0, 'func', 'img'));
        saveroi(roi_m, [roi_folder, filesep, [roi_c{1} '_', roi_c{2}, '_roi.mat']]);
        
    end
end

save('n_vox_native_ventral.mat', 'n_vox');
