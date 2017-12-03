function res = tx_cos(bin, cosmult, symbolrate) %bin = column
    time = length(bin)/symbolrate; %how much time we have to transmit
    cossig = cos(2*pi*cosmult*linspace(0,length(time), length(bin))); %cosine for that 
   %plot(cossig);
    signal = bin'.*cossig; 
    res = signal;
end

