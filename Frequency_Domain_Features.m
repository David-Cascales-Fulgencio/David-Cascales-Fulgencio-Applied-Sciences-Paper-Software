function [all_12k_sets_frequency_domain_features] = Frequency_Domain_Features(Signal, RPM, BPFO_coeff, BPFI_coeff, BSF_coeff, Fault_code)

%'Frequency_Domain_Features' produces a table containing the following
%features/signal: [BPFO_Amplitude, BPFI_Amplitude, BSF_Amplitude,
%LOG_BPFI_Amplitude_BPFO_Amplitude, LOG_BSF_Amplitude_BPFO_Amplitude,
%LOG_BPFI_Amplitude_BSF_Amplitude].

%Inputs' description

    %'Signal' is a cell array containing healthy and faulty REBs'
    %time-domain vibration signals. Faults are located on the inner race,
    %outer race and balls.
    
    %'RPM' is a cell array of the same dimensionality as the latter,
    %containing the shaft rotating speed in rpm of each signal.
    
    %'BPFO_coeff' is a cell array of the same dimensionality as the latter,
    %containing a coefficient for each signal, such that the shaft rotating
    %speed times that coefficient gives the outer race fault's
    %characteristic frequency in Hz.
    
    %'BPFI_coeff' is a cell array of the same dimensionality as the latter,
    %containing a coefficient for each signal, such that the shaft rotating
    %speed times that coefficient gives the inner race fault's
    %characteristic frequency in Hz.
    
    %'BPFO_coeff' is a cell array of the same dimensionality as the latter,
    %containing a coefficient for each signal, such that the shaft rotating
    %speed times that coefficient gives the ball fault's characteristic
    %frequency in Hz.
 
    %'Fault_code' is a cell array of the same dimensionality as the latter,
    %containing labels for each type of signal (healthy REB, inner race
    %fault, outer race fault, ball fault), for later classification.

%Reference

    %[1] Cascales Fulgencio, D.; Quiles Cucarella, E.; García Moreno, E.
    %Computation and Statistical Analysis of Bearings’ Time- and
    %Frequency-Domain Features Enhanced Using Cepstrum Pre-Whitening: A ML-
    %and DL-Based Classification.
    %Appl. Sci. 2022.
    
%------------------------------
%Author: David Cascales Fulgencio
%Last revision: 17/09/2022
%------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Transform cell arrays into numeric arrays

rpm = cell2mat(RPM);
bpfo_coeff = cell2mat(BPFO_coeff);
bpfi_coeff = cell2mat(BPFI_coeff);
bsf_coeff = cell2mat(BSF_coeff);

%Extract condition indicators from bearing data

fshaft = rpm./60;

%Critical Frequencies

BPFO = bpfo_coeff.*fshaft;
BPFI = bpfi_coeff.*fshaft;
BSF = bsf_coeff.*fshaft;

%Sample rate

sample_rate = 12000;
Sample_rate = cell(size(Signal,1),1);
for mm = 1:size(Signal,1)
    
    Sample_rate{mm,1} = sample_rate(1,:);
    
end

%Cepstrum Pre-Whitening

a = cellfun(@fft, Signal, 'UniformOutput', false);
b = cellfun(@abs, a, 'UniformOutput', false);
c = cellfun(@(x,y) x./y, a, b, 'UniformOutput', false);
d = cellfun(@ifft, c, 'UniformOutput', false);
Signals_CPW = cellfun(@real, d, 'UniformOutput', false);

%Bandpass filtered Envelope Spectrum

e = [0, 5999];
Band_e = cell(size(Signal,1),1);
for ii = 1:size(Signal,1)
    
    Band_e{ii,1} = e(1,:);
    
end

f = 'Band';
Band_f = cell(size(Signal,1),1);
for jj = 1:size(Signal,1)
    
    Band_f{jj,1} = f(1,:);
    
end

g = 200;
Filter_Order_g = cell(size(Signal,1),1);
for kk = 1:size(Signal,1)
    
    Filter_Order_g{kk,1} = g(1,:);
    
end

