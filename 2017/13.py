inp = open("data/input13.txt").readlines()

layers = {}
for line in inp:
    xs = line.split(": ")
    layers[int(xs[0])] = int(xs[1])

for x in range(0, 10000000):
    t = x
    p = 0
    ans = 0
    caught = False
    for p in range(0, max(layers.keys()) + 5):
        if p in layers:
            d = layers[p]
            top = (t % (2 * (d - 1))) == 0
            if top:
                ans += p * layers[p]
                caught = True
        t += 1
    if x == 0:
        print(ans)
    if not caught:
        print(x)
        exit(0)
