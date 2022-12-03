use std::io;
use std::io::BufRead;

fn a() {
    let mut sum: i32 = 0;
    for line in io::stdin().lock().lines() {
        let line = line.unwrap();
        if line.is_empty() {
            break;
        }
        let x: i32 = ((line.chars().nth(0).unwrap() as u8) - ('A' as u8)).into();
        let y: i32 = ((line.chars().nth(2).unwrap() as u8) - ('X' as u8)).into();
        let outcome = match (x, y) {
            (a, b) if a == b => 3,
            (a, b) if (a + 1) % 3 == b => 6,
            _ => 0,
        };
        sum += y + 1 + outcome;
    }

    println!("{}", sum)
}

fn b() {
    let mut sum: i32 = 0;
    for line in io::stdin().lock().lines() {
        let line = line.unwrap();
        if line.is_empty() {
            break;
        }
        let x: i32 = ((line.chars().nth(0).unwrap() as u8) - ('A' as u8)).into();
        let y: i32 = ((line.chars().nth(2).unwrap() as u8) - ('X' as u8)).into();
        let choose = match y {
            0 => (x + 2) % 3,
            1 => x,
            2 => (x + 1) % 3,
            _ => panic!("nope")
        };
        sum += choose + 1 + y * 3;
    }

    println!("{}", sum)
}

fn main() {
    b();
}
