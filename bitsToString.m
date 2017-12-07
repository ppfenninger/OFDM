function res = bitsToString(B)
    str = '';
    numNotChar = 0;
    for i = 1:floor(length(B) / 8)
        charthing = '';
        for j = 1:8
           if B((i-1)*8 + j) == 1
               charthing = strcat(charthing, '1');
           else
               charthing = strcat(charthing, '0'); 
           end
        end
       
       if ischar(char(bin2dec(charthing)));
           str = strcat(str, bin2dec(charthing)); 
       else
           numNotChar = numNotChar + 1; 
       end 
    end
    disp(numNotChar); 
    res = str;
end