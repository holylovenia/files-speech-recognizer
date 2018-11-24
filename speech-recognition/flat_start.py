f1 = open('hmm0/hmmdefs', 'r')
lines = f1.readlines()
f1.close()

proto_file = open('hmm0/proto', 'r')
lines_proto = proto_file.readlines()
for i in range(4):
	del lines_proto[0]

f2 = open('hmm0/hmmdefs', 'w')
for line in lines:
	phone = line.strip()
	f2.write('~h ' + '"' + phone + '"' + '\n')
	
	for line_porto in lines_proto:
		f2.write(line_porto)