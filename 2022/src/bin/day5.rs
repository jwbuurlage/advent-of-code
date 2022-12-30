use text_io::*;

fn parse_ln() -> Result<String, text_io::Error> {
    try_read!("{}\n")
}

fn parse_stacks() -> Vec<Vec<char>> {
    let mut lines: Vec<String> = vec![];
    while let Ok(ln) = parse_ln() {
        if ln.is_empty() {
            lines.pop(); // Last line is just indexing
            break;
        }

        let ln = ln.replace("    ", " ");
        let ln = ln.replace("[", "");
        let ln = ln.replace("] ", "");
        let ln = ln.replace("]", "");

        lines.push(ln);
    }
    let num = lines
        .iter()
        .max_by(|lhs, rhs| lhs.len().cmp(&rhs.len()))
        .map_or(0, |x| x.len());
    let mut stacks: Vec<Vec<char>> = vec![vec![]; num];

    lines.reverse();
    for ln in lines {
        ln.chars().into_iter().enumerate().for_each(|(idx, c)| {
            if c != ' ' {
                stacks[idx].push(c)
            }
        })
    }

    stacks
}

fn parse_moves() -> Vec<(i32, usize, usize)> {
    fn parse_move() -> Result<(i32, usize, usize), Box<dyn std::error::Error>> {
        let a: i32;
        let b: usize;
        let c: usize;
        try_scan!("move {} from {} to {}", a, b, c);
        Ok((a, b, c))
    }

    let mut moves = vec![];
    while let Ok(mv) = parse_move() {
        moves.push(mv);
    }
    moves
}

fn main() {
    let mut stacks: Vec<Vec<char>> = parse_stacks();
    let moves = parse_moves();

    // A
    // moves.iter().for_each(|(a, b, c)| {
    //     for _ in 0 .. *a {
    //         let d = stacks[*b - 1].pop().unwrap();
    //         stacks[*c - 1].push(d);
    //     }
    // });

    // B
    moves.iter().for_each(|(a, b, c)| {
        let mut e = vec![];
        for _ in 0 .. *a {
            e.push(stacks[*b - 1].pop().unwrap());
        }
        e.reverse();
        e.iter().for_each(|x| stacks[*c - 1].push(*x));
    });

    let tops: String = stacks.iter().map(|s| *s.last().unwrap()).collect();
    println!("{:?}", tops);
}
