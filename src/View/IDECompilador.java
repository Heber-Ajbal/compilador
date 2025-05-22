package View;

import Controller.TextLineNumber;

import javax.swing.*;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.table.DefaultTableModel;
import javax.swing.text.Style;
import javax.swing.text.StyleConstants;
import javax.swing.text.StyledDocument;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class IDECompilador extends JFrame {
    private JTextPane  codeEditor;
    private JTable symbolTable, errorTable;
    private JButton openButton, executeButton, stopButton;

    public IDECompilador() {
        setTitle("IDE Compilador");
        setSize(1000, 600);
        setExtendedState(JFrame.MAXIMIZED_BOTH);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLayout(new BorderLayout());
        getContentPane().setBackground(new Color(40, 44, 52));

        // Panel superior con botones
        JPanel buttonPanel = new JPanel();
        buttonPanel.setBackground(new Color(30, 30, 30));

        openButton = createStyledButton("Abrir", new Color(50, 205, 50), "src/View/ICONOS/abrir.png");// Verde
        executeButton = createStyledButton("Ejecutar", new Color(255, 140, 0), "src/View/ICONOS/iniciar.png"); // Naranja
        stopButton = createStyledButton("Detener", new Color(220, 20, 60), "src/View/ICONOS/parar.png");// Rojo

        buttonPanel.add(openButton);
        buttonPanel.add(executeButton);
        buttonPanel.add(stopButton);

        add(buttonPanel, BorderLayout.NORTH);

        // Panel principal dividido en dos: Editor de código y tabla de símbolos
        JSplitPane mainSplitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
        mainSplitPane.setResizeWeight(0.95);

        // Área de código
        codeEditor = new JTextPane ();
        codeEditor.setBackground(new Color(230, 230, 230));
        codeEditor.setForeground(Color.BLACK);
        codeEditor.setCaretColor(Color.WHITE);
        codeEditor.setCaretPosition(0);
        codeEditor.setFont(new Font("Monospaced", Font.PLAIN,19 ));
        JScrollPane codeScrollPane = new JScrollPane(codeEditor);
        TextLineNumber lineNumberView = new TextLineNumber(codeEditor);
        codeScrollPane.setRowHeaderView(lineNumberView);

        // Panel derecho con tabla de símbolos
        String[] columnNames = {"Token", "Tipo", "linea"};
        DefaultTableModel symbolModel = new DefaultTableModel(columnNames, 0);
        symbolTable = new JTable(symbolModel);
        symbolTable.setBackground(new Color(60, 63, 65));
        symbolTable.setForeground(Color.WHITE);
        JScrollPane tableScrollPane = new JScrollPane(symbolTable);

        mainSplitPane.setLeftComponent(codeScrollPane);
        mainSplitPane.setRightComponent(tableScrollPane);

        // Panel inferior con tabla de errores
        String[] errorColumns = {"Error"};
        DefaultTableModel errorModel = new DefaultTableModel(errorColumns, 0);
        errorTable = new JTable(errorModel);
        errorTable.setBackground(new Color(50, 50, 50));
        errorTable.setForeground(Color.RED);
        JScrollPane errorScrollPane = new JScrollPane(errorTable);

        JSplitPane verticalSplitPane = new JSplitPane(JSplitPane.VERTICAL_SPLIT, mainSplitPane, errorScrollPane);
        verticalSplitPane.setResizeWeight(0.8);
        add(verticalSplitPane, BorderLayout.CENTER);

        StyledDocument doc = codeEditor.getStyledDocument();

        Style keywordStyle = codeEditor.addStyle("Keyword", null);
        StyleConstants.setForeground(keywordStyle, Color.BLUE);
        StyleConstants.setBold(keywordStyle, true);

        Style normalStyle = codeEditor.addStyle("Normal", null);
        StyleConstants.setForeground(normalStyle, Color.WHITE);


        executeButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                symbolModel.setRowCount(0);
                errorModel.setRowCount(0);

                ArrayList<Yytoken> lexicalTokens = null;
                ArrayList<String> syntacticErrors = null;
                boolean lexErrors = false;

                try {
                    String code = codeEditor.getText(); // obtener texto del editor
                    doc.remove(0, doc.getLength());     // limpia el área
                    doc.insertString(0, code, normalStyle); // muestra todo el código original

                    InputStream inputStream = new ByteArrayInputStream(code.getBytes());
                    BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
                    LexicalScanner lexer = new LexicalScanner(reader);
                    SyntacticAnalyzer parser = new SyntacticAnalyzer(lexer);
                    parser.parse();

                    lexicalTokens = lexer.tokens;
                    syntacticErrors = parser.SyntacticErrors;
                    analizarSemantico(lexicalTokens);

                    for (String semErr : SemanticError.getAll()) {
                        Object[] errorRow = {semErr};
                        errorModel.addRow(errorRow);
                    }

                    String content = "";
                    int cursor = 0;

                    for (Yytoken token : lexicalTokens) {
                        // Mostramos el token en el editor con color
                        int index = code.indexOf(token.token, cursor);
                        if (index >= 0) {
                            Style style = codeEditor.addStyle("tokenStyle", null);
                            if (token.color != null) {
                                StyleConstants.setForeground(style, Color.decode(token.color));
                            }

                            if (token.type.equalsIgnoreCase("keyword") || token.type.equalsIgnoreCase("type")) {
                                StyleConstants.setBold(style, true);
                            }

                            doc.setCharacterAttributes(index, token.token.length(), style, true);
                            cursor = index + token.token.length();
                        }

                        // Agregamos a la tabla de símbolos
                        Object[] row = {token.token, token.type, token.line};
                        symbolModel.addRow(row);

                        // Si hay error léxico
                        if (token.error) {
                            Object[] errorRow = {token.isError()};
                            errorModel.addRow(errorRow);
                            content += token.isError() + "\r\n";
                            lexErrors = true;
                        }
                    }

                    // Errores sintácticos
                    for (String element : syntacticErrors) {
                        Object[] errorRow = {element};
                        errorModel.addRow(errorRow);
                        content += element + "\r\n";
                    }

                    if (!lexErrors && syntacticErrors.isEmpty()) {
                        JOptionPane.showMessageDialog(null,
                                "El código es léxica y sintácticamente correcto.",
                                "Correcto", JOptionPane.INFORMATION_MESSAGE);
                    } else {
                        JOptionPane.showMessageDialog(null,
                                "Se encontraron errores. Revisa el panel de errores.",
                                "Errores", JOptionPane.ERROR_MESSAGE);
                    }

                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }


        });

        //cargar nuestro archivo al editor de texto
        openButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                JFileChooser fileChooser = new JFileChooser();
                fileChooser.setDialogTitle("Seleccionar archivo C#");
                int result = fileChooser.showOpenDialog(null);

                if (result == JFileChooser.APPROVE_OPTION) {
                    File selectedFile = fileChooser.getSelectedFile();

                    try (BufferedReader reader = new BufferedReader(new FileReader(selectedFile))) {
                        codeEditor.setText(""); // limpia el editor
                        String line;
                        while ((line = reader.readLine()) != null) {
                            codeEditor.getDocument().insertString(codeEditor.getDocument().getLength(), line + "\n", null);
                        }
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        JOptionPane.showMessageDialog(null, "Error al leer el archivo", "Error", JOptionPane.ERROR_MESSAGE);
                    }
                }
            }
        });

        stopButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String cupFilePath = "C:\\Users\\omarm\\IdeaProjects\\Compilador\\src\\analyzer\\Syntactic.cup";
                File cupFile = new File(cupFilePath);

                if (cupFile.exists()) {
                    try {
                        String[] args = {"-parser", "SyntacticAnalyzer", cupFilePath}; // Cambia el nombre del parser si es necesario

                        java_cup.Main.main(args);

                        JOptionPane.showMessageDialog(null,
                                "El archivo Syntactic.cup se ha compilado correctamente.",
                                "Éxito", JOptionPane.INFORMATION_MESSAGE);

                    } catch (Exception exe) {
                        JOptionPane.showMessageDialog(null,
                                "No se pudo compilar el archivo Syntactic.cup.\n" + exe.getMessage(),
                                "Error", JOptionPane.ERROR_MESSAGE);
                        exe.printStackTrace();
                    }
                } else {
                    JOptionPane.showMessageDialog(null,
                            "El archivo Syntactic.cup no fue encontrado en la ruta especificada.",
                            "Error", JOptionPane.ERROR_MESSAGE);
                }
            }
        });

    }


    public static void analizarSemantico(List<Yytoken> tokens) {
        SymbolTable.clear();
        SemanticError.clear();

        SymbolTable.openScope();  // ámbito global

        Set<String> palabrasClaveIgnorar = Set.of(
                "using", "namespace", "class", "public", "private", "protected", "static", "override", "virtual",
                "System", "Main", "get", "set"
        );

        for (int i = 0; i < tokens.size(); i++) {
            Yytoken t = tokens.get(i);

            if (palabrasClaveIgnorar.contains(t.token)) continue;

            // Ignorar identificadores después de keywords estructurales
            if (i > 0) {
                String anterior = tokens.get(i - 1).token;
                if (palabrasClaveIgnorar.contains(anterior)) continue;
            }

            // Manejo de ámbito por llaves
            if (t.token.equals("{")) {
                SymbolTable.openScope();
                continue;
            } else if (t.token.equals("}")) {
                SymbolTable.closeScope();
                continue;
            }

            boolean isConst = (i > 0 && tokens.get(i - 1).token.equals("const"));

            // Declaración de variables
            if (i > 0 && tokens.get(i - 1).token.matches("int|double|bool|string") && t.type.equals("T_Identifier")) {
                String nombre = t.token;
                if (SymbolTable.exists(nombre)) {
                    SemanticError.add("Error semántico: Variable '" + nombre + "' ya declarada en ámbito (línea " + t.line + ")");
                } else {
                    SymbolTable.add(nombre, new MySymbol(nombre, tokens.get(i - 1).token, t.line, isConst));
                }
                continue;
            }

            // Verificar tipo en asignación: tipo ident = literal;
            // Verificar tipo en asignaciones tipo: tipo nombre = expr;
            if (i >= 2 && tokens.get(i - 2).token.matches("int|double|bool|string") &&
                    tokens.get(i - 1).type.equals("T_Identifier") &&
                    t.token.equals("=")) {

                String tipoDeclarado = tokens.get(i - 2).token;
                String nombreVar = tokens.get(i - 1).token;

                // buscar fin de la expresión (hasta ; o fin de línea)
                int finExpr = i + 1;
                while (finExpr < tokens.size() && !tokens.get(finExpr).token.equals(";") && !tokens.get(finExpr).token.equals(")")) {
                    finExpr++;
                }

                String tipoExpr = inferirTipoExpr(tokens, i + 1);

                if (tipoExpr.equals("error")) {
                    SemanticError.add("Error semántico: Expresión inválida al asignar a '" + nombreVar + "' (línea " + t.line + ")");
                } else if (!tipoDeclarado.equals(tipoExpr)) {
                    SemanticError.add("Error semántico: No se puede asignar tipo '" + tipoExpr +
                            "' a la variable '" + nombreVar + "' de tipo '" + tipoDeclarado + "' (línea " + t.line + ")");
                }
            }


            // Uso de identificadores como funciones o miembros conocidos
            if (t.token.equals("CalcularAreaCirculo")) continue;

            // Uso de identificador no declarado (si no es parte de declaración)
            boolean esDeclaracion = (i > 0 && tokens.get(i - 1).token.matches("int|double|bool|string"));
            if (t.type.equals("T_Identifier") && !SymbolTable.exists(t.token) && !esDeclaracion) {
                SemanticError.add("Error semántico: Variable o miembro '" + t.token + "' usada sin declarar (línea " + t.line + ")");
            }

            // Detectar declaración de función: int nombreFuncion ( ...
            if (i + 4 < tokens.size()
                    && tokens.get(i).token.matches("int|double|bool|string|void")
                    && tokens.get(i + 1).type.equals("T_Identifier")
                    && tokens.get(i + 2).token.equals("(")) {

                CurrentContext.setFunctionType(tokens.get(i).token);
            }

            // Validar retorno
            if (t.token.equals("return") || t.token.equals("sReturn")) {
                String expected = CurrentContext.get();
                if (expected == null) continue;

                // si sigue inmediatamente ";" y el tipo no es void => error
                if (i + 1 < tokens.size() && tokens.get(i + 1).token.equals(";")) {
                    if (!expected.equals("void")) {
                        SemanticError.add("Error semántico: La función debe retornar un valor de tipo '" + expected +
                                "', pero el return está vacío (línea " + t.line + ")");
                    }
                } else if (i + 1 < tokens.size()) {
                    // hay una expresión después de return
                    String tipoExpr = inferirTipoExpr(tokens, i + 1);
                    if (tipoExpr.equals("error")) {
                        SemanticError.add("Error semántico: Retorno inválido en la función (línea " + t.line + ")");
                    } else if (!expected.equals("void") && !expected.equals(tipoExpr)) {
                        SemanticError.add("Error semántico: La función espera retornar '" + expected +
                                "', pero se retorna '" + tipoExpr + "' (línea " + t.line + ")");
                    } else if (expected.equals("void") && !tipoExpr.equals("desconocido")) {
                        SemanticError.add("Error semántico: La función es 'void' y no debe retornar ningún valor (línea " + t.line + ")");
                    }
                }
            }

            // Detectar declaración de función: tipo nombre ( param1, param2 )
            if (i + 4 < tokens.size()
                    && tokens.get(i).token.matches("int|double|bool|string|void")
                    && tokens.get(i + 1).type.equals("T_Identifier")
                    && tokens.get(i + 2).token.equals("(")) {

                String returnType = tokens.get(i).token;
                String funcName = tokens.get(i + 1).token;

                List<String> paramTypes = new ArrayList<>();
                int j = i + 3;
                while (j < tokens.size() && !tokens.get(j).token.equals(")")) {
                    if (tokens.get(j).token.matches("int|double|bool|string")) {
                        paramTypes.add(tokens.get(j).token);
                    }
                    j++;
                }

                FunctionTable.add(new FunctionSymbol(funcName, returnType, paramTypes));
                CurrentContext.setFunctionType(returnType);
            }

            // Validar llamada a función
            if (t.type.equals("T_Identifier") && i + 1 < tokens.size() && tokens.get(i + 1).token.equals("(")) {
                String funcName = t.token;

                if (!FunctionTable.exists(funcName)) {
                    SemanticError.add("Error semántico: La función '" + funcName + "' no ha sido declarada (línea " + t.line + ")");
                    continue;
                }

                // Validar cantidad y tipo de argumentos
                FunctionSymbol def = FunctionTable.get(funcName);
                List<String> argumentos = new ArrayList<>();
                int j = i + 2;
                while (j < tokens.size() && !tokens.get(j).token.equals(")")) {
                    if (!tokens.get(j).token.equals(",") && !tokens.get(j).token.equals("(")) {
                        String tipoArg = inferirTipoLiteral(tokens.get(j));
                        if (tipoArg.equals("desconocido") && SymbolTable.exists(tokens.get(j).token)) {
                            tipoArg = SymbolTable.get(tokens.get(j).token).type;
                        }
                        argumentos.add(tipoArg);
                    }
                    j++;
                }

                if (argumentos.size() != def.paramTypes.size()) {
                    SemanticError.add("Error semántico: La función '" + funcName + "' espera " + def.paramTypes.size()
                            + " argumento(s), pero se proporcionaron " + argumentos.size() + " (línea " + t.line + ")");
                } else {
                    for (int k = 0; k < argumentos.size(); k++) {
                        if (!argumentos.get(k).equals(def.paramTypes.get(k))) {
                            SemanticError.add("Error semántico: El argumento " + (k + 1) + " en la llamada a '" + funcName
                                    + "' debe ser de tipo '" + def.paramTypes.get(k)
                                    + "', pero se proporcionó '" + argumentos.get(k) + "' (línea " + t.line + ")");
                        }
                    }
                }
            }

            if (t.type.equals("T_Identifier") && i + 1 < tokens.size() && tokens.get(i + 1).token.equals("=")) {
                String nombre = t.token;
                if (SymbolTable.exists(nombre)) {
                    MySymbol simbolo = SymbolTable.get(nombre);
                    if (simbolo.isConst) {
                        SemanticError.add("Error semántico: No se puede asignar a la constante '" + nombre +
                                "' (declarada en línea " + simbolo.line + "), línea " + t.line);
                    }
                }
            }

            // Detectar clase o interfaz
            if (i + 1 < tokens.size() && tokens.get(i).token.equals("class") && tokens.get(i + 1).type.equals("T_Identifier")) {
                String className = tokens.get(i + 1).token;
                boolean isInterface = tokens.get(i).token.equals("interface");

                ClassSymbol cls = new ClassSymbol(className, isInterface);

                // Detectar herencia / implementación
                int j = i + 2;
                if (j < tokens.size() && tokens.get(j).token.equals(":")) {
                    j++;
                    while (j < tokens.size() && !tokens.get(j).token.equals("{")) {
                        if (tokens.get(j).type.equals("T_Identifier")) {
                            cls.baseTypes.add(tokens.get(j).token);
                        }
                        j++;
                    }
                }

                TypeTable.add(cls);
            }

            
        }



        SymbolTable.closeScope(); // cerrar ámbito global
    }

    private static String inferirTipoLiteral(Yytoken token) {
        if (token.type.contains("IntConstant")) return "int";
        if (token.type.contains("DoubleConstant")) return "double";
        if (token.type.contains("String")) return "string";
        if (token.type.contains("LogicalConstant") || token.token.equals("true") || token.token.equals("false")) return "bool";
        return "desconocido";
    }

    private static String inferirTipoExpr(List<Yytoken> tokens, int inicio) {
        // Soporta expr simples como: 5, "hola", true, 1 + 2, true && false
        String tipo = inferirTipoLiteral(tokens.get(inicio));
        if (tipo.equals("desconocido") && SymbolTable.exists(tokens.get(inicio).token)) {
            tipo = SymbolTable.get(tokens.get(inicio).token).type;
        }

        int i = inicio + 1;
        while (i + 1 < tokens.size()) {
            String op = tokens.get(i).token;
            Yytoken siguiente = tokens.get(i + 1);

            String tipo2 = inferirTipoLiteral(siguiente);
            if (tipo2.equals("desconocido") && SymbolTable.exists(siguiente.token)) {
                tipo2 = SymbolTable.get(siguiente.token).type;
            }

            if (tipo2.equals("desconocido")) break;

            // Reglas simples de promoción de tipo
            if ((tipo.equals("int") && tipo2.equals("double")) || (tipo.equals("double") && tipo2.equals("int"))) {
                tipo = "double";
            } else if (!tipo.equals(tipo2)) {
                // Si son distintos e incompatibles: string + int, bool + int, etc.
                return "error";
            }

            i += 2; // avanzar al siguiente operador
        }

        return tipo;
    }



    private JButton createStyledButton(String text, Color color, String iconPath) {
        JButton button = new JButton(text);
        button.setBackground(color);
        button.setForeground(Color.WHITE);
        button.setFocusPainted(false);
        button.setBorderPainted(false);
        button.setFont(new Font("Arial", Font.BOLD, 14));
        button.setPreferredSize(new Dimension(120, 40));

        // Cargar y redimensionar icono
        ImageIcon icon = new ImageIcon(iconPath);
        Image img = icon.getImage();
        Image resizedImg = img.getScaledInstance(24, 24, Image.SCALE_SMOOTH);
        button.setIcon(new ImageIcon(resizedImg));

        return button;
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new IDECompilador().setVisible(true));
    }



}
