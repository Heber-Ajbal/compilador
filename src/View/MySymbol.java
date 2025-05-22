package View;

public class MySymbol {
    public String name;
    public String type;
    public int line;
    public boolean isConst;

    public MySymbol(String name, String type, int line, boolean isConst) {
        this.name = name;
        this.type = type;
        this.line = line;
        this.isConst = isConst;
    }

    // Constructor para no constantes (por compatibilidad)
    public MySymbol(String name, String type, int line) {
        this(name, type, line, false);
    }
}
