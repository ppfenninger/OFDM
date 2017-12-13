function res = serialtoParallel_16(x) % make the matrix of data, prepped for cyclic prefix
    for i= 1:length(x) 
        columns = ceil(i/16); %row
        rows = mod(i, 16); %need to see which spot in the row we are at (column)
        if rows == 0 %mod so the 0th is the 16th element
            rows = 16; 
        end
        spmatrix16(columns, rows)= x(i); %trust me
    end
    res = spmatrix16;
end

