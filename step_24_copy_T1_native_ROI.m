clear all
close all
clc

sub = {'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR'};

cf = pwd;

for i = 1:numel(sub)

    folder_norm = [cf, filesep, 'POF_nifti', filesep, sub{i}, filesep, 'ROIs_norm/'];
    cd(folder_norm)
    delete('*.*')
    
    folder_t1 = [cf, filesep, 'POF_nifti', filesep, sub{i}, filesep, 'T1/'];
    cd(folder_t1)
    
    copyfile('T1_mean.nii', folder_norm)
    copyfile('wT1_mean.nii', folder_norm)
    
    folder_rois = [cf, filesep, 'POF_nifti', filesep, sub{i}, filesep, 'ROIs_native/'];
    cd(folder_rois)
    
    copyfile('tpj_anatomy_l.nii', folder_norm)
    copyfile('tpj_anatomy_r.nii', folder_norm)
    
end
