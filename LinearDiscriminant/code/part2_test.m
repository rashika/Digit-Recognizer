function []= part2_test(testfile,algorithm)

    if (ischar(algorithm))
        algorithm = str2num(algorithm);
    end

    t = load(testfile);
    t = [ones(size(t,1),1) t];
    
     if (algorithm == 1)
        classline = csvread('part2_A1.csv');
     elseif (algorithm == 2)
        classline = csvread('part2_A2.csv');
     elseif (algorithm == 3)
        classline = csvread('part2_A3.csv');
     elseif (algorithm == 4)
        classline = csvread('part2_A4.csv');
     elseif (algorithm == 5)
        classline = csvread('part2_A5.csv');
     end
    
    classify(classline,t)

end

function classify(classline,testdata)

   outputlbl = [];
  
   for i=1:size(testdata,1),
        a=1;
        count = [0,0,0,0,0,0,0,0,0,0];
        for j=1:9,      %checking for each classifier
            for k=0:j-1,
                 if(classline(a,:)*testdata(i,:)'<0)
                      count(j+1)=count(j+1)+1;
                    
                 else
                      count(k+1)=count(k+1)+1;   
                 end
                 a = a + 1;             
            end
        end
        [value,index]= max(count);      %taking the nearest neighbour
        outputlbl = [outputlbl;index-1];  
   end
   
   disp(outputlbl)
   
end