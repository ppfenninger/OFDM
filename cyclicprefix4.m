function res = cyclicprefix4(k)
    %make matrix of last 4 columns 
    x(:,1:4) = k(:,13:16);
    x(:,5:20) = k;
    res = x;
end

