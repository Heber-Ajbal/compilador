package View;

public class CurrentContext {
    public static String currentFunctionReturnType = null;

    public static void setFunctionType(String type) {
        currentFunctionReturnType = type;
    }

    public static void clear() {
        currentFunctionReturnType = null;
    }

    public static String get() {
        return currentFunctionReturnType;
    }
}