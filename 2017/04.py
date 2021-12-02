ans = 0
xs = open("data/input04.txt").readlines()
for x in xs:
    ys = x.strip().split(" ")
    ys = map(lambda x: str(sorted(list(x))), ys)
    if len(set(ys)) == len(ys):
        ans += 1
print(ans)
