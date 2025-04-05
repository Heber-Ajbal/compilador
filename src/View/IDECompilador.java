package View;

import java_cup.runtime.Symbol;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import javax.swing.text.Style;
import javax.swing.text.StyleConstants;
import javax.swing.text.StyledDocument;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class IDECompilador extends JFrame {
    private JTextPane  codeEditor;
    private JTable symbolTable, errorTable;
    private JButton openButton, executeButton, stopButton;
    Set<String> reservedWords = new HashSet<>(Arrays.asList(
            "IF", "WHILE", "FOR", "CLASS", "Int", "FLOAT", "RETURN",
            "PUBLIC", "STATIC", "VOID", "ELSE", "DO", "BREAK", "NEW"
    ));

    public IDECompilador() {
        setTitle("IDE Compilador");
        setSize(1000, 600);
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
        mainSplitPane.setResizeWeight(0.7);

        // Área de código
        codeEditor = new JTextPane ();
        codeEditor.setBackground(new Color(30, 30, 30));
        codeEditor.setForeground(Color.WHITE);
        codeEditor.setFont(new Font("Monospaced", Font.PLAIN, 14));
        JScrollPane codeScrollPane = new JScrollPane(codeEditor);

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


                try {

                    String code = codeEditor.getText();
                    doc.remove(0, doc.getLength()); // Limpia el área
                    doc.insertString(0, code, normalStyle); // Muestra todo el código original

                    InputStream inputStream = new ByteArrayInputStream(code.getBytes());
                    BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
                    LexicalScanner scanner = new LexicalScanner(reader);

// Ejecutar análisis léxico
                    while (scanner.yylex() != null) {}
                    ArrayList<Yytoken> tokens = scanner.tokens;

                    int cursor = 0; // posición dentro del texto original

                    for (Yytoken token : tokens) {
                        // Buscamos la próxima aparición del token desde la posición actual
                        int index = code.indexOf(token.token, cursor);

                        if (index >= 0) {
                            // Si es palabra reservada, aplicar color
                            if (reservedWords.contains(token.type)) {
                                doc.setCharacterAttributes(index, token.token.length(), keywordStyle, true);
                            }
                            cursor = index + token.token.length(); // Avanza para la próxima búsqueda
                        }

                        // Tabla de símbolos
                        Object[] row = {token.token, token.type, token.line};
                        symbolModel.addRow(row);

                        if (token.error) {
                            Object[] errorRow = {token.isError()};
                            errorModel.addRow(errorRow);
                        }
                    }

                } catch (Exception ex) {
                    ex.printStackTrace();
                }
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
