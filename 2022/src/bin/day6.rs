use text_io::*;
use std::collections::HashSet;

fn main() {
    let s: String = read!();
    let mut ans = 0;
    let a = 13; // 3 for A
    for i in a .. s.len() {
     let slc = &s[(i - a) ..= (i)];
        let chars: HashSet<char> = HashSet::from_iter(slc.chars());
        if chars.len() == a + 1 {
            ans = i + 1;
            break;
        }
    }
    println!("B: {}", ans)
}
