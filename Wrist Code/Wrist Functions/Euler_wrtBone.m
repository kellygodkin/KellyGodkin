function bonestruct = Euler_wrtBone(bonestruct,bone_fixed)

for b = 1:numel(fields(bonestruct))
    for s = 1:size(bonestruct.rad,2)-1
        for p = 1: numel(fields(bonestruct.trq(1).transforms))
    
            if bone_fixed == 8 || bone_fixed == 11
                fixed_temp = bonestruct.(bonecode_hand(bone_fixed))(s).acsR.(position(p,'R'));
            else
                fixed_temp = bonestruct.(bonecode_hand(b))(s).transforms.(positions{p}) * bonestruct.(bonecode_hand(b))(s).csys_fixed;
            end
        
            if b == 1||b == 2||b == 8||b == 11
                temp = bonestruct.(bonecode_hand(bone_fixed))(s).acsR.(position(p,'R'));
            else
                temp = bonestruct.(bonecode_hand(b))(s).transforms.(positions{p}) * bonestruct.(bonecode_hand(b))(s).csys_fixed;
            end
            eul_temp = fixed_temp^-1 * temp;
            bonestruct.(bonecode_hand(b))(s).Euler.(bonecode_hand(bone_fixed)) = eul(eul_temp(1:3,1:3));
        end
    end
end
return;