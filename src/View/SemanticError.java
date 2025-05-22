package View;

import java.util.ArrayList;

public class SemanticError {
    private static final ArrayList<String> errors = new ArrayList<>();

    public static void add(String msg) {
        errors.add(msg);
    }

    public static void print() {
        for (String error : errors) {
            System.err.println(error);
        }
    }

    public static boolean hasErrors() {
        return !errors.isEmpty();
    }

    public static void clear() {
        errors.clear();
    }

    public static ArrayList<String> getAll() {
        return new ArrayList<>(errors); // para mostrar en UI si es necesario
    }
}

