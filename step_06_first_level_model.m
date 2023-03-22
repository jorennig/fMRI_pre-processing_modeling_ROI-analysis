%clear all
close all
clc

cf = pwd;

load('onsets_exp.mat');

onsets_tot.run_1 = onsets_exp.exp_global.run_1;
onsets_tot.run_2 = onsets_exp.exp_global.run_2;
onsets_tot.run_3 = onsets_exp.exp_pof.run_1;
onsets_tot.run_4 = onsets_exp.exp_pof.run_2;
onsets_tot.run_5 = onsets_exp.exp_pof.run_3;
onsets_tot.run_6 = onsets_exp.exp_pof.run_4;
clear onsets_exp
designs = fieldnames(onsets_tot);

for i = 1:numel(sub)
    
    %% 1st level model in native space
    results_dir_c = [cf '/POF_nifti/' sub{i}, filesep, 'Results_native'];
    mkdir(results_dir_c);
    
    runs = dir(fullfile([cf '/POF_nifti/' sub{i}], '*Run*'));
    runs = {runs(:).name}';
    
    % Create batch
    matlabbatch = [];
    matlabbatch{1}.spm.stats.fmri_spec.dir = {results_dir_c};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    
    for session = 1:numel(runs)
        
        % read data
        folder_c = [cf, filesep, 'POF_nifti', filesep, sub{i}, filesep, runs{session}];
        epi_run = dir(fullfile(folder_c, 'srEPI*.nii'));
        epi_run = {epi_run(:).name}';
        epi_run = fullfile(folder_c, epi_run);
        
        % EPIs
        design_c = onsets_tot.(designs{session});
        conditions = fieldnames(design_c);
        
        % Realignment parameter
        realign_run = dir(fullfile(folder_c, '*.txt'));
        realign_run = {realign_run(:).name}';
        realign_run = fullfile(folder_c, realign_run);
        
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).scans  = epi_run;
        
        for condition = 1:numel(conditions)            
            % onsets
            name_c = conditions{condition};
            name_c = name_c(strfind(name_c, '_')+1:end);
            matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(condition).name = name_c;
            matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(condition).onset = design_c.(conditions{condition});
            matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(condition).duration = 0;
            matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(condition).tmod = 0;
            matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(condition).pmod = struct('name', {}, 'param', {}, 'poly', {});
            matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(condition).orth = 1;
        end
        
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).multi = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).regress = struct('name', {}, 'val', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).multi_reg = realign_run;
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).hpf = 128;
        
    end
    
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    % Run batch
    spm_jobman('run', matlabbatch);
    
    % Estimation
    spm_mat_path = [results_dir_c, filesep, 'SPM.mat'];
    matlabbatch = [];
    matlabbatch{1}.spm.stats.fmri_est.spmmat = {spm_mat_path};
    matlabbatch{1}.spm.stats.fmri_est.method.Classical  = 1;
    
    % Run batch
    spm_jobman('run', matlabbatch);


    %% 1st level model in normalized space
    results_dir_c = [cf '/POF_nifti/' sub{i}, filesep, 'Results_normalized'];
    mkdir(results_dir_c);
    
    runs = dir(fullfile([cf '/POF_nifti/' sub{i}], '*Run*'));
    runs = {runs(:).name}';

    % Create batch
    matlabbatch = [];
    matlabbatch{1}.spm.stats.fmri_spec.dir = {results_dir_c};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    
    for session = 1:numel(runs)
        
        % read data
        folder_c = [cf, filesep, 'POF_nifti', filesep, sub{i}, filesep, runs{session}];
        epi_run = dir(fullfile(folder_c, 'swrEPI*.nii'));
        epi_run = {epi_run(:).name}';
        epi_run = fullfile(folder_c, epi_run);
        
        % EPIs
        design_c = onsets_tot.(designs{session});
        conditions = fieldnames(design_c);
        
        % Realignment parameter
        realign_run = dir(fullfile(folder_c, '*.txt'));
        realign_run = {realign_run(:).name}';
        realign_run = fullfile(folder_c, realign_run);
        
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).scans  = epi_run;
        
        for condition = 1:numel(conditions)            
            % onsets
            name_c = conditions{condition};
            name_c = name_c(strfind(name_c, '_')+1:end);
            matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(condition).name = name_c;
            matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(condition).onset = design_c.(conditions{condition});
            matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(condition).duration = 0;
            matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(condition).tmod = 0;
            matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(condition).pmod = struct('name', {}, 'param', {}, 'poly', {});
            matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(condition).orth = 1;
        end
        
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).multi = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).regress = struct('name', {}, 'val', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).multi_reg = realign_run;
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).hpf = 128;
        
    end
    
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    % Run batch
    spm_jobman('run', matlabbatch);
    
    % Estimation
    spm_mat_path = [results_dir_c, filesep, 'SPM.mat'];
    matlabbatch = [];
    matlabbatch{1}.spm.stats.fmri_est.spmmat = {spm_mat_path};
    matlabbatch{1}.spm.stats.fmri_est.method.Classical  = 1;
    
    % Run batch
    spm_jobman('run', matlabbatch);
    
    
end

clearvars -except sub
