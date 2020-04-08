function [AF] = LinAF_func(W,u)
% LinAF Produces an array factor for an N element uniform linear array
%    AF = arrayfactor(th,N,d) produces the array factor for an N element
%    uniform linear array at the specified angles in 'th' corresponding to
%    an element spacing 'd'.

% w is of size MxN, M - # of samples, N - # of elements in array
% d is assumed half wavelength spacing


[M,N] = size(W);
AF = zeros(M,length(u));

   
i = (1:N)';
for k = 1:M
    AF(k,:) = abs(2*W(k,:)*cos((2*i-1)*pi*0.5*u))/(2*sum(W(k,:)));
end


