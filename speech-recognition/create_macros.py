file_proto = open('hmm0/proto', 'r')
lines_proto = file_proto.readlines()
file_proto.close()

file_macros = open('hmm0/macros', 'r')
lines_macros = file_macros.readlines()
file_macros.close()

file_macros = open('hmm0/macros', 'w')
for line in lines_proto[:3]:
	file_macros.write(line)
for line in lines_macros:
	file_macros.write(line)