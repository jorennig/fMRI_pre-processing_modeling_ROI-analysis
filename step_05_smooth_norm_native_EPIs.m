%clear all
close all
clc

cf = pwd;

for i = 1:numel(sub)
    
    % Get re-aligned EPIs (native space)
    folders = dir(fullfile([cf '/POF_nifti/' sub{i}], '*Run*'));
    folders = {folders(:).name}';

    epi_tot = [];
    for j = 1:numel(folders)
        
        fprintf('Subject %s - Run: %s\n', sub{i}, folders{j})
        
        % read data
        folder_c = [cf, filesep, 'POF_nifti', filesep, sub{i}, filesep, folders{j}];
        nifti_c = dir(fullfile(folder_c, 'rEPI*.nii'));
        nifti_c = {nifti_c(:).name}';
        nifti_c = fullfile(folder_c, nifti_c);
        
        epi_tot = [epi_tot; nifti_c];
    end
    
    % Smooth EPIs (native space)
    fprintf('Subject %s - Smooth EPIs (native space)\n', sub{i})
    
    % create batch
    matlabbatch = [];
    matlabbatch{1}.spm.spatial.smooth.data = epi_tot;
    matlabbatch{1}.spm.spatial.smooth.fwhm = [4 4 4];
    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
    matlabbatch{1}.spm.spatial.smooth.im = 0;
    matlabbatch{1}.spm.spatial.smooth.prefix = 's';
    
    % run batch
    spm_jobman('run', matlabbatch);
    
    
    % Get re-aligned and normalized EPIs (MNI space)
    folders = dir(fullfile([cf '/POF_nifti/' sub{i}], '*Run*'));
    folders = {folders(:).name}';

    epi_tot = [];
    for j = 1:numel(folders)
        
        fprintf('Subject %s - Run: %s\n', sub{i}, folders{j})
        
        % read data
        folder_c = [cf, filesep, 'POF_nifti', filesep, sub{i}, filesep, folders{j}];
        nifti_c = dir(fullfile(folder_c, 'wrEPI*.nii'));
        nifti_c = {nifti_c(:).name}';
        nifti_c = fullfile(folder_c, nifti_c);
        
        epi_tot = [epi_tot; nifti_c];
    end
    
    % Smooth EPIs (normalized)
    fprintf('Subject %s - Smooth EPIs (MNI space)\n', sub{i})
    
    % create batch
    matlabbatch = [];
    matlabbatch{1}.spm.spatial.smooth.data = epi_tot;
    matlabbatch{1}.spm.spatial.smooth.fwhm = [8 8 8];
    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
    matlabbatch{1}.spm.spatial.smooth.im = 0;
    matlabbatch{1}.spm.spatial.smooth.prefix = 's';
        
    % run batch
    spm_jobman('run', matlabbatch);
        
end

clearvars -except sub
