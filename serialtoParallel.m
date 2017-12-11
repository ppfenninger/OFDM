function res = serialtoParallel(x, n) % make the matrix of data, prepped for cyclic prefix changes
    x = [x, zeros(1, (n*ceil(length(x)/n) - length(x)))]; 
    res = reshape(x, [n, (ceil(length(x)/n))]).';
end

