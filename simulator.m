clear all
close all

[input_signal,Fs]=audioread('pink_panther.au'); %Read input_signal from .au file at Fs=8kHz (file must be located in the Matlab working directory).

%Prepare output signals, one for each packet reconstruction method, of same size as input signal.
output_signal_1=zeros(length(input_signal),1); %Alternative 1: Playing silence (writing all 0s):
output_signal_2=zeros(length(input_signal),1); %Alternative 2: Replaying the last sample:                       
output_signal_3=zeros(length(input_signal),1); %Alternative 3: Playing the entire last packet received:

%PARAMETERS TO BE CHANGED FOR EXPERIMENTAL PURPOSES:
packet_size=4; %Size of each packet to be sent/received.
loss_rate=0.5; %Loss rate, from 0 to 1.

for i=1:packet_size:length(input_signal)-(packet_size-1)   
    
    packet=input_signal(i:i+(packet_size-1),1); %Take packet from input_signal:
    a=rand(1,1);
    
    if (a<loss_rate)
        %Alternative 1: Playing silence (writing all 0s):
        packet(:)=0;
        output_signal_1(i:i+(packet_size-1))=packet;

        %Alternative 2: Replaying last sample:
        if (i>packet_size)
            packet(:)=input_signal(i-1,1);
            output_signal_2(i:i+(packet_size-1))=packet;
        end

        %Alternative 3: Playing the entire last packet received:
        if (i>packet_size)
            packet(:)=input_signal(i-packet_size:i-1);
            output_signal_3(i:i+(packet_size-1))=packet;
        end
    else 
        %Store the received sample:
        output_signal_1(i:i+(packet_size-1))=packet;
        output_signal_2(i:i+(packet_size-1))=packet;
        output_signal_3(i:i+(packet_size-1))=packet;
    end
end

%Create .au files from outputs:
filename = 'out_alternative1.wav';
audiowrite(filename,output_signal_1,Fs);
filename = 'out_alternative2.wav';
audiowrite(filename,output_signal_2,Fs);
filename = 'out_alternative3.wav';
audiowrite(filename,output_signal_3,Fs);

%Plot results in time domain:
t=(0:length(input_signal)-1)/8000;
figure(1)
subplot(2,2,1)
plot(t,input_signal,'red')
title('Input audio')
xlabel('Time (s)')
ylabel('Amplitude')
subplot(2,2,2)
plot(t,output_signal_1)
title('Output audio: Playing silence')
xlabel('Time (s)')
ylabel('Amplitude')
subplot(2,2,3)
plot(t,output_signal_2)
title('Output audio: Replaying the last sample')
xlabel('Time (s)')
ylabel('Amplitude')
subplot(2,2,4)
plot(t,output_signal_3)
title('Output audio: Playing the entire last packet received')
xlabel('Time (s)')
ylabel('Amplitude')


%Analysis of frequency domain:
Fs=8000; 

NFFT1=2^nextpow2(length(input_signal));
S1=fft(input_signal,NFFT1)/length(input_signal);
freq=Fs/2*linspace(0,1,NFFT1/2+1);
NFFT2=2^nextpow2(length(output_signal_1));
S2=fft(output_signal_1,NFFT2)/length(output_signal_1);
freq=Fs/2*linspace(0,1,NFFT2/2+1);
NFFT3=2^nextpow2(length(output_signal_2));
S3=fft(output_signal_2,NFFT3)/length(output_signal_2);
freq=Fs/2*linspace(0,1,NFFT3/2+1);
NFFT4=2^nextpow2(length(output_signal_3));
S4=fft(output_signal_3,NFFT4)/length(output_signal_3);
freq=Fs/2*linspace(0,1,NFFT4/2+1);

%Plot results:
figure(2)
subplot(2,2,1)
plot(freq,2*abs(S1(1:NFFT1/2+1)),'red') 
title('Input Signal Spectrum')
xlabel('Frequency (Hz)')
ylabel('|S(f)|')
subplot(2,2,2)
plot(freq,2*abs(S2(1:NFFT2/2+1))) 
title('Output Signal Spectrum (Playing silence)')
xlabel('Frequency (Hz)')
ylabel('|S(f)|')
subplot(2,2,3)
plot(freq,2*abs(S3(1:NFFT3/2+1))) 
title('Output Signal Spectrum (Replaying the last sample)')
xlabel('Frequency (Hz)')
ylabel('|S(f)|')
subplot(2,2,4)
plot(freq,2*abs(S4(1:NFFT4/2+1))) 
title('Output Signal Spectrum (Playing the entire last packet received)')
xlabel('Frequency (Hz)')
ylabel('|S(f)|')