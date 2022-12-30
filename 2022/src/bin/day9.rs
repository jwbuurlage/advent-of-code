use std::collections::HashSet;

use text_io::*;

fn parse_commands() -> Vec<(char, i32)> {
    fn parse_command() -> Result<(char, i32), Box<dyn std::error::Error>> {
        let a: char;
        let b: i32;
        try_scan!("{} {}", a, b);
        Ok((a, b))
    }
    let mut cmds = vec![];
    while let Ok(cmd) = parse_command() {
        cmds.push(cmd);
    }
    cmds
}

fn a() {
    let mut h: (i32, i32) = (0, 0);
    let mut t: (i32, i32) = (0, 0);

    let mut vis = HashSet::new();
    vis.insert(t);

    for (c, x) in parse_commands() {
        for _ in 0..x {
            match c  {
                'R' => h.0 += 1,
                'L' => h.0 -= 1,
                'U' => h.1 += 1,
                'D' => h.1 -= 1,
                _ => panic!("nope")
            }
            if (t.0 - h.0).abs() < 2 && (t.1 - h.1).abs() < 2 {
                continue;
            }
            if t.0 != h.0 {
                if h.0 > t.0 { t.0 += 1 } else { t.0 -= 1 }
            }
            if t.1 != h.1 {
                if h.1 > t.1 { t.1 += 1 } else { t.1 -= 1 }
            }
            vis.insert(t);
        }
    }

    println!("A: {}", vis.len());
}

fn b() {
    let mut knots: Vec<(i32, i32)> = vec![(0, 0); 10];

    let mut vis = HashSet::new();
    vis.insert(knots[0]);

    for (c, x) in parse_commands() {
        for _ in 0..x {
            match c  {
                'R' => knots[0].0 += 1,
                'L' => knots[0].0 -= 1,
                'U' => knots[0].1 += 1,
                'D' => knots[0].1 -= 1,
                _ => panic!("nope")
            }

            for i in 0..9 {
                let h = knots[i];
                let mut t = knots[i + 1];
                if (t.0 - h.0).abs() < 2 && (t.1 - h.1).abs() < 2 {
                    continue;
                }
                if t.0 != h.0 {
                    if h.0 > t.0 { t.0 += 1 } else { t.0 -= 1 }
                }
                if t.1 != h.1 {
                    if h.1 > t.1 { t.1 += 1 } else { t.1 -= 1 }
                }
                knots[i + 1] = t;
            }
            vis.insert(knots[9]);
        }
    }

    println!("B: {}", vis.len());
}


fn main() {
    // a();
    b();
}
