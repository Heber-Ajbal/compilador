package View;

import Controller.TextLineNumber;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import javax.swing.text.*;
import java.awt.*;
import java.io.*;
import java.util.ArrayList;

public class IDECompilador extends JFrame {
    private JTextPane codeEditor;
    private JTable symbolTable, errorTable;
    private JButton openButton, executeButton, stopButton;
    private JScrollPane codeScrollPane;
    private TextLineNumber lineNumberView;

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

        openButton = createStyledButton("Abrir", new Color(50, 205, 50), "src/View/ICONOS/abrir.png");
        executeButton = createStyledButton("Ejecutar", new Color(255, 140, 0), "src/View/ICONOS/iniciar.png");
        stopButton = createStyledButton("Detener", new Color(220, 20, 60), "src/View/ICONOS/parar.png");

        buttonPanel.add(openButton);
        buttonPanel.add(executeButton);
        buttonPanel.add(stopButton);

        add(buttonPanel, BorderLayout.NORTH);

        // Área de código
        codeEditor = new JTextPane();
        codeEditor.setBackground(Color.WHITE);
        codeEditor.setForeground(Color.BLACK);
        codeEditor.setCaretColor(Color.BLACK);
        codeEditor.setFont(new Font("Monospaced", Font.PLAIN, 19));

        codeScrollPane = new JScrollPane(codeEditor);

        // Crear y asignar UNA vez el TextLineNumber
        lineNumberView = new TextLineNumber(codeEditor);
        codeScrollPane.setRowHeaderView(lineNumberView);

        // Panel derecho con tabla de símbolos
        String[] columnNames = {"Token", "Tipo", "linea"};
        DefaultTableModel symbolModel = new DefaultTableModel(columnNames, 0);
        symbolTable = new JTable(symbolModel);
        symbolTable.setBackground(new Color(60, 63, 65));
        symbolTable.setForeground(Color.WHITE);
        JScrollPane tableScrollPane = new JScrollPane(symbolTable);

        JSplitPane mainSplitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, codeScrollPane, tableScrollPane);
        mainSplitPane.setResizeWeight(0.95);

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

        executeButton.addActionListener(e -> {
            symbolModel.setRowCount(0);
            errorModel.setRowCount(0);

            try {
                String code = codeEditor.getText();

                // Asignar texto con setText para evitar problemas con documento
                codeEditor.setText(code);

                // Obtener documento para estilos
                StyledDocument doc = codeEditor.getStyledDocument();

                // Limpia estilos previos
                doc.setCharacterAttributes(0, doc.getLength(), codeEditor.getStyle("default"), true);

                InputStream inputStream = new ByteArrayInputStream(code.getBytes());
                BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
                LexicalScanner lexer = new LexicalScanner(reader);
                SyntacticAnalyzer parser = new SyntacticAnalyzer(lexer);
                parser.parse();

                ArrayList<Yytoken> lexicalTokens = lexer.tokens;
                ArrayList<String> syntacticErrors = parser.SyntacticErrors;

                int cursor = 0;
                boolean lexErrors = false;

                for (Yytoken token : lexicalTokens) {
                    int index = code.indexOf(token.token, cursor);
                    if (index >= 0) {
                        Style style = codeEditor.addStyle("tokenStyle", null);
                        if (token.color != null) {
                            StyleConstants.setForeground(style, Color.decode(token.color));
                        }
                        if ("keyword".equalsIgnoreCase(token.type) || "type".equalsIgnoreCase(token.type)) {
                            StyleConstants.setBold(style, true);
                        }
                        doc.setCharacterAttributes(index, token.token.length(), style, true);
                        cursor = index + token.token.length();
                    }
                    symbolModel.addRow(new Object[]{token.token, token.type, token.line});
                    if (token.error) {
                        errorModel.addRow(new Object[]{token.isError()});
                        lexErrors = true;
                    }
                }

                for (String err : syntacticErrors) {
                    errorModel.addRow(new Object[]{err});
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

                // El truco: Remover y volver a poner el TextLineNumber para reiniciar la numeración
                codeScrollPane.setRowHeaderView(null);
                codeScrollPane.setRowHeaderView(lineNumberView);
                lineNumberView.repaint();

            } catch (Exception ex) {
                ex.printStackTrace();
            }
        });

        openButton.addActionListener(e -> {
            JFileChooser fileChooser = new JFileChooser();
            fileChooser.setDialogTitle("Seleccionar archivo C#");
            int result = fileChooser.showOpenDialog(null);

            if (result == JFileChooser.APPROVE_OPTION) {
                File selectedFile = fileChooser.getSelectedFile();

                try (BufferedReader reader = new BufferedReader(new FileReader(selectedFile))) {
                    StringBuilder sb = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        sb.append(line).append("\n");
                    }
                    codeEditor.setText(sb.toString());
                } catch (Exception ex) {
                    ex.printStackTrace();
                    JOptionPane.showMessageDialog(null, "Error al leer el archivo", "Error", JOptionPane.ERROR_MESSAGE);
                }
            }
        });

        stopButton.addActionListener(e -> {
            String cupFilePath = "C:\\Users\\omarm\\IdeaProjects\\Compilador\\src\\analyzer\\Syntactic.cup";
            File cupFile = new File(cupFilePath);

            if (cupFile.exists()) {
                try {
                    String[] args = {"-parser", "SyntacticAnalyzer", cupFilePath};
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
        });
    }

    private JButton createStyledButton(String text, Color color, String iconPath) {
        JButton button = new JButton(text);
        button.setBackground(color);
        button.setForeground(Color.WHITE);
        button.setFocusPainted(false);
        button.setBorderPainted(false);
        button.setFont(new Font("Arial", Font.BOLD, 14));
        button.setPreferredSize(new Dimension(120, 40));

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
