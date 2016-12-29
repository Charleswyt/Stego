function [TP_mean,TF_mean,ACC_mean] = SVM(algorithm_type, stego_number, times,plot)
%algorithm_type = 'F5';stego_number = 2;times = 10;
if times > 11
    times = 11;
end

%% ������ȡ
feature_matrix = load_feature();                           % ������������ 200 * 275 * 8
feature_matrix_size = size(feature_matrix);         % ������������ߴ�
image_count = feature_matrix_size(1);                % ÿ��ͼ����ͼ��ĸ���
feature_dimension = feature_matrix_size(2)-1;   % ����ά�� PEV-274
image_file_count = feature_matrix_size(3);         % ͼ�񼯸���
element_count = image_count / 2;                        % ÿ�δ�ÿ��ͼ����ȡ��һ������ѵ���Ͳ���

str = {'stego_number��Ӧ�ô���',...
    '�������㷨����дͼ�񼯲�ƥ��',...
    '��ǰ��д�㷨�޷�����'};                                   % Output Error
algorithm = {'F5','OTGS'};                                      % ��д�㷨

if stego_number > image_file_count
    string = strcat(str{1},num2str(image_file_count));
    disp(string);
else
    if strcmp(algorithm_type,algorithm{1}) == 1
        Nonstego_number = 1;
        if stego_number > 4
            disp(str{2});
        end
    elseif strcmp(algorithm_type,algorithm{2}) == 1
        Nonstego_number = 5;
        if stego_number < 6
            disp(str{2});
        end
    else
        disp(str{3});
    end
    
    % ������
    feature_Nonstego = feature_matrix(:,1:feature_dimension,Nonstego_number);
    feature_stego = feature_matrix(:,1:feature_dimension,stego_number);
    
    %% ��ǩ��  ѵ�����Ͳ��Լ���ǩ��ͬ
    % ǰһ��Ϊδ��д����ǩΪ1����һ��Ϊ��д����ǩΪ2
    trainSetLabel(1:element_count,1) = 1;
    trainSetLabel(element_count+1:image_count,1) = 2;
    testSetLabel = trainSetLabel;
    
    trainSet = zeros(image_count,feature_dimension);
    testSet = zeros(image_count,feature_dimension);
    trainSet_norm = zeros(image_count, feature_dimension);
    testSet_norm = zeros(image_count, feature_dimension);
    feature_Nonstego_temp = feature_Nonstego;
    feature_stego_temp = feature_stego;
    TF = zeros(1,times);TP = zeros(1,times);ACC = zeros(1,times);
    
    for i = 1:times
        %% ���ݼ�
        % ǰһ��Ϊδ��д����һ��Ϊ��д���ɶԳ���
        trainSet(1:element_count,:) = feature_Nonstego_temp(1:element_count,:);
        trainSet(element_count+1:image_count,:) = feature_stego_temp(1:element_count,:);
        testSet(1:element_count,:) = feature_Nonstego_temp(element_count+1:image_count,:);
        testSet(element_count+1:image_count,:) = feature_stego_temp(element_count+1:image_count,:);
        
        %% ��һ��
        % ÿά��������0��ֵ��1����������б�׼��
        for k = 1 : feature_dimension
            trainSet_norm(:,k) = zscore(trainSet(:,k));
            testSet_norm(:,k)  = zscore(testSet(:,k));
        end
        
        % SVMѵ��
        % libsvmtrain�ĵ��ò���Ϊlibsvmtrain(trainSetLabel, trainSet, svmParams)��
        % ���У�trainSetLabel ��ʾѵ������ǩ��trainSet Ϊѵ����������֧��������ѵ����
        % ��ΪsvmParams = '-s 0 -t 2 -g 0.00014 -c 20000'
        % ȡǰһ������ѵ��
        svmParams = '-s 0 -t 2 -g 0.00014 -c 20000';                  % SVMѵ������
        model = libsvmtrain(trainSetLabel, trainSet_norm, svmParams);
        
        % Ԥ��
        % libsvmpredict �ĵ��ò���Ϊlibsvmpredict(testSetLabel, testSet, model)
        % testSetLabel ��ʾ���Լ���ǩ�� testSet Ϊ���Լ������� model Ϊ֧��������������
        resultLabel = libsvmpredict(testSetLabel, testSet_norm, model);
        TF(i) = length(find(testSetLabel(1:element_count,1) == resultLabel(1:element_count,1))) / element_count;
        TP(i) = length(find(testSetLabel(element_count + 1:image_count,1) == resultLabel(element_count + 1:image_count,1))) / element_count;
        ACC(i) = (TP(i) + TF(i)) / 2;
        
        % ��������10��
        feature_Nonstego_temp = circshift(feature_Nonstego_temp,-10);
        feature_stego_temp = circshift(feature_stego_temp,-10);
    end
end
TP_mean = mean(TP);
TF_mean = mean(TF);
ACC_mean = mean(ACC);

%% ��ͼ
if plot == 1
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
end