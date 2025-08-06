function position_out = position(position_in,hand)
% This function returns the corresponding identifier for the carpal bones.
% If input is the bone number, output is the 3-letter bone name. If input
% is the full bone name, or 3-letter name, output is the bone number.

% if ischar(position_in)
%     position_in = lower(position_in);
% end %if
if hand =='R'
    switch position_in
        
        case 'neutral'
            position_out = 'S15R';
        case 1
            position_out = 'S15R';
        case 2
            position_out = 'S02R';
        case 3
            position_out = 'S03R';
        case 4
            position_out = 'S04R';
        case 5
            position_out = 'S05R';
        case 6
            position_out = 'S06R';
        case 7
            position_out = 'S07R';
        case 8
            position_out = 'S08R';
        case 9
            position_out = 'S09R';
        case 10
            position_out = 'S10R';
        case 11
            position_out = 'S11R';
        case 12
            position_out = 'S12R';
        case 13
            position_out = 'S13R';
        case 14
            position_out = 'S14R';
        case 15
            position_out = 'S15R';
            

        case 'S02R'
            position_out = '2';
        case 'S03R'
            position_out = '3';
        case 'S04R'
            position_out = '4';
        case 'S05R'
            position_out = '5';
        case 'S06R'
            position_out = '6';
        case 'S07R'
            position_out = '7';
        case 'S08R'
            position_out = '8';
        case 'S09R'
            position_out = '9';
        case 'S10R'
            position_out = '10';
        case 'S11R'
            position_out = '11';
        case 'S12R'
            position_out = '12';
        case 'S13R'
            position_out = '13';
        case 'S14R'
            position_out = '14';
        case 'S15R'
            position_out = '15';
        otherwise 
            disp('Invalid Entry')
            return
    
    end
end

    
if hand =='L'
    switch position_in
        
        case 'neutral'
            position_out = 'S15L';
        case 2
            position_out = 'S02L';
        case 3
            position_out = 'S03L';
        case 4
            position_out = 'S04L';
        case 5
            position_out = 'S05L';
        case 6
            position_out = 'S06L';
        case 7
            position_out = 'S07L';
        case 8
            position_out = 'S08L';
        case 9
            position_out = 'S09L';
        case 10
            position_out = 'S10L';
        case 11
            position_out = 'S11L';
        case 12
            position_out = 'S12L';
        case 13
            position_out = 'S13L';
        case 14
            position_out = 'S14L';
        case 15
            position_out = 'S15L';
            

        case 'S02L'
            position_out = '2';
        case 'S03L'
            position_out = '3';
        case 'S04L'
            position_out = '4';
        case 'S05L'
            position_out = '5';
        case 'S06L'
            position_out = '6';
        case 'S07L'
            position_out = '7';
        case 'S08L'
            position_out = '8';
        case 'S09L'
            position_out = '9';
        case 'S10L'
            position_out = '10';
        case 'S11L'
            position_out = '11';
        case 'S12L'
            position_out = '12';
        case 'S13L'
            position_out = '13';
        case 'S14L'
            position_out = '14';
        case 'S15L'
            position_out = '15';
        otherwise 
            disp('Invalid Entry')
            return
end
   

end %switch
    