clear all
close all
clc

cf = pwd;

sub = {'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR'};
    
rois = {'Places', 'L', 'spmT_0008.nii', 'rwppa_anatomy_l.nii';
        'Places', 'R', 'spmT_0008.nii', 'rwppa_anatomy_r.nii';
        'Faces', 'L', 'spmT_0009.nii', 'rwffa_anatomy_l.nii';
        'Faces', 'R', 'spmT_0009.nii', 'rwffa_anatomy_r.nii';
        'Objects', 'L', 'spmT_0010.nii', 'rwloc_anatomy_l.nii';
        'Objects', 'R', 'spmT_0010.nii', 'rwloc_anatomy_r.nii'};

t_thresh = 1.64;
roi_info = [];
for i = 1:numel(sub)

    % functional
    results_dir_c = [cf '/POF_nifti/' sub{i}, filesep, 'Results_normalized'];
    
    for j = 1:length(rois)
        
        roi_c = rois(j,:);
        
        functional = fullfile(results_dir_c, filesep, roi_c{3});
        functional_hdr = spm_vol(functional); % get header of image
        functional_img = spm_read_vols(functional_hdr); % read image

        functional_img(functional_img < t_thresh) = 0;
        functional_img(functional_img >= t_thresh) = 1;

        %% anatomy
        roi_folder = [cf '/POF_nifti/' sub{i}, filesep,'ROIs_norm'];

        anatomy = fullfile(roi_folder, roi_c{4});
        anatomy_hdr = spm_vol(anatomy); % get header of image
        anatomy_img = spm_read_vols(anatomy_hdr); % read image

        roi_img = functional_img .* anatomy_img;
        vol = sum(sum(sum(roi_img)));
        
        [v, x, y, z] = summary_vol(roi_img);
        roi_info = [roi_info; {sub{i}, roi_c{1}, roi_c{2}, v, x, y, z}];

        % ROI as .nii
        roi_name = [roi_c{1} '_', roi_c{2}, '.nii'];
        functional_hdr.fname = [roi_folder, filesep, roi_name];
        functional_hdr.private.dat.fname = functional_hdr.fname;
        spm_write_vol(functional_hdr, roi_img);
        
    end
end

roi_info = cell2table(roi_info, 'VariableNames', {'subject_id', 'ROI', 'Hem', 'Volume_Size', 'X', 'Y', 'Z'});

writetable(roi_info, 'ROI_Info_ventral.txt')

function [v, x, y, z] = summary_vol(vol)
    v = sum(sum(sum(vol)));
    [ii, jj, kk] = ndgrid(1:size(vol,1), 1:size(vol,2), 1:size(vol,3));
    x = round(sum(ii(:).*vol(:))/v);
    y = round(sum(jj(:).*vol(:))/v);
    z = round(sum(kk(:).*vol(:))/v);
end
