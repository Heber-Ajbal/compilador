package View;

import java_cup.runtime.Symbol;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.*;
import java.util.ArrayList;

public class IDECompilador extends JFrame {
    private JTextArea codeEditor;
    private JTable symbolTable, errorTable;
    private JButton openButton, executeButton, stopButton;

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
        codeEditor = new JTextArea();
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

        executeButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                symbolModel.setRowCount(0);

                try {
                    // Abre un archivo de entrada
                    String code = codeEditor.getText();
                    InputStream inputStream = new ByteArrayInputStream(code.getBytes());
                    BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
                    LexicalScanner scanner = new LexicalScanner(reader);

                    // Ejecutar el análisis léxico
                    boolean hasErrors = false; // Variable para detectar errores

                    // Ejecutar el análisis léxico
                    while (scanner.yylex() != null) {}
                    ArrayList<Yytoken> tokens = scanner.tokens;

                    for (Yytoken token : tokens) {
                        if(token.error){
                            System.out.println(token.isError());
                            Object[] errorRow = {token.isError()};
                            errorModel.addRow(errorRow);
                        }
                        Object[] row = {token.token, token.type, token.line};

                        // Agrega la fila al modelo de la tabla
                        symbolModel.addRow(row);
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
