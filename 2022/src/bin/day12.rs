use text_io::*;

use std::collections::{HashSet, VecDeque};

fn parse_grid() -> Vec<Vec<char>> {
    fn parse_ln() -> Result<String, text_io::Error> {
        try_read!("{}\n")
    }

    let mut lines = vec![];
    while let Ok(ln) = parse_ln() {
        if ln.is_empty() {
            break;
        }
        lines.push(ln);
    }
    lines.iter().map(|x| x.chars().collect()).collect()
}

fn bfs(grid: Vec<Vec<char>>, s: (i32, i32), e: (i32, i32)) -> Option<i32> {
    println!("bfs: {:?}, {:?}", s, e);
    let h = grid.len();
    let w = grid[0].len();

    let mut vis = HashSet::new();
    let mut q = VecDeque::new();
    q.push_back((s, 0));

    const DX: [i32; 4] = [0, 1, 0, -1];
    const DY: [i32; 4] = [1, 0, -1, 0];

    while let Some(((i, j), steps)) = q.pop_front() {
        if (i, j) == e {
            return Some(steps);
        }
        if vis.contains(&(i, j)) {
            continue;
        }
        vis.insert((i, j));

        let v = grid[i as usize][j as usize] as u32;

        for d in 0..4 {
            let k = i + DX[d];
            let l = j + DY[d];
            if (k >= 0 && k < h as i32) && (l >= 0 && l < w as i32) {
                let v2 = grid[k as usize][l as usize] as u32;
                if v2 <= v + 1 {
                    q.push_back(((k, l), steps + 1));
                }
            }
        }
    }
    None
}

fn main() {
    let mut grid = parse_grid();

    let find_pos = |c| -> Option<(i32, i32)> {
        let x: Vec<Option<usize>> = grid
            .iter()
            .map(|x| x.iter().position(|&y| y == c))
            .collect();
        let y = x.iter().position(|x| x.is_some())?;
        Some((y as i32, x[y].unwrap() as i32))
    };

    let s: (i32, i32) = find_pos('S').unwrap();
    let e: (i32, i32) = find_pos('E').unwrap();
    grid[s.0 as usize][s.1 as usize] = 'a';
    grid[e.0 as usize][e.1 as usize] = 'z';

    let h = grid.len();
    let w = grid[0].len();

    let mut best = i32::MAX;
    for i in 0..h {
        for j in 0..w {
            if grid[i][j] == 'a' {
                if let Some(d) = bfs(grid.clone(), (i as i32, j as i32), e) {
                    if d < best {
                        best = d;
                    }
                }
            }
        }
    }

    println!("B: {:?}", best);
}
