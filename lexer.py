import ply.lex as lex

# Lista de tokens
tokens = (
    'IMPORT',
    'PACKAGE',
    'CLASS',
    'CONST',
    'FINAL',
    'REQUIRED',
    'IDENTIFIER',
    'STRING_LITERAL',
    'SYMBOL',
    'NUMBER',
    'VOID',
    'MAIN',
    'NEW',
    'RETURN',
    'WIDGET',
    'EXTENDS',
    'SUPER',
    'COLON',
    'SLASH',
    'COMMENT',
    'SINGLE_QUOTE',
    'AT',
    'QUESTION_MARK',
    'TYPE',
    'EQUALS',
    'LBRACKET',
    'RBRACKET',
    'AMPERSAND',
    'DASH',
    'BACKSLASH',
    'EXCLAMATION',
    'PIPE',
    'UNIQUE_CHARS',
    'DOLLAR_SIGN',
    'PLUS',
    'ASTERISK',
    'MINUS',
    'DIVIDE',
    'LT',  # Less than
    'GT',  # Greater than
    'MOD',  # Modulo
)

# Reglas de expresiones regulares para tokens simples
t_IMPORT = r'import'
t_PACKAGE = r'package'
t_CLASS = r'class'
t_CONST = r'const'
t_FINAL = r'final'
t_REQUIRED = r'required'
t_VOID = r'void'
t_MAIN = r'main'
t_NEW = r'new'
t_RETURN = r'return'
t_WIDGET = r'Widget'
t_EXTENDS = r'extends'
t_SUPER = r'super'

t_IDENTIFIER = r'[a-zA-Z_][a-zA-Z_0-9]*'
t_STRING_LITERAL = r'\"([^\\\n]|(\\.))*?\"'
t_SYMBOL = r'[\(\)\{\};,.<>]'
t_COLON = r':'
t_SLASH = r'/'
t_SINGLE_QUOTE = r'\''
t_AT = r'@'
t_QUESTION_MARK = r'\?'
t_EQUALS = r'='
t_LBRACKET = r'\['
t_RBRACKET = r'\]'
t_AMPERSAND = r'&&'
t_PLUS = r'\+'
t_ASTERISK = r'\*'
t_MINUS = r'-'
t_DIVIDE = r'/'
t_LT = r'<'
t_GT = r'>'
t_MOD = r'%'

# Regla para tipos de datos (int, String, double, etc.)
t_TYPE = r'\b(?:int|String|double|bool|Color)\b'

# Regla para números (integers y floats)


def t_NUMBER(t):
    r'\d+(\.\d+)?'
    t.value = float(t.value) if '.' in t.value else int(t.value)
    return t

# Regla para comentarios (inline y multi-line)


def t_COMMENT(t):
    r'//.*|/\*[\s\S]*?\*/'
    pass

# Regla para manejar caracteres únicos (Unicode)


def t_UNIQUE_CHARS(t):
    r'[áéíóúÁÉÍÓÚñÑ]'
    return t

# Nueva regla para el símbolo de dólar en literales de cadena


def t_DOLLAR_SIGN(t):
    r'\$'
    return t

# Nueva regla para manejar el guion


def t_DASH(t):
    r'-'
    return t

# Nueva regla para manejar la barra invertida


def t_BACKSLASH(t):
    r'\\'
    return t

# Nueva regla para manejar el signo de exclamación


def t_EXCLAMATION(t):
    r'!'
    return t

# Nueva regla para manejar el símbolo de barra vertical


def t_PIPE(t):
    r'\|'
    return t


# Regla para ignorar espacios en blanco, tabulaciones y nuevas líneas
t_ignore = ' \t\n'

# Manejo de errores


def t_error(t):
    line_start = t.lexer.lexdata.rfind('\n', 0, t.lexpos) + 1
    line_end = t.lexer.lexdata.find('\n', t.lexpos)
    line_end = len(t.lexer.lexdata) if line_end == -1 else line_end
    line = t.lexer.lexdata[line_start:line_end]
    column = t.lexpos - line_start
    print(
        f"Carácter ilegal '{t.value[0]}' en la línea {t.lineno}, columna {column}")
    print(f"Línea: {line}")
    t.lexer.skip(1)


# Construcción del lexer
lexer = lex.lex()

# Función para analizar código Dart


def analyze_code(code):
    lexer.input(code)
    result = []
    while True:
        tok = lexer.token()
        if not tok:
            break
        result.append((tok.type, tok.value))
    return result

# Función principal para análisis y testing automático


def main(file: str):
    with open(file, 'r', encoding='utf-8') as file:
        code = file.read()
        return analyze_code(code)


if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        tokens = main(sys.argv[1])
        for token in tokens:
            print(token)
    else:
        print("Por favor, proporciona el nombre del archivo como argumento.")
