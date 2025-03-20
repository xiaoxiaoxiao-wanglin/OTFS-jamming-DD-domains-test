function s = OTFS_modulation(N,M,x) 
%% OTFS Modulation: 1. ISFFT, 2. Heisenberg transform
X = fft(ifft(x).').'/sqrt(M/N); %%%ISFFT 逆辛快速傅里叶变换 将信号从DD域变换到TF域
s_mat = ifft(X.')*sqrt(M); % Heisenberg transform  海森堡变换 将信号从TF域变换到时间域
s = s_mat(:);
end