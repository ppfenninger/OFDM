This project was made by Lisa Hachmann, Anisha Nakagawa and Paige Pfenninger for the Analog and Digital Communications course at Olin College. This is our final project, completed in December 2017.

The project sends information using Orthogonal Frequency Division Multiplexing (OFDM) over Universal Software Radio Peripherals (USRPs). Follow their instructions to set up the USRPs’ software. The data is encoded and decoded using MATLAB.

How to run:
Generate a file to send by running tx_great.m. Alternatively, tx.dat has a working version to data to send over the USRP.
On one computer, transmit the data over the USRP using the command prompt with:
```
tx_samples_from_file.exe --gain 70 --freq 2491000000 --file tx.dat --rate 250e3 --type float --ref external --spb 1024 
```
On the second computer, receive the data by running the command prompt as an administrator using the command:
```
rx_samples_to_file.exe --gain 50 --freq 2491000000 --file rx.dat --rate 250e3 --type float --ref external  --spb 1024 
```
We recommend that nothing moves in the transmission time. 

Extract the data by running rx_great.m. Alternatively, a version of the received data is in rx.dat, from one of our experimental runs.

Using our data:
To use our successful transmission data in rx_great.m, change line 7 to
```
rawInput = read_usrp_data_file('rxBEAUTIFULl.dat'); 
```

Previous versions: 
We did not remove our process, but instead moved all previous iterations into the previousVersions folder. We don’t recommend using this code, but it is a full documentation of our process. 
