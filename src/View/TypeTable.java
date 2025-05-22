package View;

import java.util.*;

public class TypeTable {
    private static final Map<String, ClassSymbol> classes = new HashMap<>();

    public static void add(ClassSymbol cls) {
        classes.put(cls.name, cls);
    }

    public static ClassSymbol get(String name) {
        return classes.get(name);
    }

    public static boolean exists(String name) {
        return classes.containsKey(name);
    }

    public static void clear() {
        classes.clear();
    }

    public static Collection<ClassSymbol> getAll() {
        return classes.values();
    }
}
