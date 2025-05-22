package View;

import java.util.*;

public class ClassSymbol {
    public String name;
    public List<String> baseTypes = new ArrayList<>();
    public Map<String, String> methods = new HashMap<>(); // nombre → tipoRetorno
    public boolean isInterface;

    public ClassSymbol(String name, boolean isInterface) {
        this.name = name;
        this.isInterface = isInterface;
    }

    public void addMethod(String name, String returnType) {
        methods.put(name, returnType);
    }

    public boolean hasMethod(String name) {
        return methods.containsKey(name);
    }

    public String getMethodType(String name) {
        return methods.get(name);
    }
}
