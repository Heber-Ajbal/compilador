/* User code */
package lexical.scanner.mini.c;

//Java Libraries

import java.util.ArrayList;
import java_cup.runtime.Symbol;

class Yytoken{
    public String token;
    public int line;
    public int column;
    public int length;
    public String type;
    public boolean error;
    public String color;

    Yytoken(String token, int line, int column, String type, boolean error,String color){
        this.token = token;
        this.line = line+1;
        this.column = column+1;
        this.length = token.length()-1;
        this.type = type;
        this.error = error;
        this.color = color;
    }

     Yytoken(String token, int line, int column, String type, boolean error) {
            this(token, line, column, type, error, "#000000"); // o cualquier color por defecto
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
%cup
%public
%unicode
//%caseless //Case sensitive
%char
%line
%column

/* Java code */

%init{
this.tokens = new ArrayList<Yytoken>();
%init}

%{

private Symbol symbol(int type){
    return new Symbol(type, yyline, yycolumn, yytext());
}

private Symbol symbol(int type, Object value){
    return new Symbol(type, yyline, yycolumn, value);
}

public ArrayList<Yytoken> tokens; /* our variable for storing token's info that will be the output */

private String typeReservedWords(String text){
    return  "T_" + text.substring(0, 1).toUpperCase() + text.substring(1);
}

private String typeNumbers(String text, String type){
    return type + " (value = " + text + ")";
}

private String isError(String token, int line, int column, int length, String error){
    int aux = column + length;
    return "*** Line " +line+ " *** Cols "+column+"-"+aux+" *** " + error + " \'" + token +"\'";
}

private String getColorForType(String tipo) {
    return switch (tipo.toLowerCase()) {
        case "tipo de dato","t_int", "t_double", "t_bool", "t_void" -> "#8B5CF6"; // tipos de datos
        case "t_identifier" -> "#000000";
        case "t_logicalconstant", "t_intconstant", "t_doubleconstant", "t_string" -> "#10B981"; // constantes
        case "unrecognized char", "the character '*/' wasn't found" -> "#FF1493"; // errores
        case "operador","+", "-", "*", "/", "%", "=", "==", "!=", "<", ">", "<=", ">=", "&&", "||", "!" -> "#fb5404"; // operadores
        case "signo de puntuación",";", ",", ".", "(", ")", "[", "]", "{", "}" -> "#E11D48"; // puntuación
        case "directiva de procesamiento" -> "#DB3069";
        case "cadena" -> "#F59E0B";
        case "comentario" -> "#1bb400";
        default -> "#2563EB"; // palabras reservadas por defecto
    };
}


%}

/* Reserved Words */
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
New = ("new") | ("New")
NewArray = ("newarray") | ("NewArray")
Null = ("null")
Object = ("object")
Operator = ("operator")
Out = ("out")
Override = ("override")
Params = ("params")
Print = ("print") | ("Print")
Private = ("private")
Protected = ("protected")
Public = ("public")
ReadInteger = ("readinteger") | ("ReadInteger")
ReadLine = ("readline") | ("ReadLine")
Readonly = ("readonly")
Ref = ("ref")
Return = ("return")
Sbyte = ("sbyte")
Sealed = ("sealed")
SetByte = ("setbyte") | ("SetByte")
Short = ("short")
Sizeof = ("sizeof")
Stackalloc = ("stackalloc")
Static = ("static")
String = ("string") | ("String")
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
Elsepros = ("#else")
Endifpros = ("#endif")
Linepros = ("#line")
Errorpros = ("#error")
Regionpros = ("#region")
Endregionpros = ("#endregion")
Nullablepros = ("#nullable")
Pragmapros = ("#pragma")
Get = ("get")
Set = ("set")
Value = ("value")
Var = ("var")
Async = ("async")
Await = ("await")
Yield = ("yield")
Dynamic = ("dynamic")
From = ("from")
Select = ("select")
Where = ("where")
Join = ("join")
Group = ("group")
Into = ("into")
Orderby = ("orderby")
Let = ("let")
On = ("on")
By = ("by")
Equals = ("equals")
Add = ("add")
Remove = ("remove")
Global = ("global")
Nameof = ("nameof")
Required = ("required")
With = ("with")
File = ("file")
Scoped = ("scoped")
Init = ("init")
Record = ("record")

/* Identifiers */
Identifiers = [a-zA-Z_]([a-zA-Z0-9_])*
NamespaceName = [a-zA-Z_][a-zA-Z0-9_]*(\.[a-zA-Z_][a-zA-Z0-9_]*)*

/* White Spaces */
LineTerminator = (\r)|(\n)|(\r\n)
Space = (" ")|(\t)|(\t\f)
WhiteSpace = {LineTerminator}|{Space}

/* Comments */
InputCharacter = [^\r\n]
MultiLineComment = ("/*"~"*/")
MultiLineCommentError = ("/*")[^"*/"]*
LineComment = ("//"){InputCharacter}*{LineTerminator}?
Comments = {MultiLineComment} | {LineComment}

/* Constants */
LogicalConstants = ("true")|("false")

// Integer Constants
DecimalNumbers = [0-9]+
HexadecimalNumbers = "0"[xX][0-9a-fA-F]+
IntegerConstants = {DecimalNumbers} | {HexadecimalNumbers}

// Double Constants
Digits = [0-9]+
FloatNumbers = ({Digits})([\.])([0-9]*)
ExponentialNumbers = ([+-]?){FloatNumbers}([eE][+-]?){Digits}
DoubleConstants = {FloatNumbers} | {ExponentialNumbers}

// String Constants
StringConstants = (\"([^\n\\\"]|\\.)*\")
InterpolatedString = \$\"([^\"\\\n{}]|\\.|(\{[^}]*\}))*\"
UnrecognizedCharacters = (\")
CharLiteral = \'([^\'\\\n]|\\[abfnrtv0\'\"\\])\'

/* Operators */
ArithmeticOperators = ("*")|("/")|("%")
SumOperator = ("+")
NegativeOperator = ("-")
ComparisonOperators = ("<")|("<=")|(">")|(">=")
EqualityOperators = ("==")|("!=")
LogicalAnd = ("&&")
LogicalOr = ("||")
AssignmentOperator = ("=")
DenialOperator = ("!")

// Additional Operators
IncrementOperator = ("++")
DecrementOperator = ("--")
AddAssign = ("+=")
SubAssign = ("-=")
MulAssign = ("*=")
DivAssign = ("/=")
ModAssign = ("%=")
BitwiseAnd = ("&")
BitwiseOr = ("|")
BitwiseXor = ("^")
BitwiseNot = ("~")
BitwiseLeftShift = ("<<")
BitwiseRightShift = (">>")
AndAssign = ("&=")
OrAssign = ("|=")
XorAssign = ("^=")
LeftShiftAssign = ("<<=")
RightShiftAssign = (">>=")

/* Punctuation Characters */
Colon = (":")
QuestionMark = ("?")
Arrow = ("=>")
OpeningParenthesis = ("(")
ClosedParenthesis = (")")
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

/*  Lexical rules    */

{UnrecognizedCharacters}    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Unrecognized char", true)); /* It's error so it doesn't return nothing */}
/*  Reserved Words  */
{Int}            { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("tipo de dato"))); return symbol(sym.INT); }
{Double}         { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("tipo de dato"))); return symbol(sym.DOUBLE); }
{Bool}           { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("tipo de dato"))); return symbol(sym.BOOL); }
{String}         { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("tipo de dato"))); return symbol(sym.STRING); }
{Void}           { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("tipo de dato"))); return symbol(sym.sVoid); }

