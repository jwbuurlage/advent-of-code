ans = 0
xs = open("data/input02.txt").readlines()
for x in xs:
    ys = map(int, x.split("\t"))
    ans += max(ys) - min(ys)
print(ans)

ans = 0;
for x in xs:
    ys = map(int, x.split("\t"))
    for y in ys:
        for z in ys:
            if y == z:
                continue
            if y % z == 0:
                ans += y // z
print(ans)

