clc;
clear all;

% ͼ��·��
file_path_LSBR_000 =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\BOSS_LSBR_000\\';
file_path_LSBR_100 =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\BOSS_LSBR_100\\';
file_path_LSBR_300 =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\BOSS_LSBR_300\\';
file_path_LSBR_500 =  'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\BOSS_LSBR_500\\';
file_path = {file_path_LSBR_000, file_path_LSBR_100, file_path_LSBR_300, file_path_LSBR_500};
file_path_count = length(file_path);                                   % ͼ�񼯸���
num = 1;

% ����ͼ��
file_path_test = 'C:\\Users\\Administrator\\MatlabProject\\StegoTest\\StegoTest_III\\TestFile\\Test_';

for i = 1 : file_path_count
    image_path_list = dir(strcat(file_path{i}, '*.bmp'));    % ��ȡ���ļ���������jpg��ʽ��ͼ��
    image_num = length(image_path_list);                     % ��ȡͼ��������
    k = 1;                                                                            % ������
    num = 1 + (i-1) * 20;
    
    if image_num > 0                                                        % ������������ͼ��
        for j = 1:image_num                                                % ��һ��ȡͼ��j��ʾͼ�����
            image_name = image_path_list(j).name;          % ͼ����
            image_path = strcat(file_path{i},image_name);% ͼ��·��
            image = imread(image_path);

            % ���·��
            file_path_test_temp = strcat(file_path_test, num2str(k));
            file_path_test_temp = strcat(file_path_test_temp, '\\');
            file_path_test_temp = strcat(file_path_test_temp, num2str(num));
            file_path_test_temp = strcat(file_path_test_temp, '.bmp');
            imwrite(image,file_path_test_temp,'bmp');
            num = num + 1;
            if mod(num-1, 20) == 0
                k = k + 1;
                num = 1 + (i-1) * 20;                                    % ͼ����
            end
        end
    end
end