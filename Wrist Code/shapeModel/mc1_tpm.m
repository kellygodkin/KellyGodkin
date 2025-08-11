%% Registering MC1 ACS to tpm

function bonestruct = mc1_tpm(bonestruct)

b = 11;
for s = 1:size(bonestruct.rad,2)-1
    for p = 1:numel(fields(bonestruct.mc1(1).transforms))
        
        mc1_cs = bonestruct.(bonecode_hand(11))(s).acs.cmccs;
        tpm_cs = bonestruct.(bonecode_hand(8))(s).acs.cmccs;
        mc1_csR = tpm_cs^-1 * mc1_cs;
        bonestruct.(bonecode_hand(b))(s).acsR.cmc = mc1_csR;
  
    end
end
return;


