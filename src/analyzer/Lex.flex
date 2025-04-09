package analyzer;

// Java Libraries
import java.util.ArrayList;

class Yytoken {
    public String token;
    public int line;
    public int column;
    public int length;
    public String type;
    public boolean error;
    public String color;

    Yytoken(String token, int line, int column, String type, boolean error, String color) {
        this.token = token;
        this.line = line + 1;
        this.column = column + 1;
        this.length = token.length() - 1;
        this.type = type;
        this.error = error;
        this.color = color;
    }

    public String toString() {
        int aux = column + length;
        return token + "\t\tLínea " + line + "\tcolumnas " + column + "-" + aux + "\tes " + type + "\tColor: " + color;
    }

    public String isError() {
        int aux = column + length;
        return "*** Error Léxico. Línea: " + line + " Columnas: " + column + "-" + aux + " *** Mensaje de Error: " + type + " '" + token + "'";
    }
}

%%
%class LexicalScanner
%public
%unicode
%char
%line
%column

%init{
this.tokens = new ArrayList<Yytoken>();
%init}

%{
public ArrayList<Yytoken> tokens;

    private String getColorForType(String tipo) {
        return switch (tipo.toLowerCase()) {
            case "palabra reservada" -> "#569CD6";
            case "tipo de dato" -> "#0000FF";
            case "identificador" -> "#FFFFFF";
            case "número" -> "#b5cea8";
            case "cadena" -> "#D69D85";
            case "operador" -> "#e9ccc0";
            case "signo de puntuación" -> "#dbb69a";
            case "directiva de procesamiento" -> "#fff333";
            case "error" -> "#FF1493";
            default -> "#AAAAAA";
        };
    }
%}

/* Definiciones de macros */
Abstract = ("abstract")
As = ("as")
Base = ("base")
Bool = ("bool")
Break = ("break")
Byte = ("byte")
Case = ("case")
Catch = ("catch")
Char = ("char")
Checked = ("checked")
Class = ("class")
Const = ("const")
Continue = ("continue")
Decimal = ("decimal")
Delegate = ("delegate")
Default = ("default")
Do = ("do")
Double = ("double")
Else = ("else")
Enum = ("enum")
Event = ("event")
Explicit = ("explicit")
Extends = ("extends")
Extern = ("extern")
False = ("false")
Finally = ("finally")
Fixed = ("fixed")
Float = ("float")
For = ("for")
Foreach = ("foreach")
GetByte = ("getbyte")
Goto = ("goto")
If = ("if")
Implements = ("implements")
Implicit = ("implicit")
In = ("in")
Int = ("int")
Interface = ("interface")
Internal = ("internal")
Is = ("is")
Lock = ("lock")
Long = ("long")
Malloc = ("malloc")
Namespace = ("namespace")
New = ("new")
NewArray = ("newarray")
Null = ("null")
Object = ("object")
Operator = ("operator")
Out = ("out")
Override = ("override")
Params = ("params")
Print = ("print")
Private = ("private")
Protected = ("protected")
Public = ("public")
ReadInteger = ("readinteger")
ReadLine = ("readline")
Readonly = ("readonly")
Ref = ("ref")
Return = ("return")
Sbyte = ("sbyte")
Sealed = ("sealed")
SetByte = ("setbyte")
Short = ("short")
Sizeof = ("sizeof")
Stackalloc = ("stackalloc")
Static = ("static")
String = ("string")
Struct = ("struct")
Switch = ("switch")
This = ("this")
Throw = ("throw")
True = ("true")
Try = ("try")
Typeof = ("typeof")
Uint = ("uint")
Ulong = ("ulong")
Unchecked = ("unchecked")
Unsafe = ("unsafe")
Ushort = ("ushort")
Using = ("using")
Virtual = ("virtual")
Void = ("void")
Volatile = ("volatile")
While = ("while")
Definepros = ("#define")
Undefpros = ("#undef")
Ifpros = ("#if")
Elifpros = ("#elif")
Elsepros= ("#else")
Endifpros = ("#endif")
Linepros = ("#line")
Errorpros= ("#error")
Regionpros = ("#region")
Endregionpros = ("#endregion")
Nullablepros = ("#nullable")
Pragmapros = ("#pragma")


