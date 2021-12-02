def spiral(n):
    if n == 0: return 1
    return 2 * (2 * n + 1 + 2 * (n - 1) + 1)

t = int(input())
s = 0
n = -1
while t > s:
    n += 1
    s += spiral(n)
s -= spiral(n)

i, j = n - 1, n
c = s + 1

moves = [(-1, 0)] * (2 * n - 1) + [(0, -1)] * (2 * n) + [(1, 0)] * (2 * n) + [(0, 1)] * (2 * n)

for a, b in moves:
    if c == t:
        break
    i += a
    j += b
    c += 1

print(abs(i) + abs(j))

large = 1000
grid = [[0 for i in range(0, large)] for j in range(0, large)]

grid[0][0] = 1
i, j = 0, 1

dx = [-1, -1, -1, 0, 0, 1, 1, 1];
dy = [-1, 0, 1, -1, 1, -1, 0, 1];

for n in range(1, 200000):
    moves = [(-1, 0)] * (2 * n - 1) + [(0, -1)] * (2 * n) + [(1, 0)] * (2 * n) + [(0, 1)] * (2 * n + 1)
    for a, b in moves:
        c = 0;
        for k in range(0, 8):
            c += grid[i + dx[k]][j + dy[k]]
        if c > t:
            print(c)
            exit(0)
        grid[i][j] = c
        i += a
        j += b
