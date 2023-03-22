clear all
close all
clc

cf = pwd;

load('sub.mat')

for i = 1:numel(sub)
    
    folder_c = [cf '/POF_nifti/' sub{i} '/T1'];
    t1 = dir(fullfile(folder_c, '*.nii'));
    t1 = {t1(:).name}';
    t1 = fullfile(folder_c, t1);
    
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
