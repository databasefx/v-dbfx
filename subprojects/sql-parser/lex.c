//
// Created by yangkui on 22-6-9.
//

#include <ctype.h>
#include <stdio.h>
#include "lex.h"
#include "str-util.h"

typedef struct {
    TokenKind kind;
    String name;
} KeywordInfo;

static KeywordInfo keywords[] = {
        {AND,    "and"},
        {SELECT, "select"},
        {UPDATE, "update"},
        {INSERT, "insert"},
        {DELETE, "delete"}
};

static TokenKind SQLParser_keyword_kind(String id) {
    for (int i = 0; i < sizeof(keywords) / sizeof(keywords[0]); ++i) {
        KeywordInfo keyword = keywords[i];
        if (SQLParser_str_equal(id, keyword.name, TRUE)) {
            return keyword.kind;
        }
    }
    return ID;
}

static char SQLParser_next(SQLParser *parser) {
    String sql = parser->sql;
    Context *ctx = parser->ctx;

    int pos = ctx->pos;
    char c = *(sql + pos);
    if (c == 0) {
        c = EOF_CH;
    }
    ctx->c = c;
    ctx->pos = pos + 1;
    return c;
}

/**
 *
 * Judge whether the given character is blank
 *
 */
static bool SQLParser_white_space(char c) {
    return c == ' ' || c == '\r' || c == '\n' || c == '\t';
}


static bool SQLParser_end_symbol(char c) {
    return c == ',' || c == ' ' || c == EOF_CH;
}

extern Token SQLParser_token(SQLParser *parser) {
    char c = parser->ctx->c;

    //Skip white space
    while (SQLParser_white_space(c)) {
        c = SQLParser_next(parser);
    }

    Token token;

    if (c == EOF_CH) {
        token.kind = _EOF;
    } else {
        int len = 0;
        memset(token.value, 0, ID_MAX_LEN);
        do {
            token.value[len++] = c;
            c = SQLParser_next(parser);
        } while (!SQLParser_end_symbol(c) && len < ID_MAX_LEN);
        token.kind = SQLParser_keyword_kind(token.value);
    }
    return token;
}