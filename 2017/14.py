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

    gs = list(map(f, gs))
    gs = list(map(lambda x: hex(x)[2:].rjust(2,'0'), gs))

    return "".join(gs)


inp = "hxtvlmkl"
print(knot_hash(inp))

grid = [[0 for _ in range(0, 130)] for _ in range(0, 130)]

ans = 0
for i in range(0, 128):
    hashed = list(knot_hash(inp +'-'+str(i)))
    grid[i][1:129] = list("".join(list(map(lambda x: bin(int(x, 16))[2:].rjust(4, '0'), hashed))))

visited = [[False for _ in range(0, 130)] for _ in range(0, 130)]

dx = [-1, 0, 1, 0]
dy = [0, 1, 0, -1]

ans = 0
while True:
    # find unvisited 1
    stack = []
    found = False
    for i in range(0, 130):
        for j in range(0, 130):
            if grid[i][j] == '1' and not visited[i][j]:
                stack.append((i, j))
                found = True
                break
        if found:
            break
    if len(stack) == 0:
        break

    ans += 1
    while len(stack) > 0:
        i, j = stack.pop()
        visited[i][j] = True
        for k in range(0, 4):
            a = i + dx[k]
            b = j + dy[k]
            if grid[a][b] == '1' and not visited[a][b]:
                stack.append((a, b))


print(ans)
