state = map(int, open("data/input06.txt").readlines()[0].split("\t"))

v = set()
z = {}

ans = 0
while True:
    y = state.index(max(state))

    k = state[y]
    state[y] = 0
    for x in range(1, k + 1):
        state[(y + x) % len(state)] += 1
    ans += 1
    if tuple(state) in v:
        print('p2', ans - z[tuple(state)])
        break
    v.add(tuple(state))
    z[tuple(state)] = ans

print(ans)
