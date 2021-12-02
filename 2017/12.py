xs = open("data/input12.txt").readlines()

es = {}

for x in xs:
    x = x.strip().split(" ")
    a = int(x[0])
    b = map(lambda y: int(y.replace(",", "")), x[2:])
    es[a] = b

comp = set([0])
stack = [0]
visited = set()
while len(stack) > 0:
    x = stack.pop()
    visited.add(x)
    comp.add(x)
    for e in es[x]:
        if e not in visited:
            stack.append(e)

print(len(comp))

groups = 1
while len(visited) != len(es):
    for x in es.keys():
        if not x in visited:
            groups += 1
            stack = [x]
            while len(stack) > 0:
                x = stack.pop()
                visited.add(x)
                comp.add(x)
                for e in es[x]:
                    if e not in visited:
                        stack.append(e)
            break

print(groups)
