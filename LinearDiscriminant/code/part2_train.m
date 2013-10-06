function [] = part2_train(testfile,algorithm)     % takes input as testsample filename which must contain testdata and testlabel, algorithm number 

    if ischar(algorithm)        %converts algorithm number to integer value
        algorithm = str2num(algorithm);
    end
    
    t = load('mnist.mat');      % loads training data
    traindata = [ones(size(t.trainData,1),1),double(t.trainData)];      %augmenting one in trainsample
    trainlabel = t.trainLabel;
    s = load(testfile);         % loading testing data
    testdata = [ones(size(s.testData,1),1),double(s.testData)];     %augmenting one in testsample
   % testlabel = s.testLabel;
    classline = [];     %contains all 45 classifiers
    
    for i=1:9,      %calculating 45 classifiers in pairwise classification
        for j =0:i-1,
            newtrain = [];      %newtrain contains those training samples for which classifier is being learnt
            for k=1:size(traindata,1),
                if (trainlabel(k) == i)
                    newtrain = [newtrain;-1.*traindata(k,:)];
                elseif (trainlabel(k) == j)
                    newtrain = [newtrain;traindata(k,:)];    
                end
            end
            if(algorithm == 1)      %checking which algorithm to implement
                  a = batchmargin(newtrain,0);
            elseif(algorithm == 3)
                  a = batchmargin(newtrain,5);
            elseif(algorithm == 2)
                  a = singlesample(newtrain,0);
            elseif(algorithm == 4)
                  a = singlesample(newtrain,5);
            elseif(algorithm == 5)
                  a = relaxation(newtrain);
            end
            classline = [classline;a];
        end
    end
    
    norm_classline = [];
    
    for i=1:size(classline,1),
        norm_classline = [norm_classline;classline(i,:)/norm(classline(i,:))];
    end
    
    csvwrite('part2_A1.csv',norm_classline);
    
%     disp('Accuracy for training data:')     %calculate accuracy for training sample with the value of classline
%     classify(classline,traindata,trainlabel);
%     disp('Accuracy for testing data:')      %calculate accuracy for training sample with the value of classline
%    classify(classline,testdata)%,testlabel);
%     disp('Accuracy for 1-NN:')      %calculate accuracy for testing sample with 1-NN algorithm
%     nn(traindata,testdata,testlabel);
    
end


function [a] = batchmargin(traindata,margin)        %calculating a for batch perceptron and batch perceptron with margin 

    a = ones(1,size(traindata,2));
    k = 1;
    b = margin;

    while (1),
        check = 0;
        sum = zeros(1,size(traindata,2));
        for i=1:size(traindata,1),
            value = traindata(i,:)*a' - b;
            if (value < 0)
                check = 1;       %if any sample is misclassified or not
                sum = sum + (traindata(i,:));       %summing all misclassified samples
            end
        end
        a = a + (1.0*sum/k);        %updating a
        check1 = 0;
        for i=1:size(traindata,2),
            if(abs(sum(i)) > 0.1),             % looking at the change of A vector.
                                               % if it is not changing much (not more than theta = 0.1)
                                               % then this is 1st break
                                               % condition
                check1=check1+1;
            end
        end
        if(check == 0 || check1 == 0 || k > 5000)
            break;
        end   
        k = k + 1;
    end

end

function [a] = singlesample(traindata,margin)        %calculating a for singlesample perceptron and singlesample perceptron with margin
    a = ones(1,size(traindata,2));
    k = 1;
    b = margin;

    while (1),
        check = 0;
        prev = a;   % taking value of a before going in loop.

        for i=1:size(traindata,1),
            value = traindata(i,:)*a' - b;
            if (value < 0)
                check = 1;      %if any sample is misclassified or not
                a = a + traindata(i,:) * (1.0 / k);  %adding the value to A.

            end
        end
        check1 = 0;
        for i=1:size(traindata,2),
            if(abs(a(i) - prev(i)) > 0.1)  % looking at the change of A vector.
                                           % if it is not changing much (not more than theta = 0.1)
                                           % then this is 1 break condition
                check1=check1+1;
                break;
            end
        end
        k = k + 1;
        if(check == 0 || check1 ==0 || k > 5000)
            break;
        end
    end

end

function [a] = relaxation(traindata)        %calculating a for batch relaxation with margin perceptron

     a = ones(1,size(traindata,2));
     k = 1;
     b = 5;     %setting the margin as 5

    while (1),
        check = 0;
        sum = zeros(1,size(traindata,2));
        for i=1:size(traindata,1),
            value = traindata(i,:)*a' -b;
            if (value < 0)
                check = 1;       %if any sample is misclassified or not
                sum = sum + (-value).*((traindata(i,:))./(traindata(i,:)*traindata(i,:)'));      %summing all misclassified samples
            end
        end
        a = a + (1.0*sum/k);        %adding the value to a
        check1 =0;
        for i=1:size(traindata,2),
            if(abs(sum(i)/k) > 0.1),           % looking at the change of A vector.
                                               % if it is not changing much (not more than theta = 0.1)
                                               % then this is 1st break
                                               % condition
                check1=check1+1;
            end
        end
        if(check == 0 || check1 == 0 || k > 5000)
            break;
        end
        k = k + 1;
    end

end

function [] = classify(classline,testdata)%,testlabel)        

    outputlbl = [];

    for i=1:size(testdata,1),       %for each training sample
        a = 1;
        count=[0,0,0,0,0,0,0,0,0,0];    
        for j=1:9,      %checking for each classfier
            for k=0:j-1;
                if(classline(a,:)*testdata(i,:)' < 0)
                    count(j+1) = count(j+1)+1;
                else
                    count(k+1) = count(k+1)+1;
                end
                a = a + 1;
            end
        end
        [value,index]=max(count);       %taking the nearest neighbour
        outputlbl = [outputlbl;index-1];
    end

     disp(outputlbl)
%     accuracy = 0;       %calculating accuracy
%     for i=1:size(testdata,1),
%         if(outputlbl(i) == testlabel(i))
%             accuracy = accuracy+1;
%         end
%     end
% 
%     disp((accuracy/size(testdata,1))*100)

end

function [] = nn(traindata,testdata,testlabel)      %applying 1-NN algorithm on the training sample and checking accuracy with the test data

    accuracy = 0;

    for i=1:size(testdata,1),
        difference = [];
        for j=1:size(traindata,1),
            diff = norm(testdata(i,:)-traindata(j,:));
            difference = [difference;diff,testlabel(i)];
        end
        sortedarray = sortrows(difference,1);
        label = sortedarray(1,2);
        if (label == testlabel(i))
            accuracy = accuracy + 1;
        end
    end

    disp(accuracy/size(testdata,1)*100)
    
end
