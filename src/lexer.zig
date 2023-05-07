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
        const token: Token = switch (self.ch) {
            '=' => .{ .type = TokenType.Assign, .value = "=" },
            ';' => .{ .type = TokenType.Semicolon, .value = ";" },
            '(' => .{ .type = TokenType.LParen, .value = "(" },
            ')' => .{ .type = TokenType.RParen, .value = ")" },
            ',' => .{ .type = TokenType.Comma, .value = "," },
            '+' => .{ .type = TokenType.Plus, .value = "+" },
            '{' => .{ .type = TokenType.LBrace, .value = "{" },
            '}' => .{ .type = TokenType.RBrace, .value = "}" },
            0 => .{ .type = TokenType.Eof, .value = "" },
            else => unreachable,
        };

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
        .{ .type = TokenType.Assign, .value = "=" },
        .{ .type = TokenType.Plus, .value = "+" },
        .{ .type = TokenType.LParen, .value = "(" },
        .{ .type = TokenType.RParen, .value = ")" },
        .{ .type = TokenType.LBrace, .value = "{" },
        .{ .type = TokenType.RBrace, .value = "}" },
        .{ .type = TokenType.Comma, .value = "," },
        .{ .type = TokenType.Semicolon, .value = ";" },
        .{ .type = TokenType.Eof, .value = "" },
    };

    var l = Lexer.init(input);

    for (tt) |expected| {
        const actual: Token = l.nextToken();

        try testing.expectEqual(expected.type, actual.type);
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
//         .{ .type = TokenType.Let, .value = "let" },
//         .{ .type = TokenType.Identifier, .value = "five" },
//         .{ .type = TokenType.Assign, .value = "=" },
//         .{ .type = TokenType.Int, .value = "5" },
//         .{ .type = TokenType.Semicolon, .value = ";" },
//         // let ten = 10;
//         .{ .type = TokenType.Let, .value = "let" },
//         .{ .type = TokenType.Identifier, .value = "five" },
//         .{ .type = TokenType.Assign, .value = "=" },
//         .{ .type = TokenType.Int, .value = "10" },
//         .{ .type = TokenType.Semicolon, .value = ";" },
//         // let add = fn(x, y) {
//         .{ .type = TokenType.Let, .value = "let" },
//         .{ .type = TokenType.Identifier, .value = "add" },
//         .{ .type = TokenType.Assign, .value = "=" },
//         .{ .type = TokenType.Function, .value = "fn" },
//         .{ .type = TokenType.LParen, .value = "(" },
//         .{ .type = TokenType.Identifier, .value = "five" },
//         .{ .type = TokenType.Comma, .value = "," },
//         .{ .type = TokenType.Identifier, .value = "ten" },
//         .{ .type = TokenType.RParen, .value = ")" },
//         .{ .type = TokenType.LBrace, .value = "{" },
//         // x + y;
//         .{ .type = TokenType.Identifier, .value = "x" },
//         .{ .type = TokenType.Plus, .value = "+" },
//         .{ .type = TokenType.Identifier, .value = "y" },
//         .{ .type = TokenType.Semicolon, .value = ";" },
//         // };
//         .{ .type = TokenType.RBrace, .value = "}" },
//         .{ .type = TokenType.Semicolon, .value = ";" },
//         // let result = add(five, ten);
//         .{ .type = TokenType.Let, .value = "let" },
//         .{ .type = TokenType.Identifier, .value = "result" },
//         .{ .type = TokenType.Assign, .value = "=" },
//         .{ .type = TokenType.Identifier, .value = "add" },
//         .{ .type = TokenType.LParen, .value = "(" },
//         .{ .type = TokenType.Identifier, .value = "five" },
//         .{ .type = TokenType.Comma, .value = "," },
//         .{ .type = TokenType.Identifier, .value = "ten" },
//         .{ .type = TokenType.RParen, .value = ")" },
//         .{ .type = TokenType.Semicolon, .value = ";" },
//         .{ .type = TokenType.Eof, .value = "" },
//     };
//
//     var l = Lexer.init(input);
//
//     for (tt) |expected| {
//         const actual = l.nextToken();
//         try testing.expectEqual(expected.type, actual.type);
//         try testing.expectEqualStrings(expected.value, actual.value);
//     }
// }
