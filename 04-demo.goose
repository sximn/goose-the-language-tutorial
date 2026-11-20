// Exercise 4 concepts: structs containing owned, variable-size byte arrays.
// Predict the borrowed output and both saved outputs before running.
// Which object owns each sequence of bytes?
//
// Source: https://aardappel.github.io/goose/docs/tutorial.html
// Sections 4 (copies), 7 (slices), and 8 (nested inline data).
struct Note {
    text: u8[]
}

fn main() {
    var notes: Note[>..] = [];
    var scratch: u8[>..] = [];
    scratch.append("red");

    let borrowed: u8[:] = scratch[..];
    var saved: Note? = null;
    saved .= notes.push(Note { text: copy(scratch) });
    scratch[0] = 'b';
    scratch.push('!');

    print("borrowed=[", borrowed, "] len=", borrowed.len);
    if saved { print("saved=[", saved.text, "]"); }

    // borrowed has no further uses, so scratch can be cleared here.
    scratch.clear();
    scratch.append("new input");
    for note in notes { print("saved after refill=[", note.text, "]"); }
}