{Null}           { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sNull); }
{For}            { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.lFor); }
{While}          { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.lWhile); }
{If}             { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.cIf); }
{Else}           { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.cElse); }
{Class}          { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sClass); }
{Interface}      { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sInterface); }
{Extends}        { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sExtends); }
{This}           { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sThis); }
{Print}          { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sPrint); }
{Implements}     { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sImplements); }
{NewArray}       { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sNewArray); }
{New}            { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sNew); }
{ReadInteger}    { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sReadInteger); }
{ReadLine}       { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sReadLine); }
{Malloc}         { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sMalloc); }
{GetByte}        { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sGetByte); }
{SetByte}        { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sSetByte); }
{Return}         { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sReturn); }
{Break}          { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sBreak); }
{As}             { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Base}           { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Byte}           { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Case}           { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Catch}       { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Char}        { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Checked}     { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Const}       { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Continue}    { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Decimal}     { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("tipo de dato"))); return symbol(sym.sAbstract); }
{Delegate}    { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Default}     { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Do}          { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Enum}        { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Event}       { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Explicit}    { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Extern}      { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{False}       { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("t_logicalconstant"))); return symbol(sym.sAbstract); }
{Fixed}       { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Float}       { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("tipo de dato"))); return symbol(sym.sAbstract); }
{Foreach}     { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Goto}        { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Implicit}    { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{In}          { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Internal}    { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Is}          { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("operador"))); return symbol(sym.sAbstract); }
{Lock}        { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract); }
{Long}                   {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Namespace}              {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sNameSpace);}
{Object}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Operator}               {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Out}                    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Override}               {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sOverride);}
{Params}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Private}                {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sPrivate);}
{Protected}              {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sProtected);}
{Public}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sPublic);}
{Readonly}               {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Sbyte}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Ref}                    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Sealed}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Short}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Sizeof}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Stackalloc}             {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Static}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sStatic);}
{Struct}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Switch}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Throw}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{True}                   {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Try}                    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Typeof}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Uint}                    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Ulong}                   {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Unchecked}               {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Unsafe}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Ushort}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Using}                   {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sUsing);}
{Virtual}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sVirtual);}
{Volatile}                {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Get}                     {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sGet);}
{Set}                     {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sSet);}
{Value}                   {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Var}                     {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Async}                   {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Await}                   {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Yield}                   {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Dynamic}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{From}                    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Select}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Where}                   {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Join}                    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Group}                   {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Into}                    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Orderby}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Let}                     {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{On}                      {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{By}                      {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Equals}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Add}                     {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Remove}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Global}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Nameof}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Required}                {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{With}                    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{File}                    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Scoped}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Init}                    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}
{Record}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false, getColorForType("palabra reservada"))); return symbol(sym.sAbstract);}



