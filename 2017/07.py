y = open("data/input07.txt").readlines()

towers = {}

for l in y:
    l = map(lambda x: x.strip(), l.split(" "))

    n = l[0]
    w = int(l[1][1:-1])
    xs = l[3:]
    xs = map(lambda x: x.replace(",", ""), xs)

    towers[n] = (w, xs)

root = "vmpywg"

ws = {}

def weight(n):
    if n in ws:
        return ws[n]
    w = towers[n][0]
    for y in towers[n][1]:
        w += weight(y)
    ws[n] = w
    return w

prev = root
c = root
weight(c)

while True:
    weights = [ws[n] for n in towers[c][1]]
    k = -1
    for i in range(0, len(weights)):
        if not weights[i] in weights[0:i] + weights[i + 1:]:
            k = i
            break
    if k < 0:
        print(prev, c, "lowest so that all childs are equal")
        break
    prev = c
    c = towers[c][1][k]

stats = [ws[n] for n in towers[prev][1]]
print(stats, towers[c][0])
# .. can read off from this, done!
