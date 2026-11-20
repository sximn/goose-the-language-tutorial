// Exercise 2: owned bytes, views, and an independent copy.
//
// 1. Declare an empty owned u8[>..] array named bytes.
// 2. Loop over "goose", pushing each byte into bytes.
// 3. Bind view: u8[:] to the first two bytes with bytes[..2].
// 4. Use copy(bytes) to create an independent owned array named snapshot.
// 5. Change bytes[0] to 'G', then push '!'.
// 6. Print each of bytes, view, and snapshot, including its length.
//
// Expected output:
// owner=Goose! len=6
// view=Go len=2
// snapshot=goose len=5
//
// Before coding, predict the two output lines of 02-demo.goose.
// After coding, explain which variable owns the bytes viewed by view,
// and why the array type need not specify the final length.
//
// Source: https://aardappel.github.io/goose/docs/tutorial.html
// Sections 4 (copies), 5 (arrays), 6 (strings), and 7 (slices).
fn main() {
    // Your attempt goes here.
    let bytes: u8[>..] = [];

    for c in "goose" {
        bytes.push(c);
    }

    let view: u8[:] = bytes[..2];

    let snapshot: u8[..] = copy(bytes);

    bytes[0] = 'G';
    bytes.push('!');

    print("owner=", bytes, " len=", bytes.len);
    print("view=", view, " len=", view.len);
    print("snapshot=", snapshot, " len=", snapshot.len);
}
