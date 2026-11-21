function r = corr_cols(A, B)
% CORR_COLS  Pearson correlation between every column of A and every column of B.
%   A: [time x m], B: [time x n]  ->  r: [m x n]
A = bsxfun(@minus, A, mean(A, 1));
B = bsxfun(@minus, B, mean(B, 1));
A = bsxfun(@rdivide, A, sqrt(sum(A.^2, 1)));
B = bsxfun(@rdivide, B, sqrt(sum(B.^2, 1)));
r = A' * B;
end
