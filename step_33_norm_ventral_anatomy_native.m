clear all
close all
clc

sub = {'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR'};

cf = pwd;

for i = 1:numel(sub)
    
    % Get mean T1
    folder_c = [cf, filesep, 'POF_nifti', filesep, sub{i}, filesep, 'ROIs_norm/'];
    mean_t1 = {fullfile(folder_c, 'T1_mean.nii')};
    
    loc_rois = dir(fullfile(folder_c,'loc*.nii'));
    loc_rois = fullfile(folder_c, {loc_rois(:).name}');

    ffa_rois = dir(fullfile(folder_c,'ffa*.nii'));
    ffa_rois = fullfile(folder_c, {ffa_rois(:).name}');

    ppa_rois = dir(fullfile(folder_c,'ppa*.nii'));
    ppa_rois = fullfile(folder_c, {ppa_rois(:).name}');
    
    list_images = [loc_rois; ffa_rois; ppa_rois];
    
    fprintf('Subject %s - Normalize TPJ ROIs \n', sub{i})
    
    matlabbatch = [];
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = mean_t1;
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = list_images;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {'/Users/beauchamplab/Documents/MATLAB/spm12/tpm/TPM.nii'};
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
    
    delete([folder_c, 'y_T1_mean.nii'])
    
end

for i = 1:numel(sub)
    
    % Get mean T1
    folder_c = [cf, filesep, 'POF_nifti', filesep, sub{i}, filesep, 'ROIs_norm/'];
    mean_t1 = {fullfile(folder_c, 'T1_mean.nii')};
    
    loc_rois = dir(fullfile(folder_c,'loc*.nii'));
    loc_rois = fullfile(folder_c, {loc_rois(:).name}');

    ffa_rois = dir(fullfile(folder_c,'ffa*.nii'));
    ffa_rois = fullfile(folder_c, {ffa_rois(:).name}');

    ppa_rois = dir(fullfile(folder_c,'ppa*.nii'));
    ppa_rois = fullfile(folder_c, {ppa_rois(:).name}');
    
    list_images = [loc_rois; ffa_rois; ppa_rois];
    
    fprintf('Subject %s - Normalize TPJ ROIs \n', sub{i})
    
    matlabbatch = [];
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = mean_t1;
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = list_images;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {'/Users/beauchamplab/Documents/MATLAB/spm12/tpm/TPM.nii'};
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70
                                                                 78 76 85];
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.prefix = 'rw';
    
    % run batch
    spm_jobman('run', matlabbatch);
    
    delete([folder_c, 'y_T1_mean.nii'])
    
end
