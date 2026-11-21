function z = fisher_z(r)
% FISHER_Z  Fisher r-to-z transform, z = atanh(r).
%   r is clipped to +/-(1 - 1e-7) so the diagonal (r = 1) stays finite.
%   Inverse: r = tanh(z).
lim = 1 - 1e-7;
r(r >  lim) =  lim;
r(r < -lim) = -lim;
z = atanh(r);
end
