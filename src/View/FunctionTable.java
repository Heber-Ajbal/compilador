package View;// FunctionTable.java

import java.util.*;

public class FunctionTable {
    private static final Map<String, FunctionSymbol> functions = new HashMap<>();

    public static void add(FunctionSymbol function) {
        functions.put(function.name, function);
    }

    public static boolean exists(String name) {
        return functions.containsKey(name);
    }

    public static FunctionSymbol get(String name) {
        return functions.get(name);
    }

    public static void clear() {
        functions.clear();
    }

    public static Collection<FunctionSymbol> getAll() {
        return functions.values();
    }
}
