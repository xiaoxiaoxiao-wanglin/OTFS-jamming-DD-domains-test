%%
function [taps,delay_taps,Doppler_taps,chan_coef] = OTFS_channel_gen(N,M)
%% Channel for testing%%%%%
%channel with 4 taps of uniform power%%% 
taps = 4; %抽头数(多径中的路径数)
delay_taps = [0 1 2 3]; %定义时延抽头数组
Doppler_taps = [0 1 2 3]; %定义多普勒抽头数组
pow_prof = (1/taps) * (ones(1,taps));
chan_coef = sqrt(pow_prof).*(sqrt(1/2) * (randn(1,taps)+1i*randn(1,taps)));%生成信道复系数
%%%%%%%%%%%%%%%%%%%%

end