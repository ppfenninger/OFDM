function res = bitsToString(B)
    str = '';
    for i = 1:floor(length(B) / 8)
        char = '';
        for j = 1:8
           if B((i-1)*8 + j) == 1
               char = strcat(char, '1');
           else
               char = strcat(char, '0'); 
           end
        end
       str = strcat(str, bin2dec(char)); 
    end
    res = str;
end