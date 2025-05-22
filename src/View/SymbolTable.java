package View;

// SymbolTable.java (actualízala así)
import java.util.*;

public class SymbolTable {
    private static final Stack<Map<String, MySymbol>> scopes = new Stack<>();

    public static void openScope() {
        scopes.push(new HashMap<>());
    }

    public static void closeScope() {
        if (!scopes.isEmpty()) {
            scopes.pop();
        }
    }

    public static boolean exists(String name) {
        for (int i = scopes.size() - 1; i >= 0; i--) {
            if (scopes.get(i).containsKey(name)) return true;
        }
        return false;
    }

    public static MySymbol get(String name) {
        for (int i = scopes.size() - 1; i >= 0; i--) {
            Map<String, MySymbol> scope = scopes.get(i);
            if (scope.containsKey(name)) {
                return scope.get(name);
            }
        }
        return null;
    }


    public static void add(String name, MySymbol symbol) {
        if (!scopes.isEmpty()) {
            scopes.peek().put(name, symbol);
        }
    }

    public static void clear() {
        scopes.clear();
    }

    public static List<Map<String, MySymbol>> getAllScopes() {
        return new ArrayList<>(scopes);
    }


}
