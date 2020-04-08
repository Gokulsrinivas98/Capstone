function[AF]= MyCostCapstone2(x,u)
    
    [M,N] = size(x);
    AF = zeros(M,length(u));
%     size(AF)
    i = (1:N)';
    for k = 1:M
        AF(k,:) = abs(2*x(k,:)*cos((2*i-1)*pi*0.5*u))/(2*sum(x(k,:)));
    end
end 