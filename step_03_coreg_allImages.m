%clear all
close all
clc

cf = pwd;

for i = 1:numel(sub)
    
    folder_c = [cf '/POF_nifti/' sub{i} '/T1'];
    t1 = dir(fullfile(folder_c, '*.nii'));
    t1 = {t1(:).name}';
    t1 = fullfile(folder_c, t1);
    
    % AC-PC re-orient of T1_01
    %fprintf('Subject %s - AC-PC re-orient of T1_01\n', sub{i})
    %auto_reorient(t1{1});
    
    
    % Coreg T1_01 and T1_02
    fprintf('Subject %s - Coreg T1s\n', sub{i})
    
    % create batch
    matlabbatch = [];
    matlabbatch{1}.spm.spatial.coreg.estimate.ref = t1(1); % the one that is kept immobile
    matlabbatch{1}.spm.spatial.coreg.estimate.source = t1(2); % the one that is moved around to best fit
    matlabbatch{1}.spm.spatial.coreg.estimate.other = {''}; % all others that are moved around using the best fitting transformation.
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    
    % run batch
    spm_jobman('run', matlabbatch);
    
    
    % Read T1_01 and realigned T1_02, create and save mean image
    fprintf('Subject %s - Mean T1\n', sub{i})
    
    % create batch
    matlabbatch = [];
    matlabbatch{1}.spm.util.imcalc.input = t1;
    matlabbatch{1}.spm.util.imcalc.output = 'T1_mean';
    matlabbatch{1}.spm.util.imcalc.outdir = {folder_c};
    matlabbatch{1}.spm.util.imcalc.expression = '(i1 + i2) / 2';
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
    
    % run batch
    spm_jobman('run', matlabbatch);
    
end

for i = 1:numel(sub)
    
    folder_c = [cf '/POF_nifti/' sub{i} '/SBREF'];
    sbref = dir(fullfile(folder_c, '*.nii'));
    sbref = {sbref(:).name}';
    sbref = fullfile(folder_c, sbref);
    
    
    % Coreg all SBREFs
    fprintf('Subject %s - Coreg SBREFs\n', sub{i})
    
    % create batch
    matlabbatch = [];
    matlabbatch{1}.spm.spatial.coreg.estimate.ref = sbref(1); % the one that is kept immobile
    matlabbatch{1}.spm.spatial.coreg.estimate.source = sbref(2:end); % the one that is moved around to best fit
    matlabbatch{1}.spm.spatial.coreg.estimate.other = {''}; % all others that are moved around using the best fitting transformation.
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    
    % run batch
    spm_jobman('run', matlabbatch);
    
    
    % Read all SBREFs, create and save mean image
    fprintf('Subject %s - mean SBREFs\n', sub{i})
    
    % create batch
    matlabbatch = [];
    matlabbatch{1}.spm.util.imcalc.input = sbref;
    matlabbatch{1}.spm.util.imcalc.output = 'SBREF_mean';
    matlabbatch{1}.spm.util.imcalc.outdir = {folder_c};
    matlabbatch{1}.spm.util.imcalc.expression = '(i1 + i2 + i3 + i4 + i5 + i6) / 6';
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
    
    % run batch
    spm_jobman('run', matlabbatch);
    
    
    % Coreg meanSBREF to meanEPI
    fprintf('Subject %s - Coreg SBREFs\n', sub{i})
    mean_SBREF = fullfile(folder_c, 'SBREF_mean.nii');

    folder_epi_c = [cf '/POF_nifti/' sub{i} '/Global_Run_01'];
    mean_epi = dir(fullfile(folder_epi_c, 'mean*'));
    mean_epi = {mean_epi(:).name}';
    mean_epi = fullfile(folder_epi_c, mean_epi);

    % create batch
    matlabbatch = [];
    matlabbatch{1}.spm.spatial.coreg.estimate.ref = mean_epi; % the one that is kept immobile
    matlabbatch{1}.spm.spatial.coreg.estimate.source = {mean_SBREF}; % the one that is moved around to best fit
    matlabbatch{1}.spm.spatial.coreg.estimate.other = {''}; % all others that are moved around using the best fitting transformation.
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    
    % run batch
    spm_jobman('run', matlabbatch);
    
    
    % Coreg meanT1 to meanSBREF
    fprintf('Subject %s - Coreg mean T1 to meanSBREF\n', sub{i})

    folder_t1_c = [cf '/POF_nifti/' sub{i} '/T1'];
    mean_t1 = dir(fullfile(folder_t1_c, '*mean*'));
    mean_t1 = {mean_t1(:).name}';
    mean_t1 = fullfile(folder_t1_c, mean_t1);

    % create batch
    matlabbatch = [];
    matlabbatch{1}.spm.spatial.coreg.estimate.ref = {mean_SBREF}; % the one that is kept immobile
    matlabbatch{1}.spm.spatial.coreg.estimate.source = mean_t1; % the one that is moved around to best fit
    matlabbatch{1}.spm.spatial.coreg.estimate.other = {''}; % all others that are moved around using the best fitting transformation.
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    
    % run batch
    spm_jobman('run', matlabbatch);
    
end

clearvars -except sub
