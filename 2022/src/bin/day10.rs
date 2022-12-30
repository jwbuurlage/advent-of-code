use std::io;
use std::io::prelude::*;

fn main() -> io::Result<()> {
    let mut t: usize = 0;
    let mut x: i64 = 1;
    let mut xs = vec![];
    let mut screen: Vec<Vec<char>> = vec![vec!['.'; 40].into(); 6];

    let mut inc_and_check = |x| {
        t += 1;
        if t >= 20 && (t == 20 || (((t - 20) % 40) == 0)) {
            xs.push(x * (t as i64));
        }

        let line: usize = ((t - 1) / 40).into();
        let pixel = (t - 1) % 40;
        let pi = pixel as i64;
        if ((pi - x) as i64).abs() <= 1 {
            screen[line][pixel] = '#';
        }
    };

    let stdin = io::stdin();
    for line_result in stdin.lock().lines() {
        let line = line_result?;
        if line == "noop" {
            inc_and_check(x);
        }
        if line.starts_with("addx ") {
            let y = &line[5..].parse::<i64>().unwrap();
            inc_and_check(x);
            inc_and_check(x);
            x += y;
        }
    }
    println!("A: {:?}", xs.iter().sum::<i64>());

    let render = screen
        .iter()
        .map(|x| x.iter().collect::<String>())
        .collect::<Vec<String>>()
        .join("\n");
    println!("{}\n", render);

    Ok(())
}
