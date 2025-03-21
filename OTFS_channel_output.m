function r = OTFS_channel_output(N,M,taps,delay_taps,Doppler_taps,chan_coef,sigma_2,s, interference_amplitude)
    %% wireless channel and noise 
    L = max(delay_taps);
    s = [s(N*M-L+1:N*M);s];%add one cp
    s_chan = 0;
    interference_frequency = 0.2; % 干扰频率
    interference_phase = 2*pi*0.3; % 干扰相位

    for itao = 1:taps
        s_chan = s_chan + chan_coef(itao)*circshift([s.*exp(1j*2*pi/M ...
            *(-L:-L+length(s)-1)*Doppler_taps(itao)/N).';zeros(delay_taps(end),1)], delay_taps(itao));
    end

    noise = sqrt(sigma_2/2)*(randn(size(s_chan)) + 1i*randn(size(s_chan)));
    t = 1:length(s_chan(:)); % 计算信号所有元素数量
    interference = interference_amplitude * exp(1i * (2 * pi * interference_frequency * t + interference_phase));
    interference_matrix = reshape(interference, size(s_chan)); % 重塑干扰信号维度与 s_chan 一致
    r = s_chan + noise+interference_matrix; % 加入噪声和干扰
    r = r(L+1:L+(N*M)); % discard cp
end
