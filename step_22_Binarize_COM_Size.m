clear all
close all
clc

sub = {'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR'};
sub = {'AA'};

cf = pwd;

roi_s = [];
for i = 1:numel(sub)
    
    folder_c = [cf, filesep, 'POF_nifti', filesep, sub{i}, filesep, 'ROIs_native/'];

    tpj_rois = dir(fullfile(folder_c, 'rwTPJ_Intact*.nii'));
    tpj_rois = {tpj_rois(:).name}';
    tpj_rois = fullfile(folder_c, tpj_rois);
    
    tpj_nonrois = dir(fullfile(folder_c, 'rwTPJ_Non*.nii'));
    tpj_nonrois = {tpj_nonrois(:).name}';
    tpj_nonrois = fullfile(folder_c, tpj_nonrois);
    
    anatomy = dir(fullfile(folder_c, 'rwrtpj_anatomy*.nii'));
    anatomy = {anatomy(:).name}';
    anatomy = fullfile(folder_c, anatomy);
    
    list_images = [tpj_rois; tpj_nonrois; anatomy];
    
    for j = 1:numel(list_images)

        roi_c_header = spm_vol(list_images{j});
        roi_c_vol = spm_read_vols(roi_c_header);

        roi_c_vol = double(roi_c_vol > 0.10); % binarize
        
        v = sum(sum(sum(roi_c_vol)));
        
        [ii, jj, kk] = ndgrid(1:size(roi_c_vol,1), 1:size(roi_c_vol,2), 1:size(roi_c_vol,3));
        x = round(sum(ii(:).*roi_c_vol(:))/v);
        y = round(sum(jj(:).*roi_c_vol(:))/v);
        z = round(sum(kk(:).*roi_c_vol(:))/v);
        
        [filepath, name, ext] = fileparts(list_images{j});
        
        a = {sub{i}, name, v, x, y, z};
        roi_s = [roi_s; {sub{i}, name, v, x, y, z}];
        
        name_n = strrep(list_images{j}, 'ROIs_native/rw', 'ROIs_native/brw');        
        roi_c_header.fname = name_n;
        roi_c_header.private.dat.fname = roi_c_header.fname;
        spm_write_vol(roi_c_header, roi_c_vol);
        
    end

end

roi_s(:,2) = strrep(roi_s(:,2), 'w', '');
roi_s(:,2) = strrep(roi_s(:,2), 'rtpj_anatomy', 'TPJ_Anatomy');
roi_s(:,2) = strrep(roi_s(:,2), '_l', '_L');
roi_s(:,2) = strrep(roi_s(:,2), '_r', '_R');

roi_s = cell2table(roi_s, 'VariableNames', {'subject_id', 'ROI', 'Volume_Size', 'X', 'Y', 'Z'});

writetable(roi_s, 'ROI_Info.txt')
