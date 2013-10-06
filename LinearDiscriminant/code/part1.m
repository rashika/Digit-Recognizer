function [] = part1(testfile)      % takes input as testsample filename which must contain testdata and testlabel
    t = load('MS2CD.mat');         % loads training data
    traindata = [ones(size(t.trainData,1),1),t.trainData];      %augmenting one in trainsample
    trainlabel = t.trainLabel;
%    newtraindata = [ones(size(t.trainData,1),1),t.trainData];   
    s = load(testfile);     %loading testing data
    testdata = [ones(size(s.testData,1),1),s.testData];         %augmenting one in testsample
%    testlabel = s.testLabel;
    
    for i=1:size(traindata,1),          %multiplying all the training samples having label as 0 by -1 to shift them to the same side of label 1
        if (trainlabel(i) == 0)
            traindata(i,:)=-1.*traindata(i,:);
        end
    end
    
    A = [];         %contains a for all 5 algorithms
    color = ['c','m','k','g','y'];  %different colors for different decision boundaries
    
    plottrain(t.trainData,t.trainLabel);    
    a = batch(traindata);      
    A = [A;a];
    a = singlesample(traindata);       
    A = [A;a];  
    a = batchmargin(traindata);     
    A = [A;a];
    a = singlesamplemargin(traindata);     
    A = [A;a];
    a = relaxation(traindata);      
    A = [A;a];
    
    for i=1:size(A,1),      %calculating accuracy for each a
        disp('Labels assigned to testing sample :')     %for test data
        calcaccuracy(A(i,:),testdata)%,testlabel);
%         disp('Accuracy for training data :')    %for training data
%         calcaccuracy(A(i,:),newtraindata,trainlabel);
        plota(A(i,:),color(i));     %plotting each a
    end
    
    hold off;
%     disp('Accuracy for 1-NN :')     %calculating accuracy by 1nn algorithm
%     nn(newtraindata,testdata,testlabel);
    
end

function [] = plottrain(trainData,trainLabel)       %plotting training datasamples
    for i=1:size(trainData,1),
       if (trainLabel(i)==0)
           scatter(trainData(i,1),trainData(i,2),10,[1,0,0],'filled');
           hold on;
       else
           scatter(trainData(i,1),trainData(i,2),10,[0,0,1],'filled');  
           hold on;
       end
    end
end

function [] = calcaccuracy(a,testdata)%,testlabel)

    outputlbl = [];     %contains the label assigned by every algorithm
%    accuracy = 0;

    for i=1:size(testdata,1),
        product = a*testdata(i,:)';
        if (product > 0)
            outputlbl = [outputlbl;1];
        else
            outputlbl = [outputlbl;0];
        end
    end
    
    disp(outputlbl)

%     for i=1:size(outputlbl,1),      %calculating accuracy by verifying against correct labels
%         if (outputlbl(i) == testlabel(i))
%             accuracy = accuracy + 1;
%         end
%     end
    
%     disp((accuracy/size(testlabel,1))*100)
    
end

function [] = plota(a,color)    %plotting each a with the specified color

    x= -10:0.5:20;
    y= (-a(2)*x-a(1))/a(3);
    p = plot(x,y);
    set(p,'Color',color,'LineWidth',2);
    hold on;

end

function [a] = batch(traindata)      %calculating a for batch perceptron
    a = [1,100,1];
    k = 1;

    while (1),
        check = 0;
        sum = [0,0,0];
        n = [1/k,1/k,1/k];
        for i=1:size(traindata,1),
            value = a*traindata(i,:)';
            if (value < 0)
                check = 1;      %if any sample is misclassified or not
                sum = sum + traindata(i,:);     %summing all misclassified samples
            end
        end
        a = a + sum.*n;     %updating a
        check1 = 0;
        for i=1:size(traindata,2),
            if(abs(sum(i)/k) > 0.1),           % looking at the change of A vector.
                                               % if it is not changing much (not more than theta = 0.1)
                                               % then this is 1st break condition
                check1=check1+1;
            end
        end
        k = k + 1;
        if(check == 0 || check1 == 0 || k > 5000)      
            break;
        end      
    end
    
end


function [a] = singlesample(traindata)       %calculating a for singlesample perceptron

    a = [-33,10,1];
    k = 1;

    while (1),
        check = 0;
        prev = a;   %taking value of a before going in loop.

        for i=1:size(traindata,1),
            value = traindata(i,:)*a';
            if (value < 0)
                check = 1;      %if any sample is misclassified or not
                a = a + traindata(i,:) * (1.0 / k);  %adding the value to a.

            end
        end
        check1 = 0;
        for i=1:size(traindata,2),
            if(abs(a(i) - prev(i)) > 0.1)      % looking at the change of A vector.
                                               % if it is not changing much (not more than theta = 0.1)
                                               % then this is 1st break condition
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


function [a] = batchmargin(traindata)       %calculating a for batch with margin perceptron

a = [1,100,1];
k = 1;
b = 5;      %setting the margin as 5

while (1),
    check = 0;
    sum = [0,0,0];
    n = [1/k,1/k,1/k];
    for i=1:size(traindata,1),
        value = a*traindata(i,:)';
        if ((value - b) < 0)
            check = 1;      %if any sample is misclassified or not
            sum = sum + traindata(i,:);     %summing all misclassified samples
        end
    end
     a = a + sum.*n;        %adding the value to a
    check1=0;
    for i=1:size(traindata,2),
        if(abs(sum(i)/k) > 0.1),               % looking at the change of A vector.
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


function [a] = singlesamplemargin(traindata)         %calculating a for singlesample with margin perceptron

a = [-28,10,6];
k = 1;
b = 5;      %setting the margin as 5
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
            if(abs(a(i) - prev(i)) > 0.1)      % looking at the change of A vector.
                                               % if it is not changing much (not more than theta = 0.1)
                                               % then this is 1st break condition
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

a = [-120,12,-122];
k = 1;
b = 5;      %setting the margin as 5

while (1),
    check = 0;
    sum = [0,0,0];
    n = [1/k,1/k,1/k];
    for i=1:size(traindata,1),
        value = a*traindata(i,:)'-b;
        if ((value) < 0)
            check = 1;      %if any sample is misclassified or not
            sum = sum + (-value).*((traindata(i,:))./(traindata(i,:)*traindata(i,:)'));     %summing all misclassified samples
        end
    end
     a = a + sum.*n;        %adding the value to a
    check1 =0;
    for i=1:size(traindata,2),
        if(abs(sum(i)/k) > 0.1),               % looking at the change of A vector.
                                               % if it is not changing much (not more than theta = 0.1)
                                               % then this is 1st break
                                               % condition
            check1=check1+1;
        end
    end
    if(check == 0 || check1 == 0 || k > 200)
        break;
    end
    k = k + 1;
end

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

disp((accuracy/size(testdata,1))*100)
end