/*Directiva de Procesamiento*/
{Definepros}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Directiva de Procesamiento", false,getColorForType("Directiva de Procesamiento"))); return symbol(sym.Definepros);}
{Undefpros}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Directiva de Procesamiento", false,getColorForType("Directiva de Procesamiento"))); return symbol(sym.Definepros);}
{Ifpros}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Directiva de Procesamiento", false,getColorForType("Directiva de Procesamiento"))); return symbol(sym.Definepros);}
{Elifpros}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Directiva de Procesamiento", false,getColorForType("Directiva de Procesamiento"))); return symbol(sym.Definepros);}
{Elsepros}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Directiva de Procesamiento", false,getColorForType("Directiva de Procesamiento"))); return symbol(sym.Definepros);}
{Endifpros}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Directiva de Procesamiento", false,getColorForType("Directiva de Procesamiento"))); return symbol(sym.Definepros);}
{Linepros}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Directiva de Procesamiento", false,getColorForType("Directiva de Procesamiento"))); return symbol(sym.Definepros);}
{Errorpros}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Directiva de Procesamiento", false,getColorForType("Directiva de Procesamiento"))); return symbol(sym.Definepros);}
{Regionpros}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Directiva de Procesamiento", false,getColorForType("Directiva de Procesamiento"))); return symbol(sym.Definepros);}
{Endregionpros}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Directiva de Procesamiento", false,getColorForType("Directiva de Procesamiento"))); return symbol(sym.Definepros);}
{Nullablepros}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Directiva de Procesamiento", false,getColorForType("Directiva de Procesamiento"))); return symbol(sym.Definepros);}
{Pragmapros}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Directiva de Procesamiento", false,getColorForType("Directiva de Procesamiento"))); return symbol(sym.Definepros);}

