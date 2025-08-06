function bonestruct = fix_bones(ref_bone,bonestruct,ref_pos,hand)

if isnumeric(ref_bone) == 1
    ref_bone = bonecode_hand(ref_bone);
end

for s = 1:length(bonestruct.(ref_bone))
    for p = 1:numel(fields(bonestruct.(ref_bone)(s).transforms))
        for b = 1:numel(fields(bonestruct))
            bonestruct.(bonecode_hand(b))(s).reg_trans.(position(p,hand)) = bonestruct.(ref_bone)(s).transforms.(ref_pos)^-1*bonestruct.(bonecode_hand(b))(s).transforms.(position(p,hand));
            % fixed_transform =  bonestruct.(bonecode_hand(b))(s).reg_trans.(position(p,hand));
        end
    end
end
