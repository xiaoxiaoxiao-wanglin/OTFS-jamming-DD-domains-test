clc
clear all
close all
tic
%% OTFS parameters%%%%%%%%%%
% number of symbol
N = 32;
% number of subcarriers
M = 32;
% size of constellation11 
M_mod = 4;
M_bits = log2(M_mod);
% average energy per data symbol
eng_sqrt = (M_mod==2)+(M_mod~=2)*sqrt((M_mod-1)/6*(2^2));
% number of symbols per frame
N_syms_perfram = N*M;
% number of bits per frame
N_bits_perfram = N*M*M_bits;
SNR_dB = 20:2:30;
%SNR_dB = 10:2:20;
SNR = 10.^(SNR_dB/10);
noise_var_sqrt = sqrt(1./SNR);
sigma_2 = abs(eng_sqrt*noise_var_sqrt).^2;
%%
rng(1)
N_fram = 1000;
err_ber = zeros(length(SNR_dB),1);
for iesn0 = 1:length(SNR_dB)
     for ifram = 1:N_fram
       %% random input bits generation%%%%%
         data_info_bit = randi([0,1],N_bits_perfram,1);
         data_temp = bi2de(reshape(data_info_bit,N_syms_perfram,M_bits));
         x = qammod(data_temp,M_mod,'gray');
         x = reshape(x,N,M);
         %% OTFS modulation%%%%
         s = OTFS_modulation(N,M,x);
        
       %% OTFS channel generation%%%%
         [taps,delay_taps,Doppler_taps,chan_coef] = OTFS_channel_gen(N,M);        
        %% OTFS channel output%%%%%
        r = OTFS_channel_output(N,M,taps,delay_taps,Doppler_taps,chan_coef,sigma_2(iesn0),s);
        
       %% OTFS demodulation%%%%
       y = OTFS_demodulation(N,M,r);
         
     end
         % 计算平均误码率
end
%% 可视化发射端DD域信号
% figure; bar3(abs(x)); title('发射端DD域信号');
%% 可视化接收端DD域信号
figure; bar3(abs(y)); title('接收端DD域信号');
% 绘制误码率曲线
fixed_vmin = 0;
fixed_vmax = 5;
figure;
imagesc(abs(y));
colormap(parula);
colorbar;
clim([fixed_vmin fixed_vmax]); % 固定颜色映射范围
title('窄带噪声DD域（0.5，0.45，90）');
xlabel('多普勒索引');
ylabel('时延索引');