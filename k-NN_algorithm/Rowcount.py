import math

from mnist import MNIST
mndata = MNIST('./mnist')
train_data,train_label = mndata.load_training()
test_data,test_label = mndata.load_testing()

f3 = [[0 for x in range(28)]for x in range(5000)]

def countone(img):
	row = -1
	count = [0 for x in range(28)]
	for j in range(len(img)):
		if j%28 == 0:
			row += 1
		if img[j] > 0:
			count[row] += 1
	return count

f3_test = []
accuracy = 0

for j in range(5000):
	diff = []
	count_digit = [0 for x in range(10)]
	test_img = test_data[j]
	label = []
	f3_test = countone(test_img)
	for i in range(5000):
		img = train_data[i]
		f3[i] = countone(img)
		sum = 0
		for k in range(28):
			sum += (f3_test[k] - f3[i][k])*(f3_test[k] - f3[i][k])
		diff.append(math.sqrt(sum))
	for m in range(5000):
		label.append(train_label[m])
	final = zip(diff,label)
	final.sort()
#	assuming k = 5
	for l in range(5):
		count_digit[final[l][1]] += 1
	index = count_digit.index(max(count_digit))
	if index == test_label[j]:
	  	accuracy += 1

print (accuracy/float(5000))*100
print '\n'

