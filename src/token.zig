const std = @import("std");

// const Token = struct { type: []u8, literal: []u8 };

pub const TokenType = enum {
    Illegal,
    Eof,
    Identifier,
    Int,
    Assign,
    Plus,
    Comma,
    Semicolon,
    LParen,
    RParen,
    LBrace,
    RBrace,
    Function,
    Let,
};

pub const Token = struct {
    type: TokenType,
    value: []const u8,
};
