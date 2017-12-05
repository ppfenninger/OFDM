%channel for ofdm simulation 

pretransmitnoise = wgn(1000, 1, 0);  

inputwn = read_usrp_data_file('tx.dat'); 
noise = 0.003.*wgn(length(inputwn), 1, 0); 
% figure
% plot(noise);
rxthru = inputwn + noise; 
% figure 
% plot(real(inputwn), 'r');
% hold on
% plot(real(rxthru), 'k');

thruchannel = [pretransmitnoise; rxthru];

write_usrp_data_file(thruchannel, 'rxchannel.dat');