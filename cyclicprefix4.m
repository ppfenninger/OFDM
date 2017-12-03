function res = cyclicprefix4(k)
    %make matrix of last 4 columns, no matter the input size
    [~,col] = size(k); 
    x(:,1:4) = k(:,(col-3):col);
    x(:,5:(col+4)) = k;
    res = x;
end