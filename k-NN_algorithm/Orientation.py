import math

from mnist import MNIST
mndata = MNIST('./mnist')
train_data,train_label = mndata.load_training()
test_data,test_label = mndata.load_testing()

f5 = [[0 for x in range(8)]for x in range(100)]

def direction(img):
	count = [0 for x in range(8)]
	a = [[0 for x in range(28)]for x in range(28)]
	row = -1
	for j in range(len(img)):
		if j % 28 == 0:
			row += 1
		a[row][j%28] = img[j]
	for i in range(14,28):
		for j in range(14,28):
			if (i==j and a[i][j] > 150):
				count[4] += 1
			if (j==14 and a[i][14] > 150):
				count[5] += 1
			if (i==14 and a[14][j] > 150):
				count[7] += 1
	for i in range(14):
		for j in range(14,28):
			if (j==14 and a[i][14] > 150):
				count[2] += 1
			if ((i+j) == 27 and a[i][j] > 150):
				count[1] += 1
	for i in range(14):
		for j in range(14):
			if (i==j and a[i][j] > 150):
				count[0] += 1
	for i in range(14,28):
		for j in range(14):
			if (i==14 and a[14][j] > 150):
				count[6] += 1
			if ((i+j) == 27 and a[i][j] > 150):
				count[3] += 1
	return count

f5_test = []
accuracy = 0

for j in range(100):
	diff = []
	count_digit = [0 for x in range(10)]
	test_img = test_data[j]
	label = []
	f5_test = direction(test_img)
	for i in range(100):
		img = train_data[i]
		f5[i] = direction(img)
		s = 0
		for k in range(8):
			s += (f5_test[k] - f5[i][k])*(f5_test[k] - f5[i][k])
		diff.append(math.sqrt(s))
	for m in range(100):
		label.append(train_label[m])
	final = zip(diff,label)
	final.sort()
#	assuming k = 5
	for l in range(5):
		count_digit[final[l][1]] += 1
	index = count_digit.index(max(count_digit))
	if index == test_label[j]:
	  	accuracy += 1

print (accuracy/float(100))*100
print '\n'

