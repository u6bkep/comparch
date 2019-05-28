import sys

f = open(sys.argv[1], "r")
i = 0

for x in f:
    print("#0x{}".format(x.strip()))
    print("force instruction_memory/memory({}) 16#{}{}".format(i, x[0], x[1]))
    print("force instruction_memory/memory({}) 16#{}{}".format(i + 1, x[2], x[3]))
    print("force instruction_memory/memory({}) 16#{}{}".format(i + 2, x[4], x[5]))
    print("force instruction_memory/memory({}) 16#{}{}".format(i + 3, x[6], x[7]) + "\n#")
    i = i + 4

f.close()