/*  Constants   */
{LogicalConstants}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "T_LogicalConstant", false)); return symbol(sym.boolConstant);}
{IntegerConstants}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeNumbers(yytext(), "T_IntConstant"), false)); return symbol(sym.integerConstant);}
{DoubleConstants}           {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeNumbers(yytext(), "T_DoubleConstant"), false)); return symbol(sym.doubleConstant);}
{StringConstants}           {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeNumbers(yytext(), "T_String"), false)); return symbol(sym.stringConstant);}

{InterpolatedString}           {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "T_String", false)); return symbol(sym.stringConstant);}
{CharLiteral}           {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "caracter", false)); return symbol(sym.stringConstant);}


{ArithmeticOperators}       {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.ArithmeticOperators);}
{ComparisonOperators}       {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.ComparisonOperators);}
{SumOperator}               {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.sum);}
{NegativeOperator}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.negative);}
{EqualityOperators}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.equality);}
{LogicalAnd}                {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.and);}
{LogicalOr}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.or);}
{AssignmentOperator}        {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.assignment);}
{DenialOperator}            {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.denial);}
{OpeningParenthesis}        {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.OpeningParenthesis);}
{ClosedParenthesis}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.ClosedParenthesis);}

{OpeningBracket}            {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.OpeningBracket);}
{ClosedBracket}             {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.ClosedBracket);}
{Brackets}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.Brackets);}
{OpeningCurlyBracket}       {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.OpeningCurlyBracket);}
{ClosedCurlyBracket}        {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.ClosedCurlyBracket);}
{CurlyBrackets}             {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.CurlyBrackets);}
{Semicolon}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.pyc);}
{Comma}                     {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.comma);}
{Dot}                       {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.dot);}


{Colon}                       {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("signo de puntuación"))); return symbol(sym.dot);}
{QuestionMark}                {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("signo de puntuación"))); return symbol(sym.dot);}
{Arrow}                       {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("signo de puntuación"))); return symbol(sym.dot);}




{IncrementOperator}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("operador"))); return symbol(sym.dot);}
{DecrementOperator}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("operador"))); return symbol(sym.dot);}
{AddAssign}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("operador"))); return symbol(sym.dot);}
{SubAssign}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("operador"))); return symbol(sym.dot);}
{MulAssign}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("operador"))); return symbol(sym.dot);}
{DivAssign}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("operador"))); return symbol(sym.dot);}
{ModAssign}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("operador"))); return symbol(sym.dot);}
{BitwiseAnd}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("operador"))); return symbol(sym.dot);}
{BitwiseOr}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("operador"))); return symbol(sym.dot);}
{BitwiseXor}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("operador"))); return symbol(sym.dot);}
{BitwiseNot}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("operador"))); return symbol(sym.dot);}
{BitwiseLeftShift}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("operador"))); return symbol(sym.dot);}
{BitwiseRightShift}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("operador"))); return symbol(sym.dot);}
{AndAssign}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("operador"))); return symbol(sym.dot);}
{OrAssign}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("operador"))); return symbol(sym.dot);}
{XorAssign}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("operador"))); return symbol(sym.dot);}
{LeftShiftAssign}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("operador"))); return symbol(sym.dot);}
{RightShiftAssign}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false,getColorForType("operador"))); return symbol(sym.dot);}



/*  Identifiers  */
{Identifiers}               {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "T_Identifier", false)); return symbol(sym.ident);}
{NamespaceName}  { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "T_Identifier", false)); return symbol(sym.namespaceName);}
{WhiteSpace}                { /* ignore */ }
{Comments}                  { this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Comentario", false,getColorForType("comentario"))); }
/*Errors*/
.                           {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Unrecognized char", true)); /* It's error so it doesn't return nothing */}
{MultiLineCommentError}     {this.tokens.add(new Yytoken("", yyline, yycolumn, "The character '*/' wasn't found", true)); /* It's error so it doesn't return nothing */}