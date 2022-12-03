use std::collections::HashMap;
use std::collections::HashSet;
use std::io;
use std::io::BufRead;
use std::iter::Iterator;

fn counts(s: String) -> HashMap<char, i32> {
    let mut c = HashMap::new();
    for t in s.chars() {
        *c.entry(t).or_insert(0) += 1;
    }
    return c;
}

fn a() {
    let mut sum: i32 = 0;
    for line in io::stdin().lock().lines() {
        let line = line.unwrap();
        if line.is_empty() {
            break;
        }

        let s1: String = line.chars().take(line.len() / 2).collect::<String>();
        let s2: String = line.chars().skip(line.len() / 2).collect::<String>();

        let c1 = counts(s1);
        let c2 = counts(s2);

        let k1: HashSet<char> = c1.keys().cloned().collect();
        let k2: HashSet<char> = c2.keys().cloned().collect();
        let os: Vec<char> = k1.intersection(&k2).cloned().collect();

        let o = os.get(0).unwrap().clone();

        let values: Vec<char> = ('a'..='z').chain('A'..='Z').collect();

        sum += 1 + values.iter().position(|x| *x == o).unwrap() as i32;
    }

    println!("{}", sum)
}

fn b() {
    let mut sum: i32 = 0;
    let lines: Vec<_> = io::stdin().lock().lines().map(|x| x.unwrap()).collect();

    for line in lines.chunks(3) {
        let s1: String = line[0].clone();
        let s2: String = line[1].clone();
        let s3: String = line[2].clone();

        let c1 = counts(s1);
        let c2 = counts(s2);
        let c3 = counts(s3);

        let k1: HashSet<char> = c1.keys().cloned().collect();
        let k2: HashSet<char> = c2.keys().cloned().collect();
        let k3: HashSet<char> = c3.keys().cloned().collect();
        let k12: HashSet<char> = k1.intersection(&k2).cloned().collect();
        let k: Vec<char> = k12.intersection(&k3).cloned().collect();

        let o = k.get(0).unwrap().clone();

        let values: Vec<char> = ('a'..='z').chain('A'..='Z').collect();

        sum += 1 + values.iter().position(|x| *x == o).unwrap() as i32;
    }

    println!("{}", sum)
}

fn main() {
    b();
}