h = 'FilterOrder';
Filter_Order_h = cell(size(Signal,1),1);
for ll = 1:size(Signal,1)
    
    Filter_Order_h{ll,1} = h(1,:);
    
end

[pEnvpBpf, fEnvBpf] = cellfun(@envspectrum, Signals_CPW, Sample_rate, Filter_Order_h, Filter_Order_g, Band_f, Band_e, 'UniformOutput', false);

G = cellfun(@(x) x(2), fEnvBpf, 'UniformOutput', false);
H = cellfun(@(x) x(1), fEnvBpf, 'UniformOutput', false);
deltaf = cellfun(@minus, G, H);

%Features

i = BPFO-(5.*deltaf);
I = num2cell(i);
j = BPFO+(5.*deltaf);
J = num2cell(j);

O = cellfun(@gt, fEnvBpf, I, 'UniformOutput', false);
P = cellfun(@lt, fEnvBpf, J, 'UniformOutput', false);

U = cellfun(@and, O, P, 'UniformOutput', false);

X = cellfun(@(x,y) x(y), pEnvpBpf, U, 'UniformOutput', false);

BPFOAmplitude = cellfun(@max, X, 'UniformOutput', false);

k = BPFI-(5.*deltaf);
K = num2cell(k);
l = BPFI+(5.*deltaf);
L = num2cell(l);

Q = cellfun(@gt, fEnvBpf, K, 'UniformOutput',false);
R = cellfun(@lt, fEnvBpf, L, 'UniformOutput',false);

V = cellfun(@and, Q, R, 'UniformOutput', false);

Y = cellfun(@(x,y) x(y), pEnvpBpf, V, 'UniformOutput', false);

BPFIAmplitude = cellfun(@max, Y, 'UniformOutput', false);

m = BSF-(5.*deltaf);
M = num2cell(m);
n = BSF+(5.*deltaf);
N = num2cell(n);

S = cellfun(@gt, fEnvBpf, M, 'UniformOutput', false);
T = cellfun(@lt, fEnvBpf, N, 'UniformOutput', false);

W = cellfun(@and, S, T, 'UniformOutput', false);

Z = cellfun(@(x,y) x(y), pEnvpBpf, W, 'UniformOutput', false);

BSFAmplitude = cellfun(@max, Z, 'UniformOutput', false);

A = cellfun(@(x,y) x/y, BPFIAmplitude, BPFOAmplitude, 'UniformOutput', false);
B = cellfun(@(x,y) x/y, BSFAmplitude, BPFOAmplitude, 'UniformOutput', false);
C = cellfun(@(x,y) x/y, BPFIAmplitude, BSFAmplitude, 'UniformOutput', false);

LOG_BPFIAmplitude_BPFOAmplitude = cellfun(@(x) log(x), A, 'UniformOutput', false);
LOG_BSFAmplitude_BPFOAmplitude = cellfun(@(x) log(x), B, 'UniformOutput', false);
LOG_BPFIAmplitude_BSFAmplitude = cellfun(@(x) log(x), C, 'UniformOutput', false);

%Transform cell arrays into numeric arrays

Fault_Code = char(Fault_code);
BPFO_Amplitude = cell2mat(BPFOAmplitude);
BPFI_Amplitude = cell2mat(BPFIAmplitude);
BSF_Amplitude = cell2mat(BSFAmplitude);
LOG_BPFI_Amplitude_BPFO_Amplitude = cell2mat(LOG_BPFIAmplitude_BPFOAmplitude);
LOG_BSF_Amplitude_BPFO_Amplitude = cell2mat(LOG_BSFAmplitude_BPFOAmplitude);
LOG_BPFI_Amplitude_BSF_Amplitude = cell2mat(LOG_BPFIAmplitude_BSFAmplitude);

%Table

all_12k_sets_frequency_domain_features = table(Fault_Code, BPFO_Amplitude, BPFI_Amplitude, BSF_Amplitude, LOG_BPFI_Amplitude_BPFO_Amplitude, LOG_BSF_Amplitude_BPFO_Amplitude, LOG_BPFI_Amplitude_BSF_Amplitude);

end