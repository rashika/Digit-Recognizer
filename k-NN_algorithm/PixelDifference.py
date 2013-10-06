import math

from mnist import MNIST
mndata = MNIST('./mnist')
train_data,train_label = mndata.load_training()
test_data,test_label = mndata.load_testing()

f4 = [[0 for x in range(784)]for x in range(2)]

f4_test = []
accuracy = 0

for j in range(2):
	diff = []
	count_digit = [0 for x in range(10)]
	f4_test = test_data[j]
	label = []
	for i in range(2):
		f4[i] = train_data[i]
		sum = 0
		for k in range(784):
			sum += (f4_test[k] - f4[i][k])*(f4_test[k] - f4[i][k])
		diff.append(math.sqrt(sum))
	for m in range(2):
		label.append(train_label[m])
	final = zip(diff,label)
	final.sort()
#	assuming k = 5
	for l in range(1):
		count_digit[final[l][1]] += 1
	index = count_digit.index(max(count_digit))
	if index == test_label[j]:
	  	accuracy += 1

print (accuracy/float(2))*100
print '\n'

