fn add(x: i64, y: i64) -> i64 {
    return x + y;
}

fn main() {
    var total: i64 = 0;
    for n in 1..5 {
        total = add(total, n);
        print("n=", n, " total=", total);
    }
}
