package View;

import javax.swing.*;
import javax.swing.filechooser.FileNameExtensionFilter;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

public class IDECompilador extends JFrame {


    private JButton button1;
    private JPanel Panel;


    private String pathLexicalAnalyzer;
    private String pathSyntacticAnalyzer;


    public IDECompilador() {
        setContentPane(Panel);
        pathLexicalAnalyzer = "";
        pathSyntacticAnalyzer = "";

//        button1.addActionListener(new ActionListener() {
//            @Override
//            public void actionPerformed(ActionEvent e) {
//                JFileChooser chooser = new JFileChooser();
//                chooser.setFileSelectionMode( JFileChooser.FILES_ONLY );
//                FileNameExtensionFilter filter = new FileNameExtensionFilter("Archivos Lexicos", "flex");
//                chooser.setFileFilter(filter);
//                int selection  = chooser.showOpenDialog(null);
//                boolean ready = false;
//
//                if(selection == JFileChooser.APPROVE_OPTION){
//                    if(chooser.getSelectedFile() != null){
//                        pathLexicalAnalyzer = chooser.getSelectedFile().getAbsolutePath();
//
//                        File file = new File(pathLexicalAnalyzer);
//
//                        if(file.exists()){
//                            try{
//                                //Compilar el archivo .Flex
//                                jflex.Main.main(new String[]{pathLexicalAnalyzer});
//
//                                JOptionPane.showMessageDialog(null,
//                                        "El archivo (.flex) ha compilado correctamente.",
//                                        "Aviso",JOptionPane.INFORMATION_MESSAGE);
//
//                                ready = true;
//                                //System.exit(0);
//                            }
//                            catch(Exception ex){
//                                JOptionPane.showMessageDialog(null,
//                                        "No se ha podido compilar el archivo (.flex).",
//                                        "ERROR",JOptionPane.ERROR_MESSAGE);
//                            }
//                        }
//                        else{
//                            JOptionPane.showMessageDialog(null,
//                                    "El archivo seleccionado no puede ser encontrado.",
//                                    "ERROR",JOptionPane.ERROR_MESSAGE);
//                        }
//                    }
//                }
//
//                if(ready){
//                    /* Cargar el archivo .cup para generar el parser */
//                    chooser.setFileSelectionMode( JFileChooser.FILES_ONLY );
//                    filter = new FileNameExtensionFilter("Archivos Sintacticos", "cup");
//                    chooser.setFileFilter(filter);
//                    selection = chooser.showOpenDialog(null);
//
//                    if(selection == JFileChooser.APPROVE_OPTION){
//                        if(chooser.getSelectedFile() != null){
//                            pathSyntacticAnalyzer = chooser.getSelectedFile().getAbsolutePath();
//
//                            File file = new File(pathSyntacticAnalyzer);
//
//                            if(file.exists()){
//                                try{
//                                    //Compilar el archivo .cup
//                                    String[] argSyntactic = {"-parser", "SyntacticAnalyzer", pathSyntacticAnalyzer};
//
//                                    java_cup.Main.main(argSyntactic);
//
//                                    JOptionPane.showMessageDialog(null,
//                                            "El archivo (.cup) ha compilado correctamente.",
//                                            "Aviso",JOptionPane.INFORMATION_MESSAGE);
//
//                                    boolean movFileSym = MoveFiles("C:\\Users\\bryan\\Documents\\GitHub\\Lexical-scanner-Mini-C-\\Lexical Scanner Mini C#\\sym.java");
//                                    boolean movFileSyntacticAnalizer = MoveFiles("C:\\Users\\bryan\\Documents\\GitHub\\Lexical-scanner-Mini-C-\\Lexical Scanner Mini C#\\SyntacticAnalyzer.java");
//
//                                    if(movFileSym && movFileSyntacticAnalizer){
//                                        System.out.println("Generado!");
//                                        System.exit(0);
//                                    }
//                                    else{
//                                        System.out.println("Fallo en el movimiento de archivos!");
//                                        System.exit(0);
//                                    }
//
//                                }
//                                catch(Exception exception){
//                                    JOptionPane.showMessageDialog(null,
//                                            "No se ha podido compilar el archivo (.cup).",
//                                            "ERROR",JOptionPane.ERROR_MESSAGE);
//                                }
//                            }
//                            else{
//                                JOptionPane.showMessageDialog(null,
//                                        "El archivo seleccionado no puede ser encontrado.",
//                                        "ERROR",JOptionPane.ERROR_MESSAGE);
//                            }
//                        }
//                    }
//                }
//            }
//        });


    }

    public static boolean MoveFiles(String path) {
        boolean successful = false;
        File file = new File(path);
        if (file.exists()) {
            System.out.println("\n*** Moviendo: " + file + " \n***");
            Path currentRelativePath = Paths.get("");
            String newDir = currentRelativePath.toAbsolutePath().toString()
                    + File.separator + "src" + File.separator
                    + "lexical" + File.separator + "scanner" + File.separator
                    + "mini" + File.separator + "c" + File.separator + file.getName();
            File lastFile = new File(newDir);
            lastFile.delete();
            if (file.renameTo(new File(newDir))) {
                System.out.println("\n*** Generado " + file + "***\n");
                successful = true;
            } else {
                System.out.println("\n*** No movido " + file + " ***\n");
            }

        } else {
            System.out.println("\n*** Codigo no existente ***\n");
        }
        return successful;
    }

    private void createUIComponents() {
        // TODO: place custom component creation code here
    }
}
