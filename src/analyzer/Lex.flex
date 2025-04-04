package analyzer;

//Java Libraries
import java.util.ArrayList;

class Yytoken{
    public String token;
    public int line;
    public int column;
    public int length;
    public String type;
    public boolean error;

    Yytoken(String token, int line, int column, String type, boolean error){
        this.token = token;
        this.line = line+1;
        this.column = column+1;
        this.length = token.length()-1;
        this.type = type;
        this.error = error;
    }

    public String toString(){
        int aux = column + length;
        if(this.type.equals("T_Identifier")){
            if(token.length() > 31){
                String temp = this.token.substring(0,31);
                String aditional = this.token.substring(31);
                return temp + "\t\tLine "+line+"\tcols "+column+"-"+aux+"\tis "+ type + " Number of characters greater than 31 - Discarded characters {"+aditional+"}";
            }
            else{
                return token + "\t\tLine "+line+"\tcols "+column+"-"+aux+"\tis "+ type;
            }
        }
        else{
            return token + "\t\tLine "+line+"\tcols "+column+"-"+aux+"\tis "+ type;
        }
    }

    public String isError(){
        int aux = column + length;
        return "*** Error Léxico. Linea: " +line+ " Columnas: "+column+"-"+aux+" *** Mensaje Error: " + type + " \'" + token +"\'";
    }
}

%%
/* Options and declarations */
%class LexicalScanner
%public
%unicode
%char
%line
%column

/* Java code */

%init{
this.tokens = new ArrayList<Yytoken>();
%init}

%{
public ArrayList<Yytoken> tokens; /* our variable for storing token's info that will be the output */

    private String typeReservedWords(String text) {
        return  text.substring(0, 1).toUpperCase() + text.substring(1);
    }

    private String typeNumbers(String text, String type) {
        return type + " (value = " + text + ")";
    }

    private String isError(String token, int line, int column, int length, String error) {
        int aux = column + length;
        return "*** Line " + line + " *** Cols " + column + "-" + aux + " *** " + error + " \'" + token + "\'";
    }

%}

/*Macro Definition*/

/* Reserved words */
Int = ("int")
Double = ("double")
Bool = ("bool")
String = ("string")
Null = ("null")
For = ("for")
While = ("while")
If = ("if")
Else = ("else")
Void = ("void")
Class = ("class")
Interface = ("interface")
Extends = ("extends")
This = ("this")
Print = ("Print")
Implements = ("implements")
NewArray = ("NewArray")
New = ("New")
ReadInteger = ("ReadInteger")
ReadLine = ("ReadLine")
Malloc = ("Malloc")
GetByte = ("GetByte")
SetByte = ("SetByte")
Return = ("return")
Break = ("break")

/* Identifiers */
Identifiers = [a-zA-Z]([a-zA-Z0-9_])*

/* White spaces */
LineTerminator = (\r)|(\n)|(\r\n)
Space          = (" ")|(\t)|(\t\f)

WhiteSpace     = {LineTerminator}|{Space}

/* Comments */
InputCharacter   = [^\r\n]

MultiLineComment = ("/*"~"*/")
MultiLineCommentError = ("/*")([^"*/"])*
LineComment = ("//"){InputCharacter}*{LineTerminator}?

Comments = {MultiLineComment} | {LineComment}

/* Constants */
LogicalConstants = ("true")|("false")

// Integer Constants
DecimalNumbers     = [0-9]+
HexadecimalNumbers = "0"[xX][0-9a-fA-F]+

IntegerConstants   = {DecimalNumbers} | {HexadecimalNumbers}

// Double Constants
Digits = [0-9]+
FloatNumbers = ({Digits})([\.])([0-9]*)
ExponentialNumbers = ([+-]?)({FloatNumbers})([eE][+-]?)({Digits})

DoubleConstants = {FloatNumbers} | {ExponentialNumbers}

// Strings Constants
StringConstants = (\"([^\n\\\"]|\\.)*\")
UnrecognizedCharacters = (\")

// Operators
ArithmeticOperators = ("*")|("/")|("%")
SumOperator = ("+")
NegativeOperator = ("-")
ComparisonOperators = ("<")|("<=")|(">")|(">=")
EqualityOperators = ("==")|("!=")
LogicalAnd = ("&&")
LogicalOr = ("||")
AssignmentOperator = ("=")
DenialOperator = ("!")

// Punctuation characters
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
Dot= (".")

%%

/*  Lexical rules    */

{UnrecognizedCharacters}    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "caracter desconocido", true)); /* It's error so it doesn't return nothing */}
/*  Reserved Words  */
{Int} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{Double} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{Bool} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{String} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{Null} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{For} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{While} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{If} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{Else} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{Void} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{Class} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{Interface} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{Extends} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{This} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{Print} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{Implements} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{NewArray} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{New} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{ReadInteger} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{ReadLine} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{Malloc} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{GetByte} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{SetByte} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{Return} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
{Break} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false));}
/*  Constants   */
/* Constants */
{LogicalConstants} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Constante Lógica", false));}
{IntegerConstants} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeNumbers(yytext(), "Constante Entera"), false));}
{DoubleConstants} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeNumbers(yytext(), "Constante Decimal"), false));}
{StringConstants} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Cadena", false));}
/* Operadores */
{ArithmeticOperators} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Operador Aritmético", false));}
{SumOperator} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Operador de Suma", false));}
{NegativeOperator} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Operador Negativo", false));}
{ComparisonOperators} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Operador de Comparación", false));}
{EqualityOperators} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Operador de Igualdad", false));}
{LogicalAnd} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Operador Lógico AND", false));}
{LogicalOr} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Operador Lógico OR", false));}
{AssignmentOperator} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Operador de Asignación", false));}
{DenialOperator} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Operador de Negación", false));}
/* Puntuación */
{OpeningParenthesis} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Paréntesis Abierto", false));}
{ClosedParenthesis} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Paréntesis Cerrado", false));}
{Parenthesis} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Paréntesis", false));}
{OpeningBracket} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Corchete Abierto", false));}
{ClosedBracket} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Corchete Cerrado", false));}
{Brackets} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Corchetes", false));}
{OpeningCurlyBracket} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Llave Abierta", false));}
{ClosedCurlyBracket} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Llave Cerrada", false));}
{CurlyBrackets} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Llaves", false));}
{Semicolon} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Punto y Coma", false));}
{Comma} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Coma", false));}
{Dot} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Punto", false));}
/* Identificadores */
{Identifiers} {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Identificador", false));}
{WhiteSpace} { /* ignorar */ }
{Comments} { /* ignorar */ }

/* Errores */
. {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Carácter no reconocido", true));}
{MultiLineCommentError} {this.tokens.add(new Yytoken("", yyline, yycolumn, "No se encontró el carácter '*/'", true));}
