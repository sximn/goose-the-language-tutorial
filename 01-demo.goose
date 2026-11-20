fn bump(n: i64) -> i64 {
    return n + 1;
}

fn main() {
    let rounds = 3;
    var count: i64 = 0;
    for i in rounds {
        count = bump(count);
        print("i=", i, " count=", count);
    }
}
