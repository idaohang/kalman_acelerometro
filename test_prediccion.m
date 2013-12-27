% estados
% [p_x, v_x, a_x, p_y, v_y, a_y, p_z, v_z, a_z]

x0 = zeros(9,0);

dt = 0.1;
Ai = [1 dt dt.^2*0.5; 0 1 dt; 0 0 1];

A = blkdiag(Ai,Ai,Ai)