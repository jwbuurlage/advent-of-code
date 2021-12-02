y = open("data/input07.txt").readlines()


towers = []

for l in y:
    l = l.split(" ")

    n = l[0]
    w = int(l[1][1:-1])
    xs = l[3:]
    xs = map(lambda x: x.strip().replace(",", ""), xs)

    towers.append((n, w, xs))

c = towers[0][0]
while(True):
    print(c)
    found = False
    for x in towers:
        if c in x[2]:
            c = x[0]
            found = True
            break
    if not found:
        break

print(c)
