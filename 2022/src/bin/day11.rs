use text_io::*;

#[derive(Debug)]
struct Monkey {
    items: Vec<i64>,
    operation: char,
    a: String,
    b: String,
    divisor: i64,
    if_true: usize,
    if_false: usize,
}

fn parse_monkey() -> Result<Monkey, text_io::Error> {
    let idx: i64;
    let items_string: String;
    let operation: char;
    let a: String;
    let b: String;
    let divisor: i64;
    let if_true: usize;
    let if_false: usize;
    try_scan!(
        "Monkey {}:
  Starting items: {}
  Operation: new = {} {} {}
  Test: divisible by {}
    If true: throw to monkey {}
    If false: throw to monkey {}\n\n",
        idx,
        items_string,
        a,
        operation,
        b,
        divisor,
        if_true,
        if_false
    );

    let items = items_string
        .split(", ")
        .map(|x| {
            println!("try parse {}", x);
            x.parse::<i64>().unwrap()
        })
        .collect();

    Ok(Monkey {
        items,
        a,
        operation,
        b,
        divisor,
        if_true,
        if_false,
    })
}

fn parse_monkeys() -> Vec<Monkey> {
    let mut xs = vec![];
    while let Ok(x) = parse_monkey() {
        xs.push(x);
    }
    xs
}

fn main() {
    let mut monkeys = parse_monkeys();

    let mut inspected = vec![0; monkeys.len()];

    let p: i64 = monkeys.iter().map(|x| x.divisor).product();

    for _ in 0..10000 {
        // Simulate
        for i in 0..monkeys.len() {
            for a in 0..monkeys[i].items.len() {
                inspected[i] += 1;
                let j = monkeys[i].items[a];
                let k = if monkeys[i].b == "old" {
                    if monkeys[i].operation == '*' {
                        j * j
                    } else {
                        j + j
                    }
                } else {
                    let w = &monkeys[i].b.parse::<i64>().unwrap();
                    if monkeys[i].operation == '*' {
                        j * w
                    } else {
                        j + w
                    }
                };
                let m = k % p;

                let b = if m % &monkeys[i].divisor == 0 {
                    monkeys[i].if_true
                } else {
                    monkeys[i].if_false
                };
                monkeys[b].items.push(m);
            }
            monkeys[i].items.clear();
        }
    }

    inspected.sort();
    println!("A: {}", inspected.iter().rev().take(2).product::<i64>())
}
