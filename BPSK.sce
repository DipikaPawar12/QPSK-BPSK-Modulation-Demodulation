clear;
clf;
fm = 1; //Modulating wave frequency
dt = 0.001;
T = 2;
t = 0:dt:T;
m = sin(2*%pi*fm*t); //Modulating signal
//*********************Level Converter Block*****************//
N = length(t);
modulating_signal = zeros(1:N);
for i=1:N
 if m(i)>0 then
 modulating_signal(i) = 1; //Modulating square wave
 else
 modulating_signal(i) = -1; //Modulating square wave
 end
10
end
fc = 10; //Carrier wave frequency
Ac = 5; //Carrier wave amplitude
carrier_signal = Ac*cos(2*%pi*fc*t); //Carrier signal
phi = sqrt(2/T)*carrier_signal; //Orthogonal component
psk = carrier_signal.*modulating_signal; //Phase modulated wave
 // Transmitted Signal
//*****Addition of Gaussian Noise in Transmitted signal*****//
noiseVariance = 0.1;
noise = sqrt(noiseVariance)*rand(1,length(psk)); //Generation of
noise
transmitted_signal = psk+noise; //Addition of noise to signal(Transmitted signal)
dm = (transmitted_signal).*phi; //Received Signal
//*********************Demodulation Block********************//
demodulated_signal = zeros(1:N);
for i=1:N
 demodulated_signal(i) = (dm(i)*dt);//Integration of received signal
end
final_signal = zeros(1:N);
N = length(t);
//*******************Decision Making Block*******************//
for i = 1:N
 if demodulated_signal(i)>0 then
 final_signal(i) = 1; //Output of decision block
 else
 final_signal(i) = -1; //Output of decision block
 end
end
//**************Bit Error Probability Calculation*************//
count = 0;
for i=1:N
 if final_signal(i)==modulating_signal(i) then
 count = count;
 else
 count = count+1;
 end
end
disp(count); //Wrong number of samples
disp(count/N); //Displaying bit error probability = wrong samples/total number of samples
//**************************Plots*****************************//
//Modulating signal
subplot(321);
plot(t,modulating_signal);
xgrid(3);
xlabel("time","fontsize",2);
ylabel("amplitude","fontsize",2);
title("Modulating signal", "fontsize", 4);
//Carrier signal
subplot(322);
plot(t,carrier_signal);
xgrid(3);
xlabel("time","fontsize",2);
ylabel("amplitude","fontsize",2);
title("Carrier signal", "fontsize", 4);
//Modulated signal
subplot(323);
plot(t,psk);
xgrid(3);
xlabel("time","fontsize",2);
ylabel("amplitude","fontsize",2);
title("BPSK transmitted signal", "fontsize", 4);
//transmitted signal with noise
subplot(324);
plot(t,transmitted_signal);
13
xgrid(3);
xlabel("time","fontsize",2);
ylabel("amplitude","fontsize",2);
title("Signal with noise", "fontsize", 4);
//Received demodulated Signal
subplot(325);
plot(t,demodulated_signal);
xgrid(3);
xlabel("time","fontsize",2);
ylabel("amplitude","fontsize",2);
title("Demodulated signal", "fontsize", 4);
//Received demodulated square signal
subplot(326);
plot(t,final_signal);
xgrid(3);
xlabel("time","fontsize",2);
ylabel("amplitude","fontsize",2);
title("Demodulated signal from decision box", "fontsize", 4);
