import math

from mnist import MNIST
mndata = MNIST('./mnist')
train_data,train_label = mndata.load_training()
test_data,test_label = mndata.load_testing()

f7 = [[0 for x in range(20)]for x in range(50)]

def calcnbhd(a,i,j,rl,ru,cl,cu):
	nbhd = 0
	if a[i][j] < 150:
		l = i
		m = j
		while (l>rl):
			if (a[l-1][m] > 150):
				nbhd += 1
				break
			l -= 1
		l = i
		m = j
		while (l<ru):
			if (a[l+1][m] > 150):
				nbhd += 1
				break
			l += 1
		l = i
		m = j
		while (m>cl):
			if (a[l][m-1] > 150):
				nbhd += 1
				break
			m -= 1
		l = i
		m = j
		while (m<cu):
			if(a[l][m+1] > 150):
				nbhd +=1
				break
			m += 1
	return nbhd

def quadone(img):
	count = [0 for x in range(20)]
	a = [[0 for x in range(28)]for x in range(28)]
	row = -1
	for j in range(len(img)):
		if j % 28 == 0:
			row += 1
		a[row][j%28] = img[j]
	for i in range(14):
		for j in range(14):
			nbhd = calcnbhd(a,i,j,0,13,0,13)
			count[nbhd] += 1
	for i in range(14):
		for j in range(14,28):
			nbhd = calcnbhd(a,i,j,0,13,14,27)
			count[5+nbhd] += 1	
	for i in range(14,28):
		for j in range(14):
			nbhd = calcnbhd(a,i,j,14,27,0,13)
			count[10+nbhd] += 1	
	for i in range(14,28):
		for j in range(14,28):
			nbhd = calcnbhd(a,i,j,14,27,14,27)
			count[15+nbhd] += 1
	return count

f7_test = []
accuracy = 0

for j in range(50):
	diff = []
	count_digit = [0 for x in range(10)]
	test_img = test_data[j]
	label = []
	f7_test = quadone(test_img)
	for i in range(50):
		img = train_data[i]
		f7[i] = quadone(img)
		s = 0
		for k in range(20):
			s += (f7_test[k] - f7[i][k])*(f7_test[k] - f7[i][k])
		diff.append(math.sqrt(s))
	for m in range(50):
		label.append(train_label[m])
	final = zip(diff,label)
	final.sort()
#	assuming k = 5
	for l in range(5):
		count_digit[final[l][1]] += 1
	index = count_digit.index(max(count_digit))
	if index == test_label[j]:
	  	accuracy += 1

print (accuracy/float(50))*100
print '\n'

