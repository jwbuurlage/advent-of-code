use std::collections::HashSet;

use text_io::*;

fn parse_row() -> Result<Vec<i32>, text_io::Error> {
    let s: Result<String, text_io::Error> = try_read!("{}\n");
    let trees: Vec<i32> = s?.chars().map(|x| x.to_string().parse::<i32>().unwrap()).collect();
    Ok(trees)
}

fn parse_grid() -> Vec<Vec<i32>> {
    let mut grid = vec![];
    while let Ok(trees) = parse_row() {
        if trees.is_empty() {
            break;
        }
        grid.push(trees);
    }
    grid
}

fn a() {
    let mut grid = parse_grid();
    let w = grid[0].len();
    let h = grid.len();
    let mut ans = 2 * w + 2 * h - 4;

    let mut visible = HashSet::new();

    for row in 1..(h-1) {
        let mut max = grid[row][0];
        for col in 1..(w-1) {
            if grid[row][col] > max {
                visible.insert((row, col));
                max = grid[row][col];
            }
        }
        let mut max = grid[row][w - 1];
        for col in (1..(w-1)).rev() {
            if grid[row][col] > max {
                visible.insert((row, col));
                max = grid[row][col];
            }
        }
    }
    for col in 1..(w-1) {
        let mut max = grid[0][col];
        for row in 1..(h-1) {
            if grid[row][col] > max {
                visible.insert((row, col));
                max = grid[row][col];
            }
        }
        let mut max = grid[h - 1][col];
        for row in (1..(h-1)).rev() {
            if grid[row][col] > max {
                visible.insert((row, col));
                max = grid[row][col];
            }
        }
    }

    println!("A: {}", ans + visible.len());
}

fn b() {
    let grid = parse_grid();
    let w = grid[0].len();
    let h = grid.len();

    let mut max = 0;
    for row in 1..(h-1) {
        for col in 1..(w-1) {
            let mut left = grid[row][0..col].iter().rev().take_while(|&x| x < &grid[row][col]).count();
            let mut right = grid[row][(col+1)..].iter().take_while(|&x| x < &grid[row][col]).count();
            let mut top = grid[0..row].iter().rev().map(|x| x[col]).take_while(|&x| x < grid[row][col]).count();
            let mut bottom = grid[row+1..].iter().map(|x| x[col]).take_while(|&x| x < grid[row][col]).count();
            if left < col { left += 1 }
            if right < w - col - 1 { right += 1 }
            if top < row { top += 1 }
            if bottom < h - row - 1{ bottom += 1 }
            println!("{}-{} => {} x {} x {} x {}", row, col, left, right, top, bottom);
            max = std::cmp::max(left * right * top * bottom, max);
        }
    }

    println!("B: {}", max);
}

fn main() {
    //a();
    b();
}
