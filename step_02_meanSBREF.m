clear all
close all
clc

cf = pwd;

load('sub.mat')

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

end
