function y = OTFS_demodulation(N,M,r)
%% OTFS demodulation: 1. Wiegner transform, 2. SFFT
r_mat = reshape(r,M,N);
Y = fft(r_mat)/sqrt(M); % Wigner transform 将接收到的时域信号变换到TF域
Y = Y.';  %矩阵求逆
y = ifft(fft(Y).').'/sqrt(N/M); % SFFT 将TF域信号变换到DD域
end