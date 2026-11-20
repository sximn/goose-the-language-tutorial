// Predict both output lines before running this file.
fn main() {
    var bytes: u8[>..] = [];
    bytes.append("red");

    let view: u8[:] = bytes[..2];
    bytes[0] = 'b';
    bytes.push('!');

    print("owner=", bytes, " len=", bytes.len);
    print("view=", view, " len=", view.len);
}
