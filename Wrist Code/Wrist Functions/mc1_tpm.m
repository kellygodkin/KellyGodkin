%% Registering MC1 ACS to tpm

function bonestruct = mc1_tpm(bonestruct)



for s = 1:size(bonestruct.rad,2)-1
    for p = 1:numel(fields(bonestruct.mc1(1).transforms))
        tpm_cs = bonestruct.(bonecode_hand(8))(s).acs(:,:);
        tpmN = bonestruct.(bonecode_hand(8))(s).transforms.(position(p,'R'))(:,:);
        tpmACSp = tpmN * tpm_cs;
        bonestruct.(bonecode_hand(8))(s).acsR.(position(p,'R')) =  tpmACSp ;
  
        mc1_cs = bonestruct.(bonecode_hand(11))(s).acs(:,:);
        mc1N = bonestruct.(bonecode_hand(11))(s).transforms.(position(p,'R'))(:,:);
        mc1ACSp = mc1N * mc1_cs;

        bonestruct.(bonecode_hand(11))(s).acsR.(position(p,'R')) =  mc1ACSp ; 
    end
end
return;


