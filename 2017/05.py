xs = open("data/input05.txt").readlines()
xs = map(int, xs)

print(xs)

ans = 0;
p = 0;
while True:
    if p < 0 or p >= len(xs):
        break
    y = xs[p]
    if y >= 3:
        xs[p] -= 1
    else:
        xs[p] += 1
    p += y
    ans += 1
print(ans)
