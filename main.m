clc
clear all
close all
tic
%% OTFS parameters%%%%%%%%%%
% number of symbol
N = 32;
% number of subcarriers
M = 32;
% size of constellation
M_mod = 4;
M_bits = log2(M_mod);
% average energy per data symbol
eng_sqrt = (M_mod==2)+(M_mod~=2)*sqrt((M_mod-1)/6*(2^2));
% number of symbols per frame
N_syms_perfram = N*M;
% number of bits per frame
N_bits_perfram = N*M*M_bits;

% 定义 JNR 范围
JNR_dB = 0:2:10; 
JNR = 10.^(JNR_dB/10);

% 干扰信号幅度
interference_amplitude = 0.5; 
interference_power = interference_amplitude^2; % 干扰信号功率

% 计算噪声功率
noise_power = interference_power ./ JNR;
sigma_2 = noise_power;

%%
rng(1)
N_fram = 1000;
err_ber = zeros(length(JNR_dB),1);
for ijrn = 1:length(JNR_dB)
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
        r = OTFS_channel_output(N,M,taps,delay_taps,Doppler_taps,chan_coef,sigma_2(ijrn),s, interference_amplitude);
        
        %% OTFS demodulation%%%%
        y = OTFS_demodulation(N,M,r);
    end
    
    % 可视化接收端DD域信号
    % figure; 
    % bar3(abs(y)); 
    % title(['接收端DD域信号, JNR = ', num2str(JNR_dB(ijrn)), ' dB']);
    
    % 绘制误码率曲线
    fixed_vmin = 0;
    fixed_vmax = 5;
    figure;
    imagesc(abs(y));
    colormap(parula);
    colorbar;
    clim([fixed_vmin fixed_vmax]); % 固定颜色映射范围
    title(['窄带干扰DD域, JNR = ', num2str(JNR_dB(ijrn)), ' dB']);
    xlabel('多普勒索引');
    ylabel('时延索引');
end
