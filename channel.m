%channel for ofdm simulation 

pretransmitnoise = wgn(1000, 1, 0);  
pretransmitnoise = pretransmitnoise./100;
input = read_usrp_data_file('txlab.dat'); 

% put it through the channel

impulseresponse = [1]; %[-0.3, 1, -0.4, -0.1, -0.4, -0.3, -0.5, -0.2, -0.1, -0.5, 1, -0.2, -0.15, -0.33, -0.8];

% impulseresponse = 1;
channelout = conv(input, impulseresponse);

% add noise
noise = 0.003.*wgn(length(channelout), 1, 0); 
% figure
% plot(noise);
rxthru = channelout + noise; 
figure(1)
clf;
plot(real(input), 'r');
hold on
plot(real(rxthru), 'k');
legend('input', 'through channel');

thruchannel = [pretransmitnoise; rxthru];
% thruchannel = rxthru;

write_usrp_data_file(thruchannel, 'rxchannel.dat');