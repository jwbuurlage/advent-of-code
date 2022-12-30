use text_io::*;

fn parse_ranges() -> Result<(i32, i32, i32, i32), Box<dyn std::error::Error>> {
    let a: i32;
    let b: i32;
    let c: i32;
    let d: i32;
    try_scan!("{}-{},{}-{}", a, b, c, d);
    Ok((a, b, c, d))
}

fn main() {
    let mut ans1 = 0;
    let mut ans2 = 0;
    while let Ok((a, b, c, d)) = parse_ranges() {
        if (a <= c && b >= d) || (c <= a && d >= b) {
            ans1 += 1
        }
        if ((a <= c && c <= b) || (a <= d && d <= b)) || ((c <= a && a <= d) || (c <= b && b <= d))
        {
            ans2 += 1
        }
    }
    println!("A: {}, B: {}", ans1, ans2);
}
