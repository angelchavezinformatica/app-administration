import ply.lex as lex


class SQLLexer:
    # Lista de tokens
    tokens = (
        'SELECT', 'INSERT', 'UPDATE', 'DELETE', 'CREATE',
        'TABLE', 'FROM', 'INTO', 'VALUES', 'SET', 'WHERE',
        'COMMA', 'SEMICOLON', 'LPAREN', 'RPAREN', 'EQUAL',
        'STAR', 'LESS', 'GREATER', 'IDENTIFIER', 'NUMBER', 'STRING'
    )

    # Reglas de expresiones regulares para tokens simples
    t_SELECT = r'SELECT'
    t_INSERT = r'INSERT'
    t_UPDATE = r'UPDATE'
    t_DELETE = r'DELETE'
    t_CREATE = r'CREATE'
    t_TABLE = r'TABLE'
    t_FROM = r'FROM'
    t_INTO = r'INTO'
    t_VALUES = r'VALUES'
    t_SET = r'SET'
    t_WHERE = r'WHERE'
    t_COMMA = r','
    t_SEMICOLON = r';'
    t_LPAREN = r'\('
    t_RPAREN = r'\)'
    t_EQUAL = r'='
    t_STAR = r'\*'
    t_LESS = r'<'
    t_GREATER = r'>'
    t_ignore = ' \t'

    # Expresión regular para identificadores
    def t_IDENTIFIER(self, t):
        r'[a-zA-Z_][a-zA-Z_0-9]*'
        return t

    # Expresión regular para numeros
    def t_NUMBER(self, t):
        r'\d+'
        t.value = int(t.value)
        return t

    # Expresión regular para comillas
    def t_STRING(self, t):
        r'\'[^\']*\''
        t.value = t.value[1:-1]  # Quita las comillas
        return t

    # Manejo de nuevas lineas
    def t_newline(self, t):
        r'\n+'
        t.lexer.lineno += len(t.value)

    # Manejo de errores
    def t_error(self, t):
        print(f"Illegal character '{t.value[0]}'")
        t.lexer.skip(1)

    # Crear el lexer
    def build(self, **kwargs):
        self.lexer = lex.lex(module=self, **kwargs)

    # Ejecutar el lexer
    def test(self, data: str):
        self.lexer.input(data)
        while True:
            token = self.lexer.token()
            if token is None:
                break
            yield {
                'type': token.type,
                'value': token.value
            }


if __name__ == '__main__':
    from lexer.sql_lexer_query import QUERYS

    lexer = SQLLexer()
    lexer.build()

    for query in QUERYS:
        print(query)
        for token in lexer.test(query):
            print(token)
        print('-'*20)
