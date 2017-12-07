function res = bitsToString(B)
    str = '';
    numNotChar = 0;
    for i = 1:floor(length(B) / 8)
        char = '';
        for j = 1:8
           if B((i-1)*8 + j) == 1
               char = strcat(char, '1');
           else
               char = strcat(char, '0'); 
           end
        end
       
       if ischar(bin2dec(char));
           str = strcat(str, bin2dec(char)); 
       else
           numNotChar = numNotChar + 1; 
       end 
    end
    disp(numNotChar); 
    res = str;
end