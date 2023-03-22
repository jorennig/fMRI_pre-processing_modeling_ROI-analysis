%clear all
close all
clc

cf = pwd;

load('onsets_exp.mat');

onsets_tot.run_1 = onsets_exp.exp_global.run_1;
onsets_tot.run_2 = onsets_exp.exp_global.run_2;
onsets_tot.run_1.onsets_intact = onsets_tot.run_1.onsets_intact';
onsets_tot.run_1.onsets_scrambled = onsets_tot.run_1.onsets_scrambled';
onsets_tot.run_2.onsets_intact = onsets_tot.run_2.onsets_intact';
onsets_tot.run_2.onsets_scrambled = onsets_tot.run_2.onsets_scrambled';

onsets_tot.run_3 = onsets_exp.exp_pof.run_1;
onsets_tot.run_4 = onsets_exp.exp_pof.run_2;
onsets_tot.run_5 = onsets_exp.exp_pof.run_3;
onsets_tot.run_6 = onsets_exp.exp_pof.run_4;
clear onsets_exp
designs = fieldnames(onsets_tot);

for i = 1:numel(sub)
    
    % 1st level model in native space
    results_dir_c = [cf '/POF_nifti/' sub{i}, filesep, 'Results_native_MVPA'];
    mkdir(results_dir_c);
    
    runs = dir(fullfile([cf '/POF_nifti/' sub{i}], '*Run*'));
    runs = {runs(:).name}';
    
    for session = 1:numel(runs)
        
        % read data
        folder_c = [cf, filesep, 'POF_nifti', filesep, sub{i}, filesep, runs{session}];
        epi_run = dir(fullfile(folder_c, 'srEPI*.nii'));
        epi_run = {epi_run(:).name}';
        epi_run = fullfile(folder_c, epi_run);
        
        % EPIs
        design_c = onsets_tot.(designs{session});
        conditions = fieldnames(design_c);
        
        stim_tot = [];
        for condition = 1:numel(conditions)
            stim_c = design_c.(conditions{condition});
            stim_c = [stim_c, ones(length(stim_c),1)*condition];
            stim_tot = [stim_tot; stim_c];
        end
        
        stim_tot = sortrows(stim_tot, 1);
        
        % Realignment parameter
        realign_run = dir(fullfile(folder_c, '*.txt'));
        realign_run = fullfile(folder_c, {realign_run(:).name}');
        
        for stim = 1:length(stim_tot)
            
            stim_c = stim_tot(stim,:);
            
            if stim < 10
                name_c = ['0' num2str(session) '_00' num2str(stim) '_0' num2str(stim_c(2))];
            elseif stim < 100
                name_c = ['0' num2str(session) '_0' num2str(stim) '_0' num2str(stim_c(2))];
            else
                name_c = ['0' num2str(session) '_' num2str(stim) '_0' num2str(stim_c(2))];
            end
            
            results_dir_item = [results_dir_c, filesep, name_c];
            mkdir(results_dir_item);
            
            conditions = {name_c; 'rest'};
            
            matlabbatch = [];
            for condition = 1:numel(conditions)
                
                name_con = conditions{condition};
                
                if condition == 1
                    onset_con = stim_c(1);
                else
                    onset_con = stim_tot(:,1);
                    onset_con(onset_con == stim_c(1)) = [];
                end
                
                % Create batch
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = epi_run;
                matlabbatch{1}.spm.stats.fmri_spec.dir = {results_dir_item};
                matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
                matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
                matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
                matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(condition).name = name_con;
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(condition).onset = onset_con;
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(condition).duration = 0;
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(condition).tmod = 0;
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(condition).pmod = struct('name', {}, 'param', {}, 'poly', {});
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(condition).orth = 1;
            end
            
            matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {''};
            matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
            matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = realign_run;
            matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;
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
            spm_mat_path = [results_dir_item, filesep, 'SPM.mat'];
            matlabbatch = [];
            matlabbatch{1}.spm.stats.fmri_est.spmmat = {spm_mat_path};
            matlabbatch{1}.spm.stats.fmri_est.method.Classical  = 1;
            
            % Run batch
            spm_jobman('run', matlabbatch);   
            
            % Copy and re-name first beta image, delete rest
            beta_img = fullfile(results_dir_item, 'beta_0001.nii');            
            movefile(beta_img, fullfile(results_dir_c, [name_c, '.nii']));
            rmdir(results_dir_item, 's');
            
        end
                
    end
    
end

clearvars -except sub
