// Exercise 4: a tiny store that scans an array. No stdin in this file yet.
// The parser from exercise 3 is complete; integration comes in exercise 8.
//
// Goal:
// - set(entries, key, value) appends one Entry with owned copies of BOTH
//   key and value, then prints OK.
// - print_get(entries, key) scans every entry, remembers the LAST match,
//   then prints VALUE followed by one space and the value, or MISSING.
// - Repeated SET appends a new version. GET must return the newest one.
// - Use the given Entry type and scripted main; implement the two helpers.
//   Inputs here are already valid; do not repeat the command parser.
//
// New concepts:
// - A struct groups named fields: Entry { key: ..., value: ... }.
// - u8[] owns bytes whose length is chosen at construction and then fixed.
// - copy(source) builds independent bytes in a field's destination.
// - Entry[>..]& passes the caller's growable entry array by reference.
// - Entries have variable sizes. Iterate them with for entry in entries;
//   the non-fixed entry is bound by reference. Do not index entries[i].
// - == compares byte-array/slice contents, not their addresses.
// - Entry? is a nullable reference, not an owned Entry or Rust Option<Entry>.
//   A remembered match can start as: var latest: Entry? = null;
// - .= rebinds a reference to another target; = writes through a narrowed
//   reference. Use .= when remembering a matching entry from the loop.
// - if latest { ... } checks for non-null and makes latest.value usable
//   inside the branch; else handles a missing key. See saved in the demo.
//
// This append-only version log is intentionally temporary: old versions
// retain their bytes until entries' scope ends, and lookup scans O(n)
// versions. Exercise 5 introduces dictionary slots; exercises 6-7 add
// reusable byte storage and replacement/deletion without retaining history.
//
// Expected output from main:
// OK
// OK
// VALUE red
// VALUE blue sky
// MISSING
// OK
// VALUE green
// versions=3
//
// Questions to answer with your attempt:
// 1. Predict 04-demo.goose's three output lines before running it.
// 2. After key_buffer/value_buffer are cleared, who owns the stored bytes?
// 3. If Entry held u8[:] fields pointing into those buffers instead, why
//    would the clear/refill strategy be a problem? What can the compiler
//    catch, and what would an in-place byte mutation do to a live slice?
//
// Sources:
// https://aardappel.github.io/goose/docs/tutorial.html#8-nested-data-stays-inline
// https://aardappel.github.io/goose/docs/reference.html#4-where-values-live
// https://aardappel.github.io/goose/docs/reference.html#7-slices
// https://aardappel.github.io/goose/docs/reference.html#10-references-and-optionals

struct Entry {
    key: u8[],
    value: u8[]
}

fn set(entries: Entry[>..]&, key: u8[:], value: u8[:]) {
    // Your implementation goes here.
    entries.push(Entry { key: key, value: value });
    // print("> entries = ", entries);
    print("OK");
}

fn print_get(entries: Entry[>..]&, key: u8[:]) {
    // Your implementation goes here.
    var last_val: u8[>..] = [];
    for entry in entries {
        if entry.key == key {
            last_val.clear();
            last_val.append(entry.value);
        }
    }
    // print("key=", key, " val=", last_val, " | entries = ", entries);
    if last_val.len == 0 {
        print("MISSING");
    } else {
        print("VALUE ", last_val);
    }
}

fn main() {
    var entries: Entry[>..] = [];
    var key_buffer: u8[>..] = [];
    var value_buffer: u8[>..] = [];

    key_buffer.append("color");
    value_buffer.append("red");
    set(entries, key_buffer, value_buffer);

    key_buffer.clear();
    value_buffer.clear();
    key_buffer.append("sky");
    value_buffer.append("blue sky");
    set(entries, key_buffer, value_buffer);

    key_buffer.clear();
    value_buffer.clear();
    print_get(entries, "color");
    print_get(entries, "sky");
    print_get(entries, "missing");

    set(entries, "color", "green");
    print_get(entries, "color");
    print("versions=", entries.len);
}
