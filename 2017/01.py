xs = list(str(input()))

ans = 0
for i in range(0, len(xs)):
    if xs[i] == xs[i - 1]:
        ans += int(xs[i])
print(ans)

fwd = len(xs) // 2
ans = 0
for i in range(0, len(xs)):
    if xs[i] == xs[(i + fwd) % len(xs)] :
        ans += int(xs[i])
print(ans)
