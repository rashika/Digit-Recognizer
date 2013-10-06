import math

from mnist import MNIST
mndata = MNIST('./mnist')
train_data,train_label = mndata.load_training()
test_data,test_label = mndata.load_testing()

a = [[0 for x in range(28)] for x in range(28)]
b = [[0 for x in range(28)] for x in range(28)]

accuracy = 0

def calc(a):
	count = [0 for x in range(265)]
	matrix_num = -14
	for j in range(28):
		c = -1
		if j % 2 == 0:
			matrix_num += 14
		for k in range(28):
			if k % 2 == 0:
				c += 1
			if a[j][k] > 150:
				count[matrix_num+c] += 1
	for j in range(196):
		count[j] = (count[j]/float(4))*100
	matrix_num = -7
	for j in range(28):
		c = -1
		if j % 4 == 0:
			matrix_num += 7
		for k in range(28):
			if k % 4 == 0:
				c += 1
			if a[j][k] > 150:
				count[196+matrix_num+c] += 1
	for j in range(196,245):
		count[j] = (count[j]/float(16))*100
	matrix_num = -4
	for j in range(28):
		c = -1
		if j % 7 == 0:
			matrix_num += 4
		for k in range(28):
			if k % 7 == 0:
				c += 1
			if a[j][k] > 150:
				count[196+49+matrix_num+c] += 1
	for j in range(245,261):
		count[j] = (count[j]/float(49))*100
	matrix_num = -2
	for j in range(28):
		c = -1
		if j % 14 == 0:
			matrix_num += 2
		for k in range(28):
			if k % 14 == 0:
				c += 1
			if a[j][k] > 150:
				count[196+49+16+matrix_num+c] += 1
	for j in range(261,265):
		count[j] = (count[j]/float(196))*100
	return count


for test in range(20):
	diff = []
	label = []
	count_digit = [0 for x in range(10)]
	f2_test = [0 for x in range(49)]
	f2 = [[0 for x in range(265)] for x in range(5000)]
	for i in range(5000):
		img = train_data[i]
		f2_test = [0 for x in range(265)]
		test_img = test_data[test]
		row = -1
		for j in range(len(img)):
			if (j%28 == 0):
				row += 1
			a[row][j%28] = img[j]
			b[row][j%28] = test_img[j]
		f2[i] = calc(a)
		f2_test = calc(b)
		s = 0
		for k in range(265):
			s += (f2_test[k] - f2[i][k])*(f2_test[k] - f2[i][k])
		diff.append(math.sqrt(s))
	for m in range(5000):
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


