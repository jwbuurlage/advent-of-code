xs = open("data/input08.txt").readlines()

reg = {}

highest = 0

for x in xs:
    y = x.split(" ")
    if not y[4] in reg:
        reg[y[4]] = 0

    if y[5] == ">":
        if not reg[y[4]] > int(y[6]):
            continue
    if y[5] == "<":
        if not reg[y[4]] < int(y[6]):
            continue
    if y[5] == ">=":
        if not reg[y[4]] >= int(y[6]):
            continue
    if y[5] == "<=":
        if not reg[y[4]] <= int(y[6]):
            continue
    if y[5] == "==":
        if not reg[y[4]] == int(y[6]):
            continue
    if y[5] == "!=":
        if not reg[y[4]] != int(y[6]):
            continue

    if not y[0] in reg:
        reg[y[0]] = 0

    if y[1] == "inc":
        reg[y[0]] += int(y[2])
    elif y[1] == "dec":
        reg[y[0]] -= int(y[2])
    if reg[y[0]] > highest:
        highest = reg[y[0]]


print(max(reg.values()))
print(highest)
