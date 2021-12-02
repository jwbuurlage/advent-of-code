inp = open('data/input16.txt').readlines()[0].strip()

ys = set()

def f(xs):
    for move in inp.split(","):
        if move[0] == 's':
            c = int(move[1:])
            xs = xs[-c:] + xs[:len(xs) - c]
        if move[0] == 'x':
            ys = move[1:].split('/')
            a = int(ys[0])
            b = int(ys[1])
            c = xs[a]
            xs[a] = xs[b]
            xs[b] = c
        if move[0] == 'p':
            ys = move[1:].split('/')
            a = xs.index(ys[0])
            b = xs.index(ys[1])
            c = xs[a]
            xs[a] = xs[b]
            xs[b] = c
    return xs

xs = list("abcdefghijklmnop")
cycle = -1
for i in range(0, 100000):
    xs = f(xs)
    if str(xs) in ys:
        cycle = i
        break
    else:
        ys.add(str(xs))

print(cycle)

xs = list("abcdefghijklmnop")
sim = 1000000000 % cycle;
for i in range(0, sim):
    xs = f(xs)

print("".join(xs))
