clear all
close all
clc

cf = pwd;

sub = {'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR'};

all_con = [ones(1,2), zeros(1,6), ones(1,2), zeros(1,6), ones(1,3), zeros(1,6), ones(1,3), zeros(1,6), ones(1,3), zeros(1,6), ones(1,3), zeros(1,6), zeros(1,6)];
ominbus_matrix = diag(all_con);

for i = 1:numel(sub)
    
    
    %% Normalized space
    results_dir_c = [cf '/POF_nifti/' sub{i}, filesep, 'Results_normalized'];
    spm_mat_path = [results_dir_c, filesep, 'SPM.mat'];
    
    matlabbatch = [];
    matlabbatch{1}.spm.stats.con.spmmat = {spm_mat_path};
    
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Intact_vs_Baseline';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [1 0  zeros(1,6) 1 0  zeros(1,6)];
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Scrambled_vs_Baseline';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [0 1 zeros(1,6) 0 1 zeros(1,6)];
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Intact_vs_Scrambled';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [1 -1 zeros(1,6) 1 -1 zeros(1,6)];
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Scrambled_vs_Intact';
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = [-1 1 zeros(1,6) -1 1 zeros(1,6)];
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'Places_vs_Baseline';
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = [zeros(1,16) 1 0 0 zeros(1,6) 1 0 0 zeros(1,6) 1 0 0 zeros(1,6) 1 0 0 zeros(1,6)];
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'Faces_vs_Baseline';
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = [zeros(1,16) 0 1 0 zeros(1,6) 0 1 0 zeros(1,6) 0 1 0 zeros(1,6) 0 1 0 zeros(1,6)];
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'Objects_vs_Baseline';
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = [zeros(1,16) 0 0 1 zeros(1,6) 0 0 1 zeros(1,6) 0 0 1 zeros(1,6) 0 0 1 zeros(1,6)];
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
        
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'Places_vs_FacesObjects';
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = [zeros(1,16) 2 -1 -1 zeros(1,6) 2 -1 -1 zeros(1,6) 2 -1 -1 zeros(1,6) 2 -1 -1 zeros(1,6)];
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.name = 'Faces_vs_PlacesObjects';
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.weights = [zeros(1,16) -1 2 -1 zeros(1,6) -1 2 -1 zeros(1,6) -1 2 -1 zeros(1,6) -1 2 -1 zeros(1,6)];
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{10}.tcon.name = 'Objects_vs_PlacesFaces';
    matlabbatch{1}.spm.stats.con.consess{10}.tcon.weights = [zeros(1,16) -1 -1 2 zeros(1,6) -1 -1 2 zeros(1,6) -1 -1 2 zeros(1,6) -1 -1 2 zeros(1,6)];
    matlabbatch{1}.spm.stats.con.consess{10}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{11}.tcon.name = 'Intact_vs_Places';
    matlabbatch{1}.spm.stats.con.consess{11}.tcon.weights = [1 0  zeros(1,6) 1 0  zeros(1,6) -1 0 0 zeros(1,6) -1 0 0 zeros(1,6) -1 0 0 zeros(1,6) -1 0 0 zeros(1,6)];
    matlabbatch{1}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{12}.tcon.name = 'Intact_vs_Faces';
    matlabbatch{1}.spm.stats.con.consess{12}.tcon.weights = [1 0  zeros(1,6) 1 0  zeros(1,6) 0 -1 0 zeros(1,6) 0 -1 0 zeros(1,6) 0 -1 0 zeros(1,6) 0 -1 0 zeros(1,6)];
    matlabbatch{1}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{13}.tcon.name = 'Intact_vs_Objects';
    matlabbatch{1}.spm.stats.con.consess{13}.tcon.weights = [1 0  zeros(1,6) 1 0  zeros(1,6) 0 0 -1 zeros(1,6) 0 0 -1 zeros(1,6) 0 0 -1 zeros(1,6) 0 0 -1 zeros(1,6)];
    matlabbatch{1}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{14}.tcon.name = 'Intact_vs_ObjectsFacesPlaces';
    matlabbatch{1}.spm.stats.con.consess{14}.tcon.weights = [3 0  zeros(1,6) 3 0  zeros(1,6) -1 -1 -1 zeros(1,6) -1 -1 -1 zeros(1,6) -1 -1 -1 zeros(1,6) -1 -1 -1 zeros(1,6)];
    matlabbatch{1}.spm.stats.con.consess{14}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{15}.tcon.name = 'Places_vs_Intact';
    matlabbatch{1}.spm.stats.con.consess{15}.tcon.weights = [-1 0  zeros(1,6) -1 0  zeros(1,6) 1 0 0 zeros(1,6) 1 0 0 zeros(1,6) 1 0 0 zeros(1,6) 1 0 0 zeros(1,6)];
    matlabbatch{1}.spm.stats.con.consess{15}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{16}.tcon.name = 'Faces_vs_Intact';
    matlabbatch{1}.spm.stats.con.consess{16}.tcon.weights = [-1 0  zeros(1,6) -1 0  zeros(1,6) 0 1 0 zeros(1,6) 0 1 0 zeros(1,6) 0 1 0 zeros(1,6) 0 1 0 zeros(1,6)];
    matlabbatch{1}.spm.stats.con.consess{16}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{17}.tcon.name = 'Objects_vs_Intact';
    matlabbatch{1}.spm.stats.con.consess{17}.tcon.weights = [-1 0  zeros(1,6) -1 0  zeros(1,6) 0 0 1 zeros(1,6) 0 0 1 zeros(1,6) 0 0 1 zeros(1,6) 0 0 1 zeros(1,6)];
    matlabbatch{1}.spm.stats.con.consess{17}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{18}.tcon.name = 'ObjectsFacesPlaces_vs_Intact';
    matlabbatch{1}.spm.stats.con.consess{18}.tcon.weights = [-3 0  zeros(1,6) -3 0  zeros(1,6) 1 1 1 zeros(1,6) 1 1 1 zeros(1,6) 1 1 1 zeros(1,6) 1 1 1 zeros(1,6)];
    matlabbatch{1}.spm.stats.con.consess{18}.tcon.sessrep = 'none';
        
    matlabbatch{1}.spm.stats.con.consess{19}.tcon.name = 'Visual_vs_Baseline';
    matlabbatch{1}.spm.stats.con.consess{19}.tcon.weights = all_con;
    matlabbatch{1}.spm.stats.con.consess{19}.tcon.sessrep = 'none';    
    
    matlabbatch{1}.spm.stats.con.consess{20}.fcon.name = 'Omnibus';
    matlabbatch{1}.spm.stats.con.consess{20}.fcon.weights = ominbus_matrix;
    matlabbatch{1}.spm.stats.con.consess{20}.fcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.delete = 1;

    % Run batch
    spm_jobman('run', matlabbatch);

end

clearvars -except sub
