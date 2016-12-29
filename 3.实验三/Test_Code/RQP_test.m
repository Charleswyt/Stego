clc;
clear all;
tic;
% ����ͼ��
file_path_test = 'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\TestFile\\Test_';
file_test_num = 10;                                                             % ����ͼ�񼯸���
R = zeros(80,10);                                                                % RQP����ֵ
TP = zeros(1,file_test_num);                                              % ��������
FP = zeros(1,file_test_num);                                              % ��������
TF = zeros(1,file_test_num);                                              % ��������

% ��������
var.rate = 0.04;                                                                    % ����Ƕ���Ƕ����
var.height = 100;var.width = 100;                                       % ��ⴰ�ڵĸ߶ȺͿ��
var.startX = 10;var.startY = 10;                                           % ��ⴰ�ڵ�ˮƽ�ʹ�ֱƫ����

for k = 1:file_test_num                                                        % 10������ͼ��
    file_path_test_temp = strcat(file_path_test, num2str(k));
    file_path = strcat(file_path_test_temp, '\\');                   % ���Լ�ͼ��·��
    
    image_path_list = dir(strcat(file_path, '*.bmp'));           % ��ȡ���ļ���������bmp��ʽ��ͼ��
    image_num = length(image_path_list);                         % ��ȡͼ��������
    TP_num = 0;                                                                   % ������ͼ�����
    TF_num = 0;                                                                   %  ������ͼ�����
    
    if image_num > 0                                                           % ������������ͼ��
        for j = 1:image_num                                                   % ��һ��ȡͼ��j��ʾͼ�����
            image_name = image_path_list(j).name;             % ͼ����
            image_path = strcat(file_path,image_name);      % ͼ��·��
            R(j,k) = analysis(image_path,var);                         % RQP����
            image_name(end-3:end) = [];
            image_number = str2double(image_name);
            if R(j,k) > 1 &&  image_number <= 20                  % ��������
                TF_num = TF_num + 1;
            end
            
            if R(j,k) <= 1 &&  image_number > 20                  % ��������
                TP_num = TP_num + 1;
            end
            
        end
    end
    TF(k) = TF_num / 20;
    TP(k) = TP_num / 60;
end

TF_mean = mean(TF);
TP_mean = mean(TP);
accuracy = (TF_mean + TP_mean) / 2;

figure(1);plot(TP,'.','markersize',20);title('�������� TP');
figure(2);plot(TF,'.','markersize',20);title('�������� TF');

toc;