function res = cyclicprefix(k, lengthcp)
    %make matrix of last lengthcp columns, no matter the input size
    [~,col] = size(k); 
    x(:,1:lengthcp) = k(:,(col-(lengthcp-1)):col);
    x(:,(lengthcp+1):(col+lengthcp)) = k;
    res = x;
end