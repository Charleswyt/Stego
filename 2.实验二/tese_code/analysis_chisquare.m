clc;
clear all;

% ͼ��·��
file_path_JSTEG_000 =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_II\\samples\\BOSS_JSTEG_000\\';
file_path_JSTEG_500 =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_II\\samples\\BOSS_JSTEG_500\\';
file_path_OTGS_000 =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_II\\samples\\BOSS_OTGS_000\\';
file_path_OTGS_500 =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_II\\samples\\BOSS_OTGS_500\\';

file_path = {file_path_JSTEG_000, file_path_JSTEG_500, file_path_OTGS_000, file_path_OTGS_500};
file_path_count = length(file_path);                                   % ͼ�񼯸���
count_cal = 20  ;                                                                 % ���DCTϵ���������Ĵ���
p = zeros(400, count_cal);                                                 % ��¼ÿ��ͼ��Ŀ����������
p_mean_JSTEG = zeros(1, count_cal);                           % ����JSTEG�㷨�Ŀ������������ֵ
p_mean_OTGS = zeros(1, count_cal);                             % ����OTGS�㷨�Ŀ������������ֵ

% �����������ã����ÿ�������������DCTϵ���������
var.WinUp = 3;                                                                    % 2i+1
var.WinDown = 2;                                                               % 2i

for k = 1:count_cal                                                              % k��ʾ��var�ĸ��Ĵ���
    for i = 1 : file_path_count                                                % i��ʾͼ�����
        
        img_path_list = dir(strcat(file_path{i}, '*.jpg'));          % ��ȡ���ļ���������jpg��ʽ��ͼ��
        img_num = length(img_path_list);                             % ��ȡͼ��������
        
        % �ļ����������п�������
        if img_num > 0                                                            % ������������ͼ��
            for j = 1:img_num                                                    % ��һ��ȡͼ��j��ʾͼ�����
                image_name = img_path_list(j).name;              % ͼ����
                image_path = strcat(file_path{i},image_name);% ͼ��·��
                %---------------- ͼ������� ----------------%
                p(j,k) = analysis(image_path,var);                       % ��������
                %-------------------- End --------------------%
            end
        end
        std.mean(i,k) = mean(p(:,k));                                       % ��������ֵ��ֵ
        std.max(i,k) = max(p(:,k));                                            % ��������ֵ���ֵ
        std.min(i,k) = min(p(:,k));                                              % ��������ֵ��Сֵ
    end
    var.WinDown = var.WinDown + 2;                                  % �ı�DCTϵ����ⴰ���½�
    var.WinUp = var.WinUp + 2;                                            % �ı�DCTϵ����ⴰ���Ͻ�
    p_mean_JSTEG(k) = std.mean(2, k) - std.mean(1,k);  % JSTEG��д�㷨��������ֵ���� 
    p_mean_OTGS(k) = std.mean(4, k) - std.mean(3,k);    % OTGS��д�㷨��������ֵ���� 
end

figure(1);
subplot(211);plot(p_mean_JSTEG);
title('JSTEG��д�㷨��������ֵ����');
subplot(212);plot(p_mean_OTGS);
title('OTGS��д�㷨��������ֵ����');

p_max_JSTEG = max(p_mean_JSTEG);
p_max_JSTEG_index = find(p_max_JSTEG);
p_max_OTGS = max(p_mean_OTGS);
p_max_OTGS_index = find(p_max_OTGS);