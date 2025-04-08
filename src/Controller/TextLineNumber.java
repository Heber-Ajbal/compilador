package Controller;

import javax.swing.*;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.text.Element;
import javax.swing.text.BadLocationException;
import java.awt.*;

public class TextLineNumber extends JPanel {
    private final JTextPane textPane;
    private final Font font = new Font("Monospaced", Font.PLAIN, 14);
    private final Color numberColor = new Color(160, 160, 160);

    public TextLineNumber(JTextPane textPane) {
        this.textPane = textPane;
        setBackground(new Color(30, 30, 30));
        setForeground(numberColor);
        setFont(font);
        setPreferredSize(new Dimension(40, Integer.MAX_VALUE));

        // Redibujar cuando el documento cambia
        textPane.getDocument().addDocumentListener(new DocumentListener() {
            public void insertUpdate(DocumentEvent e) { repaint(); }
            public void removeUpdate(DocumentEvent e) { repaint(); }
            public void changedUpdate(DocumentEvent e) { repaint(); }
        });

        // Redibujar cuando se mueve el cursor
        textPane.addCaretListener(e -> repaint());
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);

        FontMetrics fm = g.getFontMetrics(getFont());
        int lineHeight = fm.getHeight();
        int startOffset = textPane.viewToModel(new Point(0, 0));
        int endOffset = textPane.viewToModel(new Point(0, getHeight()));
        Element root = textPane.getDocument().getDefaultRootElement();
        int startLine = root.getElementIndex(startOffset);
        int endLine = root.getElementIndex(endOffset);

        g.setColor(numberColor);
        g.setFont(getFont());

        for (int i = startLine; i <= endLine; i++) {
            try {
                int lineStartOffset = root.getElement(i).getStartOffset();
                Rectangle r = textPane.modelToView(lineStartOffset);
                if (r != null) {
                    int y = r.y + r.height - 4;
                    g.drawString(String.valueOf(i + 1), 5, y);
                }
            } catch (BadLocationException ex) {
                ex.printStackTrace();
            }
        }
    }
}

