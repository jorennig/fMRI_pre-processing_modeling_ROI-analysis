clear all
close all
clc

cf = pwd;

sub = {'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR'}';

con_dir = cell(length(sub), 1);
con_dir(:) = {[cf '/POF_nifti/']};
con_dir = strcat(con_dir, sub, '/Results_normalized/');

con = {'Intact_vs_Places', 'con_0011.nii';
       'Intact_vs_Faces', 'con_0012.nii';
       'Intact_vs_Objects', 'con_0013.nii';
       'Intact_vs_ObjectsFacesPlaces', 'con_0014.nii';
       'Places_vs_Intact', 'con_0015.nii';
       'Faces_vs_Intact', 'con_0016.nii';
       'Objects_vs_Intact', 'con_0017.nii';       
       'ObjectsFacesPlaces_vs_Intact', 'con_0018.nii'};

for i = 1:length(con)
    
    label = con{i,1};
    img = con{i,2};
    
    results_dir_c = [cf '/POF_nifti/second_level_analysis/', label];
    
    if ~exist(results_dir_c, 'dir')
       mkdir(results_dir_c)
    end    
    
    con_c = strcat(con_dir, img);
    
    matlabbatch = [];    
    matlabbatch{1}.spm.stats.factorial_design.dir = {results_dir_c};
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = con_c;
    matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
    matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

    % Run batch
    spm_jobman('run', matlabbatch);


    % Estimation
    spm_mat_path = [results_dir_c, filesep, 'SPM.mat'];
    matlabbatch = [];
    matlabbatch{1}.spm.stats.fmri_est.spmmat = {spm_mat_path};
    matlabbatch{1}.spm.stats.fmri_est.method.Classical  = 1;
    
    % Run batch
    spm_jobman('run', matlabbatch);
    
    % Contrast manager
    matlabbatch = [];
    matlabbatch{1}.spm.stats.con.spmmat = {spm_mat_path};
    
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = label;
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = 1;
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

    % Run batch
    spm_jobman('run', matlabbatch);
    
end
