import os

dir_path = input('Directory path: ')
print(os.listdir(dir_path))
for filename in os.listdir(dir_path):
	number = filename.replace('sample', '').split('.')[0]
	print(number)
	number = int(number) + 172
	os.rename(dir_path + '/' + filename, dir_path + '/' + 'sample' + str(number) + '.wav')