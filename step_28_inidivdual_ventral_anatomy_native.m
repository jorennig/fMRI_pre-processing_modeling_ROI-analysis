clear all
close all
clc

cf = pwd;

sub = {'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR'};

%% Create individual ventral ROIs
% LOC: 11158/12158, 11160/12160, 11159/12159 ﻿(anterior, middle, superior occipital cortex)
% FFA:﻿11121/12121 (fusiform gyrus)
% PPA: 11123/12123 (parahippocampal gyrus)

for i = 1:numel(sub)

    % Read APARC
    dir_roi = [cf '/POF_nifti/' sub{i} '/ROIs_native'];
    aparc = fullfile(dir_roi, 'aparc.a2009s+aseg.nii');
    aparc_hdr = spm_vol(aparc); % get header of image
    aparc_img = spm_read_vols(aparc_hdr); % read image
    
    %% LOC anatomy ROI    
    aoc_l = double(aparc_img == 11158); % anterior occipital cortex
    moc_l = double(aparc_img == 11160); % middle occipital cortex
    soc_l = double(aparc_img == 11159); % superior occipital cortex
    
    aoc_r = double(aparc_img == 12158); % anterior occipital cortex
    moc_r = double(aparc_img == 12160); % middle occipital cortex
    soc_r = double(aparc_img == 12159); % superior occipital cortex
    
    loc_anatomy_l = aoc_l + moc_l + soc_l;
    loc_anatomy_l(loc_anatomy_l < 1) = 0;
    loc_anatomy_l(loc_anatomy_l >= 1) = 1;

    aparc_hdr.fname = [dir_roi, filesep, 'loc_anatomy_l.nii'];
    aparc_hdr.private.dat.fname = aparc_hdr.fname;
    spm_write_vol(aparc_hdr, loc_anatomy_l);

    loc_anatomy_r = aoc_r + moc_r + soc_r;
    loc_anatomy_r(loc_anatomy_r < 1) = 0;
    loc_anatomy_r(loc_anatomy_r >= 1) = 1;

    aparc_hdr.fname = [dir_roi, filesep, 'loc_anatomy_r.nii'];
    aparc_hdr.private.dat.fname = aparc_hdr.fname;
    spm_write_vol(aparc_hdr, loc_anatomy_r);

    %% FFA anatomy ROI    
    ffa_anatomy_l = double(aparc_img == 11121); % fusiform gyrus
    
    ffa_anatomy_r = double(aparc_img == 12121); % fusiform gyrus
    
    ffa_anatomy_l(ffa_anatomy_l < 1) = 0;
    ffa_anatomy_l(ffa_anatomy_l >= 1) = 1;

    aparc_hdr.fname = [dir_roi, filesep, 'ffa_anatomy_l.nii'];
    aparc_hdr.private.dat.fname = aparc_hdr.fname;
    spm_write_vol(aparc_hdr, ffa_anatomy_l);

    ffa_anatomy_r(ffa_anatomy_r < 1) = 0;
    ffa_anatomy_r(ffa_anatomy_r >= 1) = 1;

    aparc_hdr.fname = [dir_roi, filesep, 'ffa_anatomy_r.nii'];
    aparc_hdr.private.dat.fname = aparc_hdr.fname;
    spm_write_vol(aparc_hdr, ffa_anatomy_r);

    %% PPA anatomy ROI    
    ppa_anatomy_l = double(aparc_img == 11123); % fusiform gyrus
    
    ppa_anatomy_r = double(aparc_img == 12123); % fusiform gyrus
    
    ppa_anatomy_l(ppa_anatomy_l < 1) = 0;
    ppa_anatomy_l(ppa_anatomy_l >= 1) = 1;

    aparc_hdr.fname = [dir_roi, filesep, 'ppa_anatomy_l.nii'];
    aparc_hdr.private.dat.fname = aparc_hdr.fname;
    spm_write_vol(aparc_hdr, ppa_anatomy_l);

    ppa_anatomy_r(ppa_anatomy_r < 1) = 0;
    ppa_anatomy_r(ppa_anatomy_r >= 1) = 1;

    aparc_hdr.fname = [dir_roi, filesep, 'ppa_anatomy_r.nii'];
    aparc_hdr.private.dat.fname = aparc_hdr.fname;
    spm_write_vol(aparc_hdr, ppa_anatomy_r);
    
end
