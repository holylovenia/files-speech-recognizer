file = open('hmm4/hmmdefs', 'r')
lines = file.readlines()
file.close()

to_copy = []
check_copy = False
for line in lines:
	if check_copy:
		to_copy.append(line)
	if line.split()[0] == '~h':
		if line.split()[1] == '"sil"':
			check_copy = True
			to_copy.append('~h "sp"\n')
	
# print(to_copy)

result = []
dont_copy = False
for line in to_copy:
	if line.split()[0] == '<STATE>':
		if line.split()[1] == '2' or line.split()[1] == '4':
			dont_copy = True
		else:
			dont_copy = False

	if not(dont_copy):
		if line.split()[0] == '<NUMSTATES>':
			result.append('<NUMSTATES> 3\n')
		elif line.split()[0] == '<STATE>':
			result.append('<STATE> 2\n')
		else:
			result.append(line)

result.append('<TRANSP> 3\n')
result.append(' 0.0 1.0 0.0\n')
result.append(' 0.0 0.9 0.1\n')
result.append(' 0.0 0.0 0.0\n')
result.append('<ENDHMM>\n')

file = open('hmm4/hmmdefs', 'a')
for line in result:
	file.write(line)
file.close()