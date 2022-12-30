use std::{io::{self, Read}};

#[derive(Debug, PartialEq, Eq, Clone)]
enum Entry {
    Integer(i32),
    List(Vec<Entry>),
}

// Return the next element, either an int or a list
fn scan_element<'a>(s: &'a [char]) -> Option<(&'a [char], &'a [char])> {
    if s.is_empty()
        || s[0] == ']' {
        return None;
    }
    let mut open = 0;
    for i in 0..s.len() {
        match s[i] {
            '[' => open += 1,
            ']' => {
                open -= 1;
                if open <= 0 {
                    return Some((&s[0..i + 1], &s[i + 2..]));
                }
            }
            '0'..= '9' if open == 0 => {
                if s[i + 1] >= '0' && s[i + 1] <= '9' {
                    return Some((&s[0..i + 2], &s[i + 3..]));
                } else {
                    return Some((&s[0..i + 1], &s[i + 2..]));
                }
            }
            _ => {}
        }
    }
    None
}

fn parse_input(input: &[char]) -> Entry {
    let mut rest = &input[1..];
    let mut entries = vec![];
    if input[0] == '[' {
        while let Some((elem, tail)) = scan_element(&rest) {
            entries.push(parse_input(elem));
            rest = tail;
        }
        Entry::List(entries)
    }
    else if input[0].is_digit(10) {
        Entry::Integer(input.iter().collect::<String>().parse::<i32>().expect(format!("tried to parse {:?}", input).as_str()))
    }
    else {
        panic!("do not know what to do with {:?}", input);
    }
}

impl PartialOrd for Entry {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        match self {
            Entry::Integer(x) => {
                match other {
                    Entry::Integer(y) => Some(x.cmp(y)),
                    Entry::List(ys) => Entry::List(vec![Entry::Integer(*x)]).partial_cmp(&other)
                }
            },
            s@Entry::List(xs) => {
                match other {
                    Entry::Integer(y) => s.partial_cmp(&Entry::List(vec![Entry::Integer(*y)])),
                    Entry::List(ys) => xs.partial_cmp(ys),
                }

            }
        }
    }
}

impl Ord for Entry {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.partial_cmp(other).unwrap()
    }
}

fn a() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let lines: Vec<&str> = input.lines().collect();

    let mut index = 1;
    let mut ans = 0;
    for group in lines.chunks(3) {
        let a: Vec<char> = group[0].chars().collect();
        let b: Vec<char> = group[1].chars().collect();
        let x1 = parse_input(&a[..]);
        let x2 = parse_input(&b[..]);

        if  x1.partial_cmp(&x2) == Some(std::cmp::Ordering::Less) {
            ans += index;
        }

        index += 1;
    }

    println!("A: {}", ans);
}

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let lines: Vec<&str> = input.lines().collect();

    let div1 = Entry::List(vec![Entry::List(vec![Entry::Integer(2)])]);
    let div2 = Entry::List(vec![Entry::List(vec![Entry::Integer(6)])]);
    let mut entries = vec![div1.clone(), div2.clone()];

    for line in lines {
        if line.is_empty() { continue; }
        let a: Vec<char> = line.chars().collect();
        entries.push(parse_input(&a[..]));
    }

    entries.sort();

    let pos1 = entries.iter().position(|x| x == &div1).unwrap();
    let pos2 = entries.iter().position(|x| x == &div2).unwrap();

    println!("B: {:?}", (pos1 + 1) * (pos2 + 1));
}
