const testing = @import("std").testing;
const Token = @import("token.zig").Token;
const TokenType = @import("token.zig").TokenType;
const std = @import("std");

const Lexer = struct {
    input: []const u8,
    position: usize = 0,
    readPosition: usize = 0,
    ch: u8 = 0,

    pub fn init(input: []const u8) Lexer {
        var l = Lexer{ .input = input };
        l.readChar();
        return l;
    }

    pub fn nextToken(self: *Lexer) Token {
        std.debug.print("Antes: {}\n", .{self});
        const token: Token = switch (self.ch) {
            '=' => .{ .ttype = TokenType.Assign, .value = "=" },
            ';' => .{ .ttype = TokenType.Semicolon, .value = ";" },
            '(' => .{ .ttype = TokenType.LParen, .value = "(" },
            ')' => .{ .ttype = TokenType.RParen, .value = ")" },
            ',' => .{ .ttype = TokenType.Comma, .value = "," },
            '+' => .{ .ttype = TokenType.Plus, .value = "+" },
            '{' => .{ .ttype = TokenType.LBrace, .value = "{" },
            '}' => .{ .ttype = TokenType.RBrace, .value = "}" },
            0 => .{ .ttype = TokenType.Eof, .value = "" },
            else => .{ .ttype = TokenType.Eof, .value = "" },
        };
        std.debug.print("Token: {}\n", .{token});
        std.debug.print("Depois: {}\n", .{self});

        self.readChar();

        return token;
    }

    fn readChar(self: *Lexer) void {
        if (self.readPosition >= self.input.len) {
            self.ch = 0;
        } else {
            self.ch = self.input[self.readPosition];
        }

        self.position = self.readPosition;
        self.readPosition += 1;
    }
};

test "next token" {
    const input = "=+(){},;";

    const tt = [_]Token{
        .{ .ttype = TokenType.Assign, .value = "=" },
        .{ .ttype = TokenType.Plus, .value = "+" },
        .{ .ttype = TokenType.LParen, .value = "(" },
        .{ .ttype = TokenType.RParen, .value = ")" },
        .{ .ttype = TokenType.LBrace, .value = "{" },
        .{ .ttype = TokenType.RBrace, .value = "}" },
        .{ .ttype = TokenType.Comma, .value = "," },
        .{ .ttype = TokenType.Semicolon, .value = ";" },
        .{ .ttype = TokenType.Eof, .value = "" },
    };

    var l = Lexer.init(input);

    for (tt) |expected| {
        const actual: Token = l.nextToken();

        try testing.expectEqual(expected.ttype, actual.ttype);
        try testing.expectEqualStrings(expected.value, actual.value);
    }
}

// test "basic program" {
//     const input =
//         \\let five = 5;
//         \\let ten = 10;
//         \\let add = fn(x, y) {
//         \\  x + y;
//         \\};
//         \\let result = add(five, ten);
//     ;
//
//     const tt = [_]Token{
//         // let five = 5;
//         .{ .ttype = TokenType.Let, .value = "let" },
//         .{ .ttype = TokenType.Identifier, .value = "five" },
//         .{ .ttype = TokenType.Assign, .value = "=" },
//         .{ .ttype = TokenType.Int, .value = "5" },
//         .{ .ttype = TokenType.Semicolon, .value = ";" },
//         // let ten = 10;
//         .{ .ttype = TokenType.Let, .value = "let" },
//         .{ .ttype = TokenType.Identifier, .value = "five" },
//         .{ .ttype = TokenType.Assign, .value = "=" },
//         .{ .ttype = TokenType.Int, .value = "10" },
//         .{ .ttype = TokenType.Semicolon, .value = ";" },
//         // let add = fn(x, y) {
//         .{ .ttype = TokenType.Let, .value = "let" },
//         .{ .ttype = TokenType.Identifier, .value = "add" },
//         .{ .ttype = TokenType.Assign, .value = "=" },
//         .{ .ttype = TokenType.Function, .value = "fn" },
//         .{ .ttype = TokenType.LParen, .value = "(" },
//         .{ .ttype = TokenType.Identifier, .value = "five" },
//         .{ .ttype = TokenType.Comma, .value = "," },
//         .{ .ttype = TokenType.Identifier, .value = "ten" },
//         .{ .ttype = TokenType.RParen, .value = ")" },
//         .{ .ttype = TokenType.LBrace, .value = "{" },
//         // x + y;
//         .{ .ttype = TokenType.Identifier, .value = "x" },
//         .{ .ttype = TokenType.Plus, .value = "+" },
//         .{ .ttype = TokenType.Identifier, .value = "y" },
//         .{ .ttype = TokenType.Semicolon, .value = ";" },
//         // };
//         .{ .ttype = TokenType.RBrace, .value = "}" },
//         .{ .ttype = TokenType.Semicolon, .value = ";" },
//         // let result = add(five, ten);
//         .{ .ttype = TokenType.Let, .value = "let" },
//         .{ .ttype = TokenType.Identifier, .value = "result" },
//         .{ .ttype = TokenType.Assign, .value = "=" },
//         .{ .ttype = TokenType.Identifier, .value = "add" },
//         .{ .ttype = TokenType.LParen, .value = "(" },
//         .{ .ttype = TokenType.Identifier, .value = "five" },
//         .{ .ttype = TokenType.Comma, .value = "," },
//         .{ .ttype = TokenType.Identifier, .value = "ten" },
//         .{ .ttype = TokenType.RParen, .value = ")" },
//         .{ .ttype = TokenType.Semicolon, .value = ";" },
//         .{ .ttype = TokenType.Eof, .value = "" },
//     };
//
//     var l = Lexer.init(input);
//
//     for (tt) |expected| {
//         const actual = l.nextToken();
//         try testing.expectEqual(expected.ttype, actual.ttype);
//         try testing.expectEqualStrings(expected.value, actual.value);
//     }
// }
