function []= part1_test(testfile,algorithm)     %file = testfile name and algorithm specifies a number denoting which algorithm to use

    if(ischar(algorithm))          %converting algorithm char value to integer
        algorithm = str2num(algorithm);
    end

    t = load(testfile);        
    A = csvread('part1_A.csv');     %opening csv file to read the values of A's
    t = [ones(size(t,1),1),t];      %augmenting one's
    
    assign_label(A(algorithm,:),t);

end

function [] = assign_label(a,testfile)      %calculates the assigned label
    
    outputlbl=[];
    for i=1:size(testfile,1),
       if(a*testfile(i,:)' < 0),
           outputlbl=[outputlbl;0];
       else
           outputlbl=[outputlbl;1];
       end
    end
    
    disp(outputlbl)

end