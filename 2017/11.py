moves = open("data/input11.txt").readlines()[0].strip().split(",")
c = (0, 0)

d = {"nw": (0, 1), "n": (1, 1), "ne": (1, 0), "sw":(-1, 0), "se": (0, -1), "s": (-1, -1)}

dm = 0
for m in moves:
    a, b = c
    e, f = d[m]
    c = (a + e, b + f)
    print(c)

    if c[0] < 0 and c[1] < 0:
        x = max(abs(c[0]), abs(c[1]))
    if c[0] >= 0 and c[1] >= 0:
        x = max(c[0], c[1])
    else:
        x = abs(c[0]) + abs(c[1])
        if x > dm:
            dm = x
print(dm)


