function [TP_mean,TF_mean,ACC_mean] = SVM_beat(algorithm_type, stego_number, times)

%% ������ȡ
feature_matrix = load_feature();                                           % ������������ 200 * 275 * 8
feature_matrix_size = size(feature_matrix);                        % ������������ߴ�
image_count = feature_matrix_size(1);                               % ÿ��ͼ����ͼ��ĸ���
feature_dimension = feature_matrix_size(2)-1;                  % ����ά�� PEV-274
image_file_count = feature_matrix_size(3);                        % ͼ�񼯸���

if stego_number > image_file_count
    disp('stego_number��Ӧ�ô���8');
else
    % Nonstego_number��ʼ��
    if strcmp(algorithm_type,'F5') == 1
        Nonstego_number = 1;
        if stego_number > 4
            disp('�������㷨����дͼ�񼯲�ƥ��');
        end
    elseif strcmp(algorithm_type,'OTGS') == 1
        Nonstego_number = 5;
        if stego_number < 6
            disp('�������㷨����дͼ�񼯲�ƥ��');
        end
    else
        disp('��ǰ��д�㷨�޷�����');
    end
    %% ѵ����
    % �Ʊ�ѵ����ǩ��
    trainSetLabel = zeros(image_count,1);                             % ѵ������ǩ��ʼ��
    trainSetLabel(1 : image_count / 2) = 1;                             % ǰһ��Ϊδ��дͼ��
    trainSetLabel(image_count / 2 + 1 : image_count) = 2;   % ��һ��Ϊ��дͼ��
    
    % �Ʊ�ѵ����                                                                      %��ѵ����ǩ����Ӧ
    trainSet(1:image_count / 2,1:feature_dimension) = feature_matrix(1:image_count / 2,1:feature_dimension, Nonstego_number);
    trainSet(image_count / 2 + 1 : image_count,1:feature_dimension) = feature_matrix(1:image_count / 2,1:feature_dimension, stego_number);
    
    % ��һ��
    % ÿά��������0��ֵ��1����������б�׼��
    % ѵ������һ��
    trainSet_norm = zeros(image_count, feature_dimension);
    for i = 1 : feature_dimension
        trainSet_norm(:,i) = zscore(trainSet(:,i));
    end
    
    %% SVMѵ��
    % libsvmtrain�ĵ��ò���Ϊlibsvmtrain(trainSetLabel, trainSet, svmParams)��
    % ���У�trainSetLabel ��ʾѵ������ǩ��trainSet Ϊѵ����������֧��������ѵ����
    % ��ΪsvmParams = '-s 0 -t 2 -g 0.00014 -c 20000'
    % ȡǰһ������ѵ��
    svmParams = '-s 0 -t 2 -g 0.00014 -c 20000';                  % SVMѵ������
    model = libsvmtrain(trainSetLabel, trainSet_norm, svmParams);
    
    %% ���Լ�
    % �Ʊ����Լ�
    % ���ݼ������times���в��Լ��Ʊ�����ʣ�µ�100��ͼ��ֳ�times�飬����ģ�Ͳ���
    % times��ȡ4 5 10 20�ȿɱ���������
    if times > 10
        times = 10;
    end
    
    element_count = image_count / times;                                             % 200��100����д+100��δ��д����ͼ��ֳ�10�飬ÿ��20��
    testSetLabel = zeros(element_count,1,times);                                % ���Լ���ǩ
    testSet = zeros(element_count,feature_dimension,times);            % ���Լ�
    testSet_norm = zeros(element_count, feature_dimension,times);% ���Լ���һ��
    TP = zeros(1,times);TF = zeros(1,times);ACC = zeros(1,times);  % �������ʡ��������ʡ�׼ȷ��
    
    testSetLabel_temp1(1:image_count / 2,1)...                                                                                       % δ��дͼ���ǩ��
        = trainSetLabel(1:image_count / 2);
    testSetLabel_temp2(1:image_count / 2,1)...                                                                                       % ��дͼ���ǩ��
        = trainSetLabel(image_count / 2+1:image_count,1);
    
    testSet_temp1(1:image_count / 2,1:feature_dimension)...
        = feature_matrix(image_count / 2+1:image_count,1:feature_dimension,Nonstego_number);    %δ��дͼ��������
    testSet_temp2(1:image_count / 2,1:feature_dimension)...
        = feature_matrix(image_count / 2+1:image_count,1:feature_dimension,stego_number);           % ��дͼ��������
    
    start = 1;
    
    for i = 1:times
        % ���Ա�ǩ��
        testSetLabel(1:element_count / 2,1,i) = testSetLabel_temp1(1:element_count / 2,1);
        testSetLabel(element_count / 2 + 1:element_count,1,i) = testSetLabel_temp2(1:element_count / 2,1);
        % ���Լ�
        testSet(1:element_count / 2,:,i)   = testSet_temp1(start:start + element_count / 2 - 1,:);
        testSet(element_count / 2 + 1:element_count,:,i) = testSet_temp2(start:start + element_count / 2 - 1,:);
        start = start + element_count / 2;
        
        % ���Լ���һ��
        for k = 1 : feature_dimension
            testSet_norm(:,k,i) = zscore(testSet(:,k,i));
        end
        
        %% Ԥ��
        % libsvmpredict �ĵ��ò���Ϊlibsvmpredict(testSetLabel, testSet, model)
        % testSetLabel ��ʾ���Լ���ǩ�� testSet Ϊ���Լ������� model Ϊ֧��������������
        resultLabel = libsvmpredict(testSetLabel(:,1,i), testSet_norm(:,:,i), model);
        TF(i) = length(find(testSetLabel(1:element_count / 2,1,i) == resultLabel(1:element_count / 2))) / (element_count / 2);
        TP(i) = length(find(testSetLabel(element_count / 2 + 1:element_count,1,i) == resultLabel(element_count / 2 + 1:element_count))) / (element_count / 2);
        ACC(i) = (TP(i) + TF(i)) / 2;
    end
end
TP_mean = mean(TP);
TF_mean = mean(TF);
ACC_mean = mean(ACC);
%% ��ͼ
rate = {'0.05bpac','0.1bpac','0.2bpac'};
if stego_number < 5
    string = strcat(algorithm_type,32,rate{stego_number-1});
else
    string = strcat(algorithm_type,32,rate{stego_number-5});
end
figure;
subplot(222);plot(TP,'.','markersize',20);title('TP ��������');
subplot(223);plot(TF,'.','markersize',20);title('TF ��������');
subplot(224);plot(ACC,'.','markersize',20);title('ACC ׼ȷ��');
axes('position',[0,0,1,1],'visible','off');
tx = text(0.2,0.78,string);
set(tx,'fontweight','bold');
end