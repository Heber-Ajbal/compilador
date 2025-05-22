package View;// FunctionSymbol.java
import java.util.List;

public class FunctionSymbol {
    public String name;
    public String returnType;
    public List<String> paramTypes;

    public FunctionSymbol(String name, String returnType, List<String> paramTypes) {
        this.name = name;
        this.returnType = returnType;
        this.paramTypes = paramTypes;
    }
}
