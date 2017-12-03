function res = serialtoParallel(x, n) % make the matrix of data, prepped for cyclic prefix changes
%x is the data
%n is the length of the row in parallel 
    for i= 1:length(x) 
        r = ceil(i/n); %row
        columns = mod(i, n); %need to see which spot in the row we are at (column)
        if columns == 0 %mod so the 0th is the nth element
            columns = n; 
        end
        spmatrix(r, columns)= x(i); %trust me
    end
    res = spmatrix;
end

