clc;
clear all;

% ͼ��·��
file_path =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_II\\samples\\BOSS_JSTEG_000\\';
file_path =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_II\\samples\\BOSS_JSTEG_500\\';
file_path =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_II\\samples\\BOSS_OTGS_000\\';
file_path =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_II\\samples\\BOSS_OTGS_500\\';

p = zeros(400, 1);                                                            % ��¼ÿ��ͼ��Ŀ����������
stego_num = 0;                                                                % ��д�ļ�����

% �����������ã����ÿ�������������DCTϵ���������
var.WinUp = 5;                                                                 % 2i+1
var.WinDown = 4;                                                            % 2i

img_path_list = dir(strcat(file_path, '*.jpg'));                  % ��ȡ���ļ���������jpg��ʽ��ͼ��
img_num = length(img_path_list);                                  % ��ȡͼ��������

% �ļ����������п�������
if img_num > 0                                                                 % ������������ͼ��
    for j = 1:img_num                                                         % ��һ��ȡͼ��j��ʾͼ�����
        image_name = img_path_list(j).name;                   % ͼ����
        image_path = strcat(file_path,image_name);        % ͼ��·��
        %---------------- ͼ������� ----------------%
        p(j) = analysis(image_path,var);                              % ��������
        % JSTEG 000ͼ�񼯵Ŀ�������ֵ���Ϊ0.086����������һ�Σ������Ϊ��С��ֵ�����T_JSTEG = 0.001
        % T_OTSG = 0.0001Ϊһ����Ϊ���ʵ���ֵ
        if p(j) >= 0.0001                                                            
            stego_num = stego_num + 1;
        end
        %-------------------- End --------------------%
    end
end
accuracy = stego_num / img_num;                                     % �龯��/׼ȷ�ʣ���Բ�ͬ��ͼ�񼯺��岻ͬ��