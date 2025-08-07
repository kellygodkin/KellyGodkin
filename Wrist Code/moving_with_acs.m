%%

close all;
clear all;
clc;

addpath(genpath('C:\Users\kelly\GitHub'));  
filepath_base = 'P:\Data\2025-04-09 Carpometacarpal Pilot';


load(fullfile(filepath_base,'preprocessing\structures\bonestruct_cpdr.mat'),"bonestruct");

bonestruct = mc1_tpm(bonestruct);
bonestruct = tpm_sca(bonestruct);
bonestruct = sca_rad(bonestruct);