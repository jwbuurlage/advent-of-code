import numpy as np

def knot_hash(key):
    ys = list(map(ord, list(key)))
    ys.extend([17, 31, 73, 47, 23])

    n = 256
    xs = list(range(0, n))
    c = 0
    s = 0

    for k in range(0, 64):
        for y in ys:
            ls = []
            if c + y >= len(xs):
                ls += xs[c:] + xs[0:c + y - len(xs)]
            else:
                ls = xs[c:c + y]
            ls.reverse()
            if c + y >= len(xs):
                xs[c:len(xs)] = ls[0:len(xs) - c]
                xs[0:c + y - len(xs)] = ls[(len(xs) - c):]
            else:
                xs[c:c + y] = ls[:]
            c += y + s
            c = c % len(xs)
            s += 1

    xs = np.array(xs)
    gs = np.split(xs, 16)

    def f(g):
        r = g[0]
        for x in g[1:]:
            r ^= x
        return r

    gs = map(f, gs)
    gs = map(lambda x: hex(x)[2:4], gs)

    return "".join(gs)


inp = "hxtvlmkl"
print(knot_hash(inp))

ans = 0
for i in range(0, 128):
    hashed = list(knot_hash(inp +'-'+str(i)))
    print(hashed)
    row = "".join(list(map(lambda x: bin(int(x, 16))[2:].rjust(4, '0'), hashed)))
    print(row)
    ans += row.count('1')

print(ans)
