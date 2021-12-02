#a = 65
#b = 8921

a = 116
b = 299

ans = 0

for i in range(0, 5000000):
    a  = (a * 16807) % 2147483647
    while (a % 4) != 0:
        a  = (a * 16807) % 2147483647
    b  = (b * 48271) % 2147483647
    while (b % 8) != 0:
        b  = (b * 48271) % 2147483647
    abin = bin(a)[2:].rjust(16, '0')[-16:]
    bbin = bin(b)[2:].rjust(16, '0')[-16:]
    if abin == bbin:
        ans += 1
    if i % 1000000 == 0:
        print(i)

print(ans)
