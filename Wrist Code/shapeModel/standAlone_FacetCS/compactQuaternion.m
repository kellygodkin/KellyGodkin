function qvec = compactQuaternion(q)
%COMPACTQUATERNION Extracts quaternion components [w x y z] from a quaternion object
%   Accepts input in the form of MATLAB's quaternion object
%   Example input: q = quaternion(0.99619, 0.068049, 0.010987, -0.053336)

    if isa(q, 'quaternion')
        % Extract components directly
        w = q.s;  % scalar part
        vec_part = q.v;   % [x y z]
        x = vec_part(1);  % x-component
        y = vec_part(2);  % y-component
        z = vec_part(3);  % z-component
        qvec = [w, x, y, z];

    else
        error('Input must be a quaternion object from MATLAB''s quaternion class.');
    end
end
