// Exercise 3: stdin and parsing. Do not implement storage yet.
//
// Read until EOF or QUIT. Print ERR for a malformed/unknown command and
// continue reading. EOF stops silently; QUIT prints BYE and stops.
//
// Grammar (case-sensitive):
//   SET key value   -> SET key=[key] value=[value]
//   GET key         -> GET key=[key]
//   DEL key         -> DEL key=[key]
//   QUIT            -> BYE
//
// Use one ASCII space between the operation and key, and one to introduce
// SET's value. Keys are nonempty and contain no ASCII whitespace (bytes
// 9..13 or 32). Values are nonempty and comprise ALL remaining bytes after
// that one delimiter, including any extra leading/internal/trailing spaces.
// Thus "SET k " has an empty value and is invalid; "SET k  " has a
// one-space value and is valid. Do not trim the input.
// GET/DEL accept exactly one key and no trailing spaces/extra arguments.
// QUIT accepts no arguments. Blank lines are malformed.
//
// Example input:
// SET greeting hello goose
// GET greeting
// DEL greeting
// SET greeting
// GET greeting extra
// GET another
// QUIT
// GET ignored
//
// Expected output:
// SET key=[greeting] value=[hello goose]
// GET key=[greeting]
// DEL key=[greeting]
// ERR
// ERR
// GET key=[another]
// BYE
//
// Useful pieces (see 03-demo.goose):
// - import os makes read_line available as a global function.
// - read_line(line) appends bytes; clear before each read.
// - import std provides position(slice, ' '): first index, or -1.
// - Validate an index BEFORE using it as a slice boundary.
// - position(tail, ' ') returns an index relative to tail, not line.
// - if/else chooses a branch; break exits the loop; continue starts over.
// - slices borrow line; use them only for the current command.
//
// Keep this one exercise small: main plus a parsing/printing helper is
// enough. No dictionary, owned key copies, or store responses yet.
// Sources:
// https://aardappel.github.io/goose/docs/stdlib.html#os
// https://aardappel.github.io/goose/docs/stdlib.html#arrays-reading-and-searching
// https://aardappel.github.io/goose/docs/tutorial.html#7-slices-that-cannot-dangle
import os;
import std;

fn is_whitespace(chr: u8) -> bool {
    for i in 9..14 {
        if chr == i {
            return true;
        }
    }

    if chr == 32 {
        return true;
    }

    return false;
}

fn main() {
    // Your attempt goes here.
    var line: u8[>..] = [];

    loop {
        line.clear();

        if !read_line(line) {
            break;
        }

        if line == "QUIT" {
            print("BYE");
            break;
        }

        let cmd_at = position(line, ' ');
        // print("cmd_at=", cmd_at);
        if cmd_at < 0 {
            print("ERR");
            continue;
        }

        let left: u8[:] = line[..cmd_at];
        let right: u8[:] = line[cmd_at + 1..];

        // print("left=`", left, "` right=`", right, "`");

        let cmd: u8[:] = left;

        let valid_command = cmd == "SET" || cmd == "GET" || cmd == "DEL";
        if !valid_command {
            print("ERR");
            continue;
        }

        let key_at = position(right, ' ');
        // print("key_at=", key_at);
        if cmd == "SET" && key_at < 0 {
            print("ERR");
            continue;
        }

        var key: u8[:] = right[..0];
        var val: u8[:] = right[..0];

        // print("key_at=", key_at, " val.len=", val.len);

        if key_at < 0 {
            key = right[..];
        } else {
            key = right[..key_at];
            val = right[key_at + 1..];
        }

        if cmd == "SET" && val.len <= 0 {
            print("ERR");
            continue;
        }

        if cmd != "SET" && key_at >= 0 {
            print("ERR");
            continue;
        }

        // Validate the key
        var invalid: bool = false;
        for k in key {
            if is_whitespace(k) {
                invalid = true;
                break;
            }
        }
        if invalid {
            print("ERR");
            continue;
        }

        if cmd == "SET" {
            print(cmd, " key=[", key, "] value=[", val, "]");
        } else {
            print(cmd, " key=[", key, "]");
        }
    }
}
