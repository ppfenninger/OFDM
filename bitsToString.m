function res = bitsToString(B)
    str = '';
    for i = 1:floor(length(B) / 8)
        charthing = '';
        for j = 1:8
           if B((i-1)*8 + j) == 1
               charthing = strcat(charthing, '1');
           else
               charthing = strcat(charthing, '0'); 
           end
        end
       
       str = strcat(str, char(bin2dec(charthing))); 
    end
    res = str;
end