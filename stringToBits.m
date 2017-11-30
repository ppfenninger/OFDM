function res = stringToBits(S)
    v = zeros([1, length(S)]);
    
    for i = 1:length(S)
        chars=dec2bin(S(i), 8);
        for j = 1:8
            if chars(j) == '1'
                v((i-1)*8 + j) = 1;
            else
                v((i-1)*8 + j) = 0; 
            end
        end
    end
    res = v;
end 