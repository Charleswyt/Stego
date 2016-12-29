clc;
clear all;
tic;

% ͼ���ļ���·��
%file_path =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\BOSS_LSBR_000\\';
%file_path =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\BOSS_LSBR_100\\';
%file_path =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\BOSS_LSBR_300\\';
file_path =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\BOSS_LSBR_500\\';

file_num = 200;
R = zeros(file_num, 1);                                            % ����Ƕ��ǰ��Qֵ����ֵ��R = Q2/Q1
stego_num = 0;                                                        % ��дͼ�����

% �������ã�var��ʼ��
var.rate = 0.04;                                                         % ����Ƕ���Ƕ����
var.width = 100;                                                        % ��ⴰ�ڿ��
var.height = 100;                                                      % ��ⴰ�ڸ߶�
var.startX = 10;                                                         % ��ⴰ�ڵ�ˮƽƫ����
var.startY = 10;                                                         % ��ⴰ�ڵ���ֱƫ����


image_path_list = dir(strcat(file_path, '*.bmp'));    % ��ȡ���ļ���������bmp��ʽ��ͼ��
image_num = length(image_path_list);                  % ��ȡͼ��������

if image_num > 0                                                     % ������������ͼ��
    for j = 1:file_num                                                  % ��һ��ȡͼ��
        image_name = image_path_list(j).name;       % ͼ����
        image_path = strcat(file_path,image_name);% ͼ��·��
        R(j) = analysis(image_path,var);                     % RQP����
        if R(j) <= 1
            stego_num = stego_num + 1;
        end
    end
end
accuracy = stego_num / image_num;
figure(1);plot(R,'.','markersize',8);title('LSBR 500');
figure(2);hist(R);title('LSBR 500');
toc;