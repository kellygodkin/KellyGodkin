function boneout = bonecode(bonein)
% This function returns the corresponding identifier for the carpal bones.
% If input is the bone number, output is the 3-letter bone name. If input
% is the full bone name, or 3-letter name, output is the bone number.

if ischar(bonein)
    bonein = lower(bonein);
end %if

switch bonein
    case 'radius'
        boneout = 1;
    case 'ulna'
        boneout = 2;
    case 'scaphoid'
        boneout = 3;
    case 'lunate'
        boneout = 4;
    case 'triquetrum'
        boneout = 5;
    case 'pisiform'
        boneout = 6;
    case 'trapezoid'
        boneout = 7;
    case 'trapezium'
        boneout = 8;
    case 'capitate'
        boneout = 9;
    case 'hamate'
        boneout = 10;
    case 'mc1'
        boneout = 11;
    case 'mc2'
        boneout = 12;
    case 'mc3'
        boneout = 13;
    case 'mc4'
        boneout = 14;
    case 'mc5'
        boneout = 15;
        
    case 'rad'
        boneout = 1;
    case 'uln'
        boneout = 2;
    case 'sca'
        boneout = 3;
    case 'lun'
        boneout = 4;
    case 'trq'
        boneout = 5;
    case 'pis'
        boneout = 6;
    case 'tpd'
        boneout = 7;
    case 'tpm'
        boneout = 8;
    case 'cap'
        boneout = 9;
    case 'ham'
        boneout = 10;
    case 'mc1'
        boneout = 11;
    case 'mc2'
        boneout = 12;
    case 'mc3'
        boneout = 13;
    case 'mc4'
        boneout = 14;
    case 'mc5'
        boneout = 15;
    
    case 1
        boneout = 'rad';
    case 2
        boneout = 'uln';
    case 3
        boneout = 'sca';
    case 4
        boneout = 'lun';
    case 5
        boneout = 'trq';
    case 6
        boneout = 'pis';
    case 7
        boneout = 'tpd';
    case 8
        boneout = 'tpm';
    case 9
        boneout = 'cap';
    case 10
        boneout = 'ham';
    case 11
        boneout = 'mc1';
    case 12
        boneout = 'mc2';
    case 13
        boneout = 'mc3';
    case 14
        boneout = 'mc4';
    case 15
        boneout = 'mc5';
        
    otherwise 
        disp('Invalid Entry')
        return
end %switch
    