Identifiers = [a-zA-Z]([a-zA-Z0-9_])*
LineTerminator = (\r)|(\n)|(\r\n)
Space = (" ")|(\t)|(\t\f)
WhiteSpace = {LineTerminator}|{Space}
InputCharacter = [^\r\n]
MultiLineComment = ("/*"~"*/")
MultiLineCommentError = ("/*")[^"*/"]*
LineComment = ("//"){InputCharacter}*{LineTerminator}?
Comments = {MultiLineComment} | {LineComment}
LogicalConstants = ("true")|("false")
DecimalNumbers = [0-9]+
HexadecimalNumbers = "0"[xX][0-9a-fA-F]+
IntegerConstants = {DecimalNumbers} | {HexadecimalNumbers}
Digits = [0-9]+
FloatNumbers = ({Digits})([\.])([0-9]*)
ExponentialNumbers = ([+-]?){FloatNumbers}([eE][+-]?){Digits}
DoubleConstants = {FloatNumbers} | {ExponentialNumbers}
StringConstants = (\"([^\n\\\"]|\\.)*\")
UnrecognizedCharacters = (\")

ArithmeticOperators = ("*")|("/")|("%")
SumOperator = ("+")
NegativeOperator = ("-")
ComparisonOperators = ("<")|("<=")|(">")|(">=")
EqualityOperators = ("==")|("!=")
LogicalAnd = ("&&")
LogicalOr = ("||")
AssignmentOperator = ("=")
DenialOperator = ("!")

OpeningParenthesis = ("(")
ClosedParenthesis = (")")
Parenthesis = ("()")
OpeningBracket = ("[")
ClosedBracket = ("]")
Brackets = ("[]")
OpeningCurlyBracket = ("{")
ClosedCurlyBracket = ("}")
CurlyBrackets = ("{}")
Semicolon = (";")
Comma = (",")
Dot = (".")

%%
{UnrecognizedCharacters} {
    String tipo = "error";
    this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, tipo, true, getColorForType(tipo)));
}

{Int}|{Double}|{Bool}|{String}|{Void} {
    String tipo = "tipo de dato";
    this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, tipo, false, getColorForType(tipo)));
}

{Abstract}|{As}|{Base}|{Bool}|{Break}|{Byte}|{Case}|{Catch}|{Char}|{Checked}|{Class}|{Const}|{Continue}|{Decimal}|{Delegate}|{Default}|{Do}|{Double}|{Else}|{Enum}|{Event}|{Explicit}|{Extends}|{Extern}|{False}|{Finally}|{Fixed}|{Float}|{For}|{Foreach}|{GetByte}|{Goto}|{If}|{Implements}|{Implicit}|{In}|{Int}|{Interface}|{Internal}|{Is}|{Lock}|{Long}|{Malloc}|{Namespace}|{New}|{NewArray}|{Null}|{Object}|{Operator}|{Out}|{Override}|{Params}|{Print}|{Private}|{Protected}|{Public}|{ReadInteger}|{ReadLine}|{Readonly}|{Ref}|{Return}|{Sbyte}|{Sealed}|{SetByte}|{Short}|{Sizeof}|{Stackalloc}|{Static}|{String}|{Struct}|{Switch}|{This}|{Throw}|{True}|{Try}|{Typeof}|{Uint}|{Ulong}|{Unchecked}|{Unsafe}|{Ushort}|{Using}|{Virtual}|{Void}|{Volatile}|{While} {
    String tipo = "palabra reservada";
    this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, tipo, false, getColorForType(tipo)));
}


{LogicalConstants} | {IntegerConstants} | {DoubleConstants} {
    String tipo = "número";
    this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, tipo, false, getColorForType(tipo)));
}

{StringConstants} {
    String tipo = "cadena";
    this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, tipo, false, getColorForType(tipo)));
}

{ArithmeticOperators}|{SumOperator}|{NegativeOperator}|{ComparisonOperators}|{EqualityOperators}|{LogicalAnd}|{LogicalOr}|{AssignmentOperator}|{DenialOperator} {
    String tipo = "operador";
    this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, tipo, false, getColorForType(tipo)));
}

{OpeningParenthesis}|{ClosedParenthesis}|{Parenthesis}|{OpeningBracket}|{ClosedBracket}|{Brackets}|{OpeningCurlyBracket}|{ClosedCurlyBracket}|{CurlyBrackets}|{Semicolon}|{Comma}|{Dot} {
    String tipo = "signo de puntuación";
    this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, tipo, false, getColorForType(tipo)));
}

{Identifiers} {
    String tipo = "identificador";
    this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, tipo, false, getColorForType(tipo)));
}

{WhiteSpace} {/* ignorar */}

{Comments} {
    String tipo = "comentario";
    this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, tipo, false, getColorForType(tipo)));
}

{MultiLineCommentError} {
    String tipo = "error";
    this.tokens.add(new Yytoken("", yyline, yycolumn, "No se encontró el carácter '*/'", true, getColorForType(tipo)));
}

. {
    String tipo = "error";
    this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, tipo, true, getColorForType(tipo)));
}

{Definepros}|{Undefpros}|{Ifpros}|{Elifpros}|{Elsepros}|{Endifpros}|{Linepros}|{Errorpros}|{Regionpros}|{Endregionpros}|{Nullablepros}|{Pragmapros} {
    String tipo = "Directiva de Procesamiento";
    this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, tipo, false, getColorForType(tipo)));
}

