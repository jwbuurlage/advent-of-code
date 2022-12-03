use std::io;
use std::io::BufRead;

fn main() {
    let mut current_sum: i32 = 0;
    let mut sums: Vec<i32> = vec![];
    for line in io::stdin().lock().lines() {
        let line = line.unwrap();
        if !line.is_empty() {
            current_sum += line.parse::<i32>().unwrap();
        } else {
            sums.push(current_sum);
            current_sum = 0;
        }
    }

    let num = 3; // 1 for first part
    sums.sort();
    let result: i32 = sums.split_off(sums.len() - num).iter().sum();

    println!("{}", result)
}
