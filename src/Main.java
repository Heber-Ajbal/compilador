import View.IDECompilador;

public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
        IDECompilador IDE = new IDECompilador();

        IDE.setSize(800,800);
        IDE.setLocationRelativeTo(null);
        IDE.setVisible(true);



    }
}