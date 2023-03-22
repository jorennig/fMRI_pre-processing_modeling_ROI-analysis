%clear all
close all
clc

cf = pwd;

for i = 1:numel(sub)
    
    % Get re-aligned EPIs
    folder_epi_c = [cf '/POF_nifti/' sub{i} '/Global_Run_01'];
    mean_epi = dir(fullfile(folder_epi_c, 'mean*'));
    mean_epi = {mean_epi(:).name}';
    mean_epi = fullfile(folder_epi_c, mean_epi);
    
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
    
    % Normalize EPIs
    fprintf('Subject %s - Normalize EPIs\n', sub{i})
    
    % create batch
    matlabbatch = [];
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = mean_epi;
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = epi_tot;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {'C:\Program Files\spm12\tpm\TPM.nii'};
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70
                                                                 78 76 85];
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.prefix = 'w';
    
    % run batch
    spm_jobman('run', matlabbatch);
    
    
    % Get mean T1
    folder_t1_c = [cf '/POF_nifti/' sub{i} '/T1'];
    mean_t1 = dir(fullfile(folder_t1_c, '*mean*'));
    mean_t1 = {mean_t1(:).name}';
    mean_t1 = fullfile(folder_t1_c, mean_t1);

    % Normalize meanT1s
    fprintf('Subject %s - Normalize T1\n', sub{i})
    
    matlabbatch = [];
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = mean_t1;
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = mean_t1;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {'C:\Program Files\spm12\tpm\TPM.nii'};
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70
                                                                 78 76 85];
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = [1 1 1];
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.prefix = 'w';
    
    % run batch
    spm_jobman('run', matlabbatch);
        
end

clearvars -except sub
