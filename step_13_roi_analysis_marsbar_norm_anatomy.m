%clear all
close all
clc

cf = pwd;

%load('roi_tot.mat');
con = 16;

marsbar('on');

for i = 1:numel(sub)
    
    % Normalized space
    results_dir_c = [cf '/POF_nifti/' sub{i}, filesep, 'Results_normalized'];
    
    spm_file = fullfile(results_dir_c, 'spm.mat');
    
    roi_folder = [cf '/POF_nifti/' sub{i}, filesep, 'ROIs_norm'];
     
    rois = dir(fullfile(roi_folder, 'TPJ_Anatomy*.mat'));
    rois = {rois(:).name}';
        
%     rois_c = roi_tot(startsWith(roi_tot.roi, sub{i}), :);
%     rois_c_vox = table2array(rois_c(:, 2:3));
%     rois_c_vox = reshape(rois_c_vox', [numel(rois_c_vox), 1]);
    
    for j = 1:numel(rois)
        
        roi_c = rois{j};
        roi_c = fullfile(roi_folder, roi_c);

        % Load design   
        D = mardo(spm_file);
        %D = autocorr(D, 'fmristat', 2); % to avoid the ReML error
        % Load ROI into analysis
        R = maroi(roi_c);
        % Marsbar data object
        Y = get_marsy(R, D, 'mean');
        % Estimate design on data object
        E = estimate(D, Y);

        % e_specs = 1. row: session, 2. row: number of event; e_names = name of events
        [e_specs, e_names] = event_specs(E);

        % Extraction of event types/names
        ets = event_types_named(E);
        n_event_types = length(ets);
        n_events = size(e_specs, 2);
        dur = 0;

        % extract % signal change, creates % per event
        data = []; % empty data vector at start of each roi assessed
        for e_s = 1:n_events
            pct_ev(e_s) = event_signal(E, e_specs(:,e_s), dur);
            data(e_s) = pct_ev(e_s);
        end
            
        %data_tot(j,1:con) = data;
        roi_name_c = erase(rois{j}, '_roi.mat');
        psc_rois.(roi_name_c)(i,:) = data;
        
    end
    
end

save('psc_rois.mat', 'psc_rois');

%% Summary
load('psc_rois.mat')
clearvars -except psc_rois sub

rois = fieldnames(psc_rois);

var_names = {'Global_Run1', 'Global_Run2', 'Scrambled_Run1', 'Scrambled_Run2', 'Places_Run1', 'Faces_Run1', 'Objects_Run1', 'Places_Run2', 'Faces_Run2', 'Objects_Run2', 'Places_Run3', 'Faces_Run3', 'Objects_Run3', 'Places_Run4', 'Faces_Run4', 'Objects_Run4'};

roi_results = 'ROI_Results_norm_Anatomy';
mkdir(roi_results)

for i = 1:numel(rois)
    
    data_c = psc_rois.(rois{i});
    data_ct = data_c(:,[1,3, 2,4, 5,8,11,14, 6,9,12,15, 7,10,13,16]); % Global, Scrambled, Places, Faces, Objects
    data_ct = array2table(data_ct, 'VariableNames', var_names);
    
    psc_rois.(rois{i}) = data_ct;
    
    writetable(data_ct, fullfile(roi_results, [rois{i} '.txt']));
    
end

roi_type = 'Baseline';
rois_baseline = rmfield(psc_rois, rois(find(cellfun(@isempty, strfind(rois, roi_type)))));
roi_type = 'Intact_Scrambled';
rois_intact_scrambled = rmfield(psc_rois, rois(find(cellfun(@isempty, strfind(rois, roi_type)))));

clearvars -except sub
