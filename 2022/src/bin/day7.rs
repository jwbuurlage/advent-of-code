use std::collections::{HashSet, HashMap};

use text_io::*;

fn input() -> Vec<String> {
    fn parse_ln() -> Result<String, text_io::Error> {
        try_read!("{}\n")
    }

    let mut lines = vec![];
    while let Ok(ln) = parse_ln() {
        if ln.is_empty() { break; }
        lines.push(ln);
    }
    lines
}

fn main() {
    let mut visited = HashSet::new();
    let mut dir_sizes = HashMap::new();

    let mut current_path: Vec<String> = vec![];
    let lines: Vec<String> = input();
    let mut idx: usize = 0;
    while idx < lines.len() {
        if lines[idx] == "$ ls" {
            let full_path: String = current_path.join("/");
            if visited.contains(&full_path) {
                idx += 1;
                continue;
            }
            let mut size = 0;
            while (idx + 1 < lines.len()) && !lines[idx + 1].starts_with("$") {
                idx += 1;
                if lines[idx].starts_with("dir") { continue; }
                let file_size = lines[idx].split(" ").next().unwrap();
                size += file_size.parse::<usize>().unwrap();
            }

            // println!("> {} {:?} {}", full_path, current_path, size);

            // Add to all parents
            let mut parent: String = "".into();
            for comp in &current_path {
                parent = parent + comp.as_str() + "/";
                if !dir_sizes.contains_key(&parent) {
                    dir_sizes.insert(parent.clone(), 0);
                }
                *dir_sizes.get_mut(&parent).unwrap() += size;
            }

            visited.insert(full_path);
        }
        else if lines[idx].starts_with("$ cd "){
            let rel = &lines[idx][5..].to_owned();
            if rel == ".." {
                current_path.pop();
            } else {
                current_path.push(lines[idx][5..].to_owned());
            }
        }

        idx += 1;
    }

    let ans1: usize = dir_sizes.values().filter(|x| *x < &100000).sum();

    let unused = 70000000 - dir_sizes.get("//").unwrap();
    let needed = 30000000 - unused;

    let ans2 = dir_sizes.values().filter(|&x| x >= &needed).min().unwrap();

    println!("A: {}, B: {}", ans1, ans2);
}
