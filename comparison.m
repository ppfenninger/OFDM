%% compare

% txOutput = read_usrp_data_file('tx.dat');
estimateBits = rxserialbits;
lowesterror = 50; 
index = 0; 

for x = 1: 10000
   sumerrors = 0; 
    for w = 1:length(datarawinput)
        if estimateBits(w+x) ~= datarawinput(w)
            sumerrors = sumerrors +1;
        end
    end

    biterrorrate = 100*sumerrors/length(datarawinput);
    if biterrorrate < lowesterror 
        lowesterror = biterrorrate; 
        index = x; 
    end
end

disp(lowesterror);