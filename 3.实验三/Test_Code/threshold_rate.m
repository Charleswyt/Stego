clc;
clear all;
tic;

% ͼ���ļ���·��
file_path =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\BOSS_LSBR_000\\';
file_num = 5;

rate_count = 9;                                                               % var.rate = 0.01:0.005:0.05
var.startX = 10;                                                               % ��ⴰ�ڵ�ˮƽƫ����
var.startY = 10;                                                               % ��ⴰ�ڵ���ֱƫ����

% ����Ƕ��ǰ��Qֵ����ֵ��R = Q2/Q1
R = zeros(file_num, rate_count);
R_mean = zeros(1,rate_count);

% �������ã�var��ʼ��
var.rate = 0.01;                                                               % ����Ƕ���Ƕ����
var.width = 30;                                                                % ��ⴰ�ڿ��
var.height = 30;                                                               % ��ⴰ�ڸ߶�

for i = 1 : rate_count
    img_path_list = dir(strcat(file_path, '*.bmp'));          % ��ȡ���ļ���������bmp��ʽ��ͼ��
    img_num = length(img_path_list);                            % ��ȡͼ��������
    
    if img_num > 0                                                           % ������������ͼ��
        for j = 1:file_num                                                    % ��һ��ȡͼ��
            image_name = img_path_list(j).name;             % ͼ����
            image_path = strcat(file_path, image_name); % ͼ��·��
            R(j, i) = analysis(image_path,var);                     % RQP����
        end
    end
    var.rate = var.rate + 0.005;                                         % ����Ƕ����
    R_mean(i) = mean(R(:,i));
end
plot(R_mean);title('var.width  = var.height = 30');
toc;