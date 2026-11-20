// A line loop and a small delimiter example, not the command parser.
// Input: name:some text
// Output: left=[name] right=[some text]
// A line without ':' prints ERR and the loop continues.
// QUIT prints BYE and stops; EOF stops silently.
//
// read_line appends to its output array. Finish using the current line's
// slices before clearing/refilling it on the next iteration.
import os;
import std;

fn main() {
    var line: u8[>..] = [];
    loop {
        line.clear();
        if !read_line(line) { break; }
        if line == "QUIT" {
            print("BYE");
            break;
        }

        let at = position(line, ':');
        if at < 0 {
            print("ERR");
            continue;
        }
        let left: u8[:] = line[..at];
        let right: u8[:] = line[at + 1..];
        print("left=[", left, "] right=[", right, "]");
    }
}
