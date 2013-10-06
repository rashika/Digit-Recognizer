import math

from mnist import MNIST
mndata = MNIST('./mnist')
train_data,train_label = mndata.load_training()
test_data,test_label = mndata.load_testing()

a = [[0 for x in range(28)] for x in range(28)]
b = [[0 for x in range(28)] for x in range(28)]

accuracy = 0

for test in range(20):
	diff = []
	label = []
	count_digit = [0 for x in range(10)]
	f2_test = [0 for x in range(49)]
	f2 = [[0 for x in range(49)] for x in range(1000)]
	for i in range(1000):
		img = train_data[i]
		f2_test = [0 for x in range(49)]
		test_img = test_data[test]
		row = -1
		for j in range(len(img)):
			if (j%28 == 0):
				row += 1
			a[row][j%28] = img[j]
			b[row][j%28] = test_img[j]
		matrix_num = -7
		for j in range(28):
			count = -1
			if j % 4 == 0:
				matrix_num += 7
			for k in range(28):
				if k % 4 == 0:
					count += 1
				if a[j][k] > 150:
					f2[i][matrix_num+count] += 1
				if b[j][k] > 150:
					f2_test[matrix_num+count] += 1
		for j in range(49):
			f2_test[j] = (f2_test[j]/float(16))*100
			f2[i][j] = (f2[i][j]/float(16))*100
		s = 0
		for k in range(49):
			s += (f2_test[k] - f2[i][k])*(f2_test[k] - f2[i][k])
		diff.append(math.sqrt(s))
	for m in range(1000):
		label.append(train_label[m])
	final = zip(diff,label)
	final.sort()
#   assuming k = 5
	for l in range(5):
		count_digit[final[l][1]] += 1
	index = count_digit.index(max(count_digit))
	if index == test_label[test]:
		accuracy += 1

print (accuracy/float(20))*100
print '\n'


