xs = list(str(open("data/input09.txt").readlines()[0]))

i = 0
g = False
d = 0
gscore = 0
score = 0
while i < len(xs):
    print(xs[i])
    if g:
        if xs[i] == ">":
            g = False
        elif xs[i] == "!":
            i += 1
        else:
            gscore += 1
    elif xs[i] == "{":
        d += 1
    elif xs[i] == "}":
        score += d
        d -= 1
    elif xs[i] == "<":
        g = True

    i += 1

print(score)
print(gscore